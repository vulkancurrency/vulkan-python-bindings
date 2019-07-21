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

DEF BLOCK_HEADER_SIZE = HASH_SIZE + HASH_SIZE + 8 + 8 + 8 + 4 + 4 + 4

cdef extern from "core/block.h":
  # structs
  cdef struct Block:
    uint32_t version

    uint8_t previous_hash[HASH_SIZE]
    uint8_t hash[HASH_SIZE]

    uint32_t timestamp
    uint32_t nonce
    uint32_t bits
    uint64_t cumulative_emission

    uint8_t merkle_root[HASH_SIZE]
    uint32_t transaction_count
    transaction_t **transactions

  ctypedef Block block_t

  # functions
  block_t* make_block() nogil

  uint32_t get_block_header_size(block_t *block) nogil

  int valid_block_hash(block_t *block) nogil
  int validate_block_signatures(block_t *block) nogil

  int compare_block(block_t *block, block_t *other_block) nogil
  int compare_with_genesis_block(block_t *block) nogil

  int valid_block_timestamp(block_t *block) nogil
  int valid_block(block_t *block) nogil
  int valid_merkle_root(block_t *block) nogil

  int compute_merkle_root(uint8_t *merkle_root, block_t *block) nogil
  int compute_self_merkle_root(block_t *block) nogil

  void print_block(block_t *block) nogil
  void print_block_transactions(block_t *block) nogil

  int compute_block_hash(uint8_t *hash, block_t *block) nogil
  int compute_self_block_hash(block_t *block) nogil

  int serialize_block_header(buffer_t *buffer, block_t *block) nogil
  int serialize_block(buffer_t *buffer, block_t *block) nogil
  int deserialize_block(buffer_iterator_t *buffer_iterator, block_t **block_out) nogil

  int block_to_serialized(uint8_t **data, uint32_t *data_len, block_t *block) nogil
  block_t* block_from_serialized(uint8_t *data, uint32_t data_len) nogil

  int serialize_transactions_from_block(buffer_t *buffer, block_t *block) nogil
  int deserialize_transactions_to_block(buffer_iterator_t *buffer_iterator, block_t *block) nogil

  int add_transaction_to_block(block_t *block, transaction_t *tx, uint32_t tx_index) nogil
  int add_transactions_to_block(block_t *block, transaction_t **transactions, uint32_t num_transactions) nogil
  transaction_t* get_tx_by_hash_from_block(block_t *block, uint8_t *tx_hash) nogil
  int32_t get_tx_index_from_tx_in_block(block_t *block, transaction_t *tx) nogil

  int copy_block_transactions(block_t *block, block_t *other_block) nogil
  int copy_block(block_t *block, block_t *other_block) nogil

  void free_block_transactions(block_t *block) nogil
  void free_block(block_t *block) nogil
