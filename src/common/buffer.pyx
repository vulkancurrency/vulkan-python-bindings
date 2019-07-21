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

cdef extern from "common/buffer.h":
  # structs
  cdef struct Buffer:
    uint8_t *data
    size_t size
    size_t offset

  ctypedef Buffer buffer_t

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
  cdef struct BufferIterator:
    const buffer_t *buffer
    size_t offset

  ctypedef BufferIterator buffer_iterator_t

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
