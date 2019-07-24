# Copyright (c) 2019, The Vulkan Developers.
#
# This file is part of Vulkan.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
# You should have received a copy of the MIT License
# along with Vulkan. If not, see <https://opensource.org/licenses/MIT>.

from libc.stdint cimport *
from cpython.bytes cimport *
from cpython.string cimport *

cdef extern from "common/buffer.h":
  # structs
  cdef struct CBuffer:
    uint8_t *data
    size_t size
    size_t offset

  ctypedef CBuffer buffer_t

  # functions
  buffer_t* buffer_init_data(size_t offset, const uint8_t *data, size_t size) nogil
  buffer_t* buffer_init_size(size_t offset, size_t size) nogil
  buffer_t* buffer_init_offset(size_t offset) nogil
  buffer_t* buffer_init() nogil

  void buffer_set_data(buffer_t *buffer, const uint8_t *data, size_t size) nogil
  uint8_t* buffer_get_data(buffer_t *buffer) nogil

  void buffer_set_size(buffer_t *buffer, size_t size) nogil
  size_t buffer_get_size(buffer_t *buffer) nogil

  void buffer_set_offset(buffer_t *buffer, size_t offset) nogil
  size_t buffer_get_offset(buffer_t *buffer) nogil

  int buffer_copy(buffer_t *buffer, buffer_t *other_buffer) nogil
  int buffer_compare(buffer_t *buffer, buffer_t *other_buffer) nogil
  void buffer_clear(buffer_t *buffer) nogil
  void buffer_free(buffer_t *buffer) nogil

  int buffer_realloc(buffer_t *buffer, size_t size) nogil
  int buffer_write(buffer_t *buffer, const uint8_t *data, size_t size) nogil

  int buffer_write_uint8(buffer_t *buffer, uint8_t value) nogil
  int buffer_write_int8(buffer_t *buffer, int8_t value) nogil

  int buffer_write_uint16(buffer_t *buffer, uint16_t value) nogil
  int buffer_write_int16(buffer_t *buffer, int16_t value) nogil

  int buffer_write_uint32(buffer_t *buffer, uint32_t value) nogil
  int buffer_write_int32(buffer_t *buffer, int32_t value) nogil

  int buffer_write_uint64(buffer_t *buffer, uint64_t value) nogil
  int buffer_write_int64(buffer_t *buffer, int64_t value) nogil

  int buffer_write_bytes(buffer_t *buffer, const uint8_t *bytes, uint32_t size) nogil
  int buffer_write_string(buffer_t *buffer, const char *string, uint32_t size) nogil
  int buffer_write_bytes_long(buffer_t *buffer, const uint8_t *bytes, uint64_t size) nogil
  int buffer_write_string_long(buffer_t *buffer, const char *string, uint64_t size) nogil

cdef extern from "common/buffer_iterator.h":
  cdef struct CBufferIterator:
    const buffer_t *buffer
    size_t offset

  ctypedef CBufferIterator buffer_iterator_t

  buffer_iterator_t* buffer_iterator_init(const buffer_t *buffer) nogil
  void buffer_iterator_free(buffer_iterator_t *buffer_iterator) nogil

  void buffer_iterator_set_buffer(buffer_iterator_t *buffer_iterator, const buffer_t *buffer) nogil
  const buffer_t *buffer_iterator_get_buffer(buffer_iterator_t *buffer_iterator) nogil

  void buffer_iterator_set_offset(buffer_iterator_t *buffer_iterator, size_t offset) nogil
  size_t buffer_iterator_get_offset(buffer_iterator_t *buffer_iterator) nogil

  int buffer_iterator_compare(buffer_iterator_t *buffer_iterator, buffer_iterator_t *other_buffer_iterator) nogil
  void buffer_iterator_clear(buffer_iterator_t *buffer_iterator) nogil

  int buffer_read(buffer_iterator_t *buffer_iterator, size_t size, uint8_t **bytes) nogil
  size_t buffer_get_remaining_size(buffer_iterator_t *buffer_iterator) nogil
  uint8_t* buffer_get_remaining_data(buffer_iterator_t *buffer_iterator) nogil

  int buffer_read_uint8(buffer_iterator_t *buffer_iterator, uint8_t *value) nogil
  int buffer_read_int8(buffer_iterator_t *buffer_iterator, int8_t *value) nogil

  int buffer_read_uint16(buffer_iterator_t *buffer_iterator, uint16_t *value) nogil
  int buffer_read_int16(buffer_iterator_t *buffer_iterator, int16_t *value) nogil

  int buffer_read_uint32(buffer_iterator_t *buffer_iterator, uint32_t *value) nogil
  int buffer_read_int32(buffer_iterator_t *buffer_iterator, int32_t *value) nogil

  uint64_t buffer_read_uint64(buffer_iterator_t *buffer_iterator, uint64_t *value) nogil
  int buffer_read_int64(buffer_iterator_t *buffer_iterator, int64_t *value) nogil

  int buffer_read_bytes(buffer_iterator_t *buffer_iterator, uint8_t **bytes) nogil
  int buffer_read_string(buffer_iterator_t *buffer_iterator, char **string) nogil
  int buffer_read_bytes_long(buffer_iterator_t *buffer_iterator, uint8_t **bytes) nogil
  int buffer_read_string_long(buffer_iterator_t *buffer_iterator, char **string) nogil


