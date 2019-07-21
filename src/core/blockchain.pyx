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

DEF DB_KEY_PREFIX_TX = "t"
DEF DB_KEY_PREFIX_UNSPENT_TX = "ut"
DEF DB_KEY_PREFIX_BLOCK = "b"
DEF DB_KEY_PREFIX_TOP_BLOCK = "tb"

DEF DB_KEY_PREFIX_SIZE_TX = 1
DEF DB_KEY_PREFIX_SIZE_UNSPENT_TX = 2
DEF DB_KEY_PREFIX_SIZE_BLOCK = 1
DEF DB_KEY_PREFIX_SIZE_TOP_BLOCK = 2

cdef extern from "core/blockchain.h":
  int valid_compression_type(int compression_type) nogil
  const char* get_compression_type_str(int compression_type) nogil
  int get_compression_type_from_str(const char *compression_type_str) nogil

  void set_want_blockchain_compression(int want_blockchain_compression) nogil
  int get_want_blockchain_compression() nogil

  void set_blockchain_compression_type(int compression_type) nogil
  int get_blockchain_compression_type() nogil

  const char* get_blockchain_dir() nogil
  const char* get_blockchain_backup_dir(const char *blockchain_dir) nogil

  int repair_blockchain(const char *blockchain_dir) nogil
  int load_blockchain_top_block() nogil
  int open_blockchain(const char *blockchain_dir, int load_top_block) nogil
  int close_blockchain() nogil

  int open_backup_blockchain(const char *blockchain_backup_dir) nogil
  int close_backup_blockchain() nogil

  int init_blockchain(const char *blockchain_dir, int load_top_block) nogil
  int remove_blockchain(const char *blockchain_dir) nogil

#IF USE_LEVELDB:
#  int purge_all_entries_from_database(leveldb_t *db) nogil
#ELSE:
#  int purge_all_entries_from_database(rocksdb_t *db) nogil

#IF USE_LEVELDB:
#  int copy_all_entries_to_database(leveldb_t *from_db, leveldb_t *to_db) nogil
#ELSE:
#  int copy_all_entries_to_database(rocksdb_t *from_db, rocksdb_t *to_db) nogil

  int reset_blockchain_nolock() nogil
  int reset_blockchain() nogil

  int backup_blockchain_nolock() nogil
  int backup_blockchain() nogil

  int restore_blockchain_nolock() nogil
  int restore_blockchain() nogil

  int rollback_blockchain_nolock(uint32_t rollback_height) nogil
  int rollback_blockchain(uint32_t rollback_height) nogil

  uint32_t get_block_height_nolock() nogil
  uint32_t get_block_height() nogil

  uint64_t get_cumulative_emission() nogil
  uint64_t get_block_reward(uint32_t block_height, uint64_t cumulative_emission) nogil

  uint32_t get_next_work_required_nolock(uint8_t *previous_hash) nogil
  uint32_t get_next_work_required(uint8_t *previous_hash) nogil

  int valid_block_median_timestamp(block_t *block) nogil
  int valid_block_emission(block_t *block, uint32_t block_height) nogil

  int insert_block_nolock(block_t *block) nogil
  int insert_block(block_t *block) nogil

  int validate_and_insert_block_nolock(block_t *block) nogil
  int validate_and_insert_block(block_t *block) nogil

  int is_genesis_block(uint8_t *block_hash) nogil

  block_t *get_block_from_hash_nolock(uint8_t *block_hash) nogil
  block_t *get_block_from_hash(uint8_t *block_hash) nogil

  block_t *get_block_from_height_nolock(uint32_t height) nogil
  block_t *get_block_from_height(uint32_t height) nogil

  int32_t get_block_height_from_hash_nolock(uint8_t *block_hash) nogil
  int32_t get_block_height_from_hash(uint8_t *block_hash) nogil

  int32_t get_block_height_from_block(block_t *block) nogil
  uint8_t *get_block_hash_from_height(uint32_t height) nogil

  int has_block_by_hash(uint8_t *block_hash) nogil
  int has_block_by_height(uint32_t height) nogil

  int insert_tx_into_index_nolock(uint8_t *block_key, transaction_t *tx) nogil
  int insert_tx_into_index(uint8_t *block_key, transaction_t *tx) nogil

  int insert_tx_into_unspent_index_nolock(transaction_t *tx) nogil
  int insert_tx_into_unspent_index(transaction_t *tx) nogil

  int insert_unspent_tx_into_index_nolock(unspent_transaction_t *unspent_tx) nogil
  int insert_unspent_tx_into_index(unspent_transaction_t *unspent_tx) nogil

  unspent_transaction_t *get_unspent_tx_from_index_nolock(uint8_t *tx_id) nogil
  unspent_transaction_t *get_unspent_tx_from_index(uint8_t *tx_id) nogil

  uint8_t *get_block_hash_from_tx_id_nolock(uint8_t *tx_id) nogil
  uint8_t *get_block_hash_from_tx_id(uint8_t *tx_id) nogil

  block_t *get_block_from_tx_id(uint8_t *tx_id) nogil

  int delete_block_from_blockchain_nolock(uint8_t *block_hash) nogil
  int delete_block_from_blockchain(uint8_t *block_hash) nogil

  int delete_tx_from_index_nolock(uint8_t *tx_id) nogil
  int delete_tx_from_index(uint8_t *tx_id) nogil

  int delete_unspent_tx_from_index_nolock(uint8_t *tx_id) nogil
  int delete_unspent_tx_from_index(uint8_t *tx_id) nogil

  int set_top_block_hash_noblock(uint8_t *block_hash) nogil
  int set_top_block_hash(uint8_t *block_hash) nogil

  uint8_t* get_top_block_hash_noblock() nogil
  uint8_t* get_top_block_hash() nogil

  int set_top_block(block_t *block) nogil
  block_t *get_top_block() nogil

  int set_current_block_hash(uint8_t *hash) nogil
  uint8_t *get_current_block_hash() nogil

  int set_current_block(block_t *block) nogil
  block_t *get_current_block() nogil

  uint32_t get_blocks_since_hash(uint8_t *block_hash) nogil
  uint32_t get_blocks_since_block(block_t *block) nogil

  void get_tx_key(uint8_t *buffer, uint8_t *tx_id) nogil
  void get_unspent_tx_key(uint8_t *buffer, uint8_t *tx_id) nogil
  void get_block_key(uint8_t *buffer, uint8_t *block_hash) nogil
  void get_top_block_key(uint8_t *buffer) nogil

  #VULKAN_API int get_unspent_transactions_for_address_nolock(uint8_t *address, vec_void_t *unspent_txs, uint32_t *num_unspent_txs) nogil
  #VULKAN_API int get_unspent_transactions_for_address(uint8_t *address, vec_void_t *unspent_txs, uint32_t *num_unspent_txs) nogil

  uint64_t get_balance_for_address_nolock(uint8_t *address) nogil
  uint64_t get_balance_for_address(uint8_t *address) nogil
