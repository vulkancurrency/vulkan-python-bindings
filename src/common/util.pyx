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

cdef extern from "common/util.h":
  # functions
  unsigned concatenate(unsigned x, unsigned y) nogil
  uint16_t get_num_logical_cores() nogil

  int string_equals(const char *string, const char *equals) nogil
  int string_startswith(const char *string, const char *prefix) nogil
  int string_endswith(const char *string, const char *ext) nogil
  int string_count(const char *string, const char *countstr, int countbreak) nogil
  const char* string_copy(const char *string, const char *other_string) nogil

  int make_hash(char *digest, unsigned char *string) nogil
  char* bin2hex(uint8_t *bin, size_t bin_size) nogil
  uint8_t* hex2bin(const char *hexstr, size_t *size) nogil

  uint32_t get_current_time() nogil
  int cmp_least_greatest(const void *a, const void *b) nogil

  int is_private_address(uint32_t ip) nogil
  int is_local_address(uint32_t ip) nogil
  uint32_t convert_str_to_ip(const char* address) nogil
  char* convert_ip_to_str(uint32_t ip) nogil
  char* convert_to_addr_str(const char* address, uint32_t port) nogil