class BufferError(RuntimeError):
    """
    A buffer specific runtime error
    """

class BufferIteratorError(BufferError):
    """
    A buffer iterator specific buffer error
    """

cdef class Buffer(object):
    cdef buffer_t *_buffer

    def __cinit__(self, bytes data=bytes(), size_t offset=0):
        assert(isinstance(data, bytes))
        assert(offset >= 0)
        self._buffer = buffer_init_data(offset, data, len(data))

    property data:
        def __get__(self):
            cdef const uint8_t *data = buffer_get_data(self._buffer)
            if data == NULL:
                return bytes()

            cdef size_t data_size = buffer_get_size(self._buffer)
            return PyBytes_FromStringAndSize(<const char*>data, <Py_ssize_t>data_size)

        def __set__(self, bytes data):
            if data is None:
                data = bytes()

            cdef const char *raw_data = PyBytes_AsString(data)
            if raw_data == NULL:
                raise BufferError("Failed to set data pointer, could not convert PyBytes object as string!")

            buffer_set_data(self._buffer, <const uint8_t*>raw_data, <size_t>len(data))

    property size:
        def __get__(self):
            return <Py_ssize_t>buffer_get_size(self._buffer)

        def __set__(self, size_t size):
            assert(size >= 0)
            buffer_set_size(self._buffer, size)

    property offset:
        def __get__(self):
            return <Py_ssize_t>buffer_get_offset(self._buffer)

        def __set__(self, size_t offset):
            assert(offset >= 0)
            buffer_set_offset(self._buffer, offset)

    cpdef copy(self, Buffer other_buffer):
        assert(isinstance(other_buffer, Buffer))
        cdef int result = buffer_copy(self._buffer, other_buffer._buffer)
        if result == 1:
            raise BufferError("Failed to copy buffer!")

    cpdef bint compare(self, Buffer other_buffer):
        assert(isinstance(other_buffer, Buffer))
        return buffer_compare(self._buffer, other_buffer._buffer)

    cpdef clear(self):
        buffer_clear(self._buffer)

    cpdef write(self, bytes data):
        assert(isinstance(data, bytes))
        assert(len(data) > 0)
        cdef const char *raw_data = PyBytes_AsString(data)
        if raw_data == NULL:
            raise BufferError("Failed to write data, could not convert PyBytes object as string!")

        cdef int result = buffer_write(self._buffer, <const uint8_t*>raw_data, <size_t>len(data))
        if result == 1:
            raise BufferError("Failed to write data to buffer!")

    cpdef write_uint8(self, uint8_t value):
        cdef int result = buffer_write_uint8(self._buffer, value)
        if result == 1:
            raise BufferError("Failed to write uint8 to buffer!")

    cpdef write_int8(self, int8_t value):
        cdef int result = buffer_write_int8(self._buffer, value)
        if result == 1:
            raise BufferError("Failed to write int8 to buffer!")

    cpdef write_uint16(self, uint16_t value):
        cdef int result = buffer_write_uint16(self._buffer, value)
        if result == 1:
            raise BufferError("Failed to write uint16 to buffer!")

    cpdef write_int16(self, int16_t value):
        cdef int result = buffer_write_int16(self._buffer, value)
        if result == 1:
            raise BufferError("Failed to write int16 to buffer!")

    cpdef write_uint32(self, uint32_t value):
        cdef int result = buffer_write_uint32(self._buffer, value)
        if result == 1:
            raise BufferError("Failed to write uint32 to buffer!")

    cpdef write_int32(self, int32_t value):
        cdef int result = buffer_write_int32(self._buffer, value)
        if result == 1:
            raise BufferError("Failed to write int32 to buffer!")

    cpdef write_uint64(self, uint64_t value):
        cdef int result = buffer_write_uint64(self._buffer, value)
        if result == 1:
            raise BufferError("Failed to write uint64 to buffer!")

    cpdef write_int64(self, int64_t value):
        cdef int result = buffer_write_int64(self._buffer, value)
        if result == 1:
            raise BufferError("Failed to write int64 to buffer!")

    cpdef write_bytes(self, bytes data):
        assert(isinstance(data, bytes))
        assert(len(data) > 0)
        assert(len(data) <= UINT32_MAX)
        cdef const char *raw_data = PyBytes_AsString(data)
        if raw_data == NULL:
            raise BufferError("Failed to write bytes, could not convert PyBytes object as string!")

        cdef int result = buffer_write_bytes(self._buffer, <const uint8_t*>raw_data, <size_t>len(data))
        if result == 1:
            raise BufferError("Failed to write bytes32 to buffer!")

    cpdef write_string(self, str data):
        assert(isinstance(data, str))
        assert(len(data) > 0)
        assert(len(data) <= UINT32_MAX)
        cdef const char *raw_data = PyString_AsString(data)
        if raw_data == NULL:
            raise BufferError("Failed to write string32, could not convert PyBytes object as string!")

        cdef int result = buffer_write_string(self._buffer, raw_data, <size_t>len(raw_data))
        if result == 1:
            raise BufferError("Failed to write string32 to buffer!")

    cpdef write_bytes_long(self, bytes data):
        assert(isinstance(data, bytes))
        assert(len(data) > 0)
        assert(len(data) <= UINT64_MAX)
        cdef const char *raw_data = PyBytes_AsString(data)
        if raw_data == NULL:
            raise BufferError("Failed to write bytes, could not convert PyBytes object as string!")

        cdef int result = buffer_write_bytes_long(self._buffer, <const uint8_t*>raw_data, <size_t>len(data))
        if result == 1:
            raise BufferError("Failed to write bytes64 to buffer!")

    cpdef write_string_long(self, str data):
        assert(isinstance(data, str))
        assert(len(data) > 0)
        assert(len(data) <= UINT64_MAX)
        cdef const char *raw_data = PyString_AsString(data)
        if raw_data == NULL:
            raise BufferError("Failed to write string64, could not convert PyBytes object as string!")

        cdef int result = buffer_write_string_long(self._buffer, raw_data, <size_t>len(data))
        if result == 1:
            raise BufferError("Failed to write string64 to buffer!")

    def __del__(self):
        buffer_free(self._buffer)
        self._buffer = NULL


