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

cdef extern from "crypto/cryptoutil.h":
  # functions
  int compare_hash(const uint8_t *hash, const uint8_t *other_hash) nogil
  int compare_address(const uint8_t *address, const uint8_t *other_address) nogil
  int compare_signature(const uint8_t *signature, const uint8_t *other_signature) nogil
  int compare_public_key(const uint8_t *public_key, const uint8_t *other_public_key) nogil

DEF HASH_SIZE = 32
DEF ADDRESS_SIZE = HASH_SIZE + 1
DEF SIGNATURE_SIZE = HASH_SIZE * 2
DEF PUBLIC_KEY_SIZE = HASH_SIZE