cdef class BufferIterator(object):
    cdef Buffer _buffer
    cdef buffer_iterator_t *_buffer_iterator

    def __cinit__(self, Buffer buffer):
        assert(isinstance(buffer, Buffer))
        self._buffer = buffer
        self._buffer_iterator = buffer_iterator_init(self._buffer._buffer)

    property buffer:
        def __get__(self):
            return self._buffer

        def __set__(self, Buffer buffer):
            assert(isinstance(buffer, Buffer))
            buffer_iterator_set_buffer(self._buffer_iterator, buffer._buffer)
            self._buffer = buffer

    property offset:
        def __get__(self):
            return <Py_ssize_t>buffer_iterator_get_offset(self._buffer_iterator)

        def __set__(self, size_t offset):
            assert(offset >= 0)
            buffer_iterator_set_offset(self._buffer_iterator, offset)

    cpdef bint compare(self, BufferIterator other_buffer_iterator):
        assert(isinstance(other_buffer_iterator, BufferIterator))
        return buffer_iterator_compare(self._buffer_iterator, other_buffer_iterator._buffer_iterator)

    cpdef clear(self):
        buffer_iterator_clear(self._buffer_iterator)
        self._buffer = None

    cpdef bytes read(self, size_t size):
        assert(size > 0);
        cdef uint8_t *data = NULL
        cdef int result = buffer_read(self._buffer_iterator, size, &data)
        if result == 1:
            raise BufferIteratorError("Failed to read: %d bytes from buffer iterator!" % size)

        return PyBytes_FromStringAndSize(<char*>data, <Py_ssize_t>size)

    cpdef Py_ssize_t get_remaining_size(self):
        return <Py_ssize_t>buffer_get_remaining_size(self._buffer_iterator)

    cpdef bytes get_remaining_data(self):
        cdef const uint8_t *remaining_data = buffer_get_remaining_data(self._buffer_iterator)
        cdef size_t remaining_size = buffer_get_remaining_size(self._buffer_iterator)
        return PyBytes_FromStringAndSize(<const char*>remaining_data, <Py_ssize_t>remaining_size)

    cpdef uint8_t read_uint8(self):
        cdef uint8_t value = 0
        cdef int result = buffer_read_uint8(self._buffer_iterator, &value)
        if result == 1:
            raise BufferIteratorError("Failed to read uint8 from buffer!")

        return value

    cpdef int8_t read_int8(self):
        cdef int8_t value = 0
        cdef int result = buffer_read_int8(self._buffer_iterator, &value)
        if result == 1:
            raise BufferIteratorError("Failed to read int8 from buffer!")

        return value

    cpdef uint16_t read_uint16(self):
        cdef uint16_t value = 0
        cdef int result = buffer_read_uint16(self._buffer_iterator, &value)
        if result == 1:
            raise BufferIteratorError("Failed to read uint16 from buffer!")

        return value

    cpdef int16_t read_int16(self):
        cdef int16_t value = 0
        cdef int result = buffer_read_int16(self._buffer_iterator, &value)
        if result == 1:
            raise BufferIteratorError("Failed to read int16 from buffer!")

        return value

    cpdef uint32_t read_uint32(self):
        cdef uint32_t value = 0
        cdef int result = buffer_read_uint32(self._buffer_iterator, &value)
        if result == 1:
            raise BufferIteratorError("Failed to read uint32 from buffer!")

        return value

    cpdef int32_t read_int32(self):
        cdef int32_t value = 0
        cdef int result = buffer_read_int32(self._buffer_iterator, &value)
        if result == 1:
            raise BufferIteratorError("Failed to read int32 from buffer!")

        return value

    cpdef uint64_t read_uint64(self):
        cdef uint64_t value = 0
        cdef int result = buffer_read_uint64(self._buffer_iterator, &value)
        if result == 1:
            raise BufferIteratorError("Failed to read uint64 from buffer!")

        return value

    cpdef int64_t read_int64(self):
        cdef int64_t value = 0
        cdef int result = buffer_read_int64(self._buffer_iterator, &value)
        if result == 1:
            raise BufferIteratorError("Failed to read int64 from buffer!")

        return value

    cpdef bytes read_bytes(self):
        cdef uint32_t size = 0
        cdef int result = buffer_read_uint32(self._buffer_iterator, &size)
        if result == 1:
            raise BufferIteratorError("Failed to read bytes32 from buffer!")

        cdef uint8_t *data = NULL
        result = buffer_read(self._buffer_iterator, size, &data)
        if result == 1:
            raise BufferIteratorError("Failed to read bytes32 from buffer!")

        return PyBytes_FromStringAndSize(<const char*>data, <Py_ssize_t>size)

    cpdef bytes read_string(self):
        cdef uint32_t size = 0
        cdef int result = buffer_read_uint32(self._buffer_iterator, &size)
        if result == 1:
            raise BufferIteratorError("Failed to read bytes32 from buffer!")

        cdef uint8_t *data = NULL
        result = buffer_read(self._buffer_iterator, size, &data)
        if result == 1:
            raise BufferIteratorError("Failed to read bytes32 from buffer!")

        return PyString_FromStringAndSize(<const char*>data, <Py_ssize_t>size)

    cpdef bytes read_bytes_long(self):
        cdef uint64_t size = 0
        cdef int result = buffer_read_uint64(self._buffer_iterator, &size)
        if result == 1:
            raise BufferIteratorError("Failed to read bytes64 from buffer!")

        cdef uint8_t *data = NULL
        result = buffer_read(self._buffer_iterator, size, &data)
        if result == 1:
            raise BufferIteratorError("Failed to read bytes64 from buffer!")

        return PyBytes_FromStringAndSize(<const char*>data, <Py_ssize_t>size)

    cpdef bytes read_string_long(self):
        cdef uint64_t size = 0
        cdef int result = buffer_read_uint64(self._buffer_iterator, &size)
        if result == 1:
            raise BufferIteratorError("Failed to read bytes64 from buffer!")

        cdef uint8_t *data = NULL
        result = buffer_read(self._buffer_iterator, size, &data)
        if result == 1:
            raise BufferIteratorError("Failed to read bytes64 from buffer!")

        return PyString_FromStringAndSize(<const char*>data, <Py_ssize_t>size)

    def __del__(self):
        buffer_iterator_free(self._buffer_iterator)
        self._buffer = None
        self._buffer_iterator = NULL
