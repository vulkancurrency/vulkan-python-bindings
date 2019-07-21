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

DEF TXIN_HEADER_SIZE = HASH_SIZE + 4
DEF TXOUT_HEADER_SIZE = HASH_SIZE + 4
DEF MAX_NUM_TX_ENTRIES = 1024

cdef extern from "core/transaction.h":
  # structs
  cdef struct InputTransaction:
    uint8_t transaction[HASH_SIZE]
    uint32_t txout_index
    uint8_t signature[SIGNATURE_SIZE]
    uint8_t public_key[PUBLIC_KEY_SIZE]

  ctypedef InputTransaction input_transaction_t

  cdef struct OutputTransaction:
    uint64_t amount
    uint8_t address[ADDRESS_SIZE]

  ctypedef OutputTransaction output_transaction_t

  cdef struct Transaction:
    uint8_t id[HASH_SIZE]
    uint32_t txin_count
    uint32_t txout_count
    input_transaction_t **txins
    output_transaction_t **txouts

  ctypedef Transaction transaction_t

  cdef struct UnspentOutputTransaction:
    uint64_t amount
    uint8_t address[ADDRESS_SIZE]
    uint8_t spent

  ctypedef UnspentOutputTransaction unspent_output_transaction_t

  cdef struct UnspentTransaction:
    uint8_t id[HASH_SIZE]
    uint8_t coinbase
    uint32_t unspent_txout_count
    unspent_output_transaction_t **unspent_txouts

  ctypedef UnspentTransaction unspent_transaction_t

  # functions
  transaction_t* make_transaction() nogil
  input_transaction_t* make_txin() nogil
  output_transaction_t* make_txout() nogil
  unspent_output_transaction_t* make_unspent_txout() nogil
  unspent_transaction_t* make_unspent_transaction() nogil

  int sign_txin(input_transaction_t *txin, transaction_t *tx, uint8_t *public_key, uint8_t *secret_key) nogil
  int validate_txin_signature(transaction_t *tx, input_transaction_t *txin) nogil
  int validate_tx_signatures(transaction_t *tx) nogil
  void get_txin_header(uint8_t *header, input_transaction_t *txin) nogil
  void get_txout_header(uint8_t *header, output_transaction_t *txout) nogil
  uint32_t get_tx_sign_header_size(transaction_t *tx) nogil
  uint32_t get_tx_header_size(transaction_t *tx) nogil
  void get_tx_sign_header(uint8_t *header, transaction_t *tx) nogil

  int compare_txin(input_transaction_t *txin, input_transaction_t *other_txin) nogil
  int compare_txout(output_transaction_t *txout, output_transaction_t *other_txout) nogil
  int compare_transaction(transaction_t *transaction, transaction_t *other_transaction) nogil

  void print_txin(uint8_t txin_index, input_transaction_t *txin) nogil
  void print_txout(uint8_t txout_index, output_transaction_t *txout) nogil
  void print_transaction(transaction_t *tx) nogil

  int valid_transaction(transaction_t *tx) nogil
  int is_generation_tx(transaction_t *tx) nogil
  int do_txins_reference_unspent_txouts(transaction_t *tx) nogil

  int compute_tx_id(uint8_t *tx_id, transaction_t *tx) nogil
  int compute_self_tx_id(transaction_t *tx) nogil

  int serialize_txin_header(buffer_t *buffer, input_transaction_t *txin) nogil
  int serialize_txin(buffer_t *buffer, input_transaction_t *txin) nogil
  int deserialize_txin(buffer_iterator_t *buffer_iterator, input_transaction_t **txin_out) nogil

  int serialize_txout_header(buffer_t *buffer, output_transaction_t *txout) nogil
  int serialize_txout(buffer_t *buffer, output_transaction_t *txout) nogil
  int deserialize_txout(buffer_iterator_t *buffer_iterator, output_transaction_t **txout_out) nogil

  int serialize_transaction_header(buffer_t *buffer, transaction_t *tx) nogil
  int serialize_transaction(buffer_t *buffer, transaction_t *tx) nogil
  int deserialize_transaction(buffer_iterator_t *buffer_iterator, transaction_t **tx_out) nogil

  int transaction_to_serialized(uint8_t **data, uint32_t *data_len, transaction_t *tx) nogil
  transaction_t* transaction_from_serialized(uint8_t *data, uint32_t data_len) nogil

  int serialize_unspent_txout(buffer_t *buffer, unspent_output_transaction_t *unspent_txout) nogil
  int deserialize_unspent_txout(buffer_iterator_t *buffer_iterator, unspent_output_transaction_t **unspent_txout_out) nogil

  int serialize_unspent_transaction(buffer_t *buffer, unspent_transaction_t *unspent_tx) nogil
  int deserialize_unspent_transaction(buffer_iterator_t *buffer_iterator, unspent_transaction_t **unspent_tx_out) nogil

  unspent_output_transaction_t* txout_to_unspent_txout(output_transaction_t *txout) nogil
  unspent_transaction_t* transaction_to_unspent_transaction(transaction_t *tx) nogil
  int unspent_transaction_to_serialized(uint8_t **data, uint32_t *data_len, unspent_transaction_t *unspent_tx) nogil
  unspent_transaction_t* unspent_transaction_from_serialized(uint8_t *data, uint32_t data_len) nogil
  #int get_unspent_txouts_from_unspent_tx(unspent_transaction_t *unspent_tx, vec_void_t *unspent_txouts, uint32_t *num_unspent_txouts) nogil

  int add_txin_to_transaction(transaction_t *tx, input_transaction_t *txin, uint32_t txin_index) nogil
  int add_txout_to_transaction(transaction_t *tx, output_transaction_t *txout, uint32_t txout_index) nogil

  int copy_txin(input_transaction_t *txin, input_transaction_t *other_txin) nogil
  int copy_txout(output_transaction_t *txout, output_transaction_t *other_txout) nogil
  int copy_transaction(transaction_t *tx, transaction_t *other_tx) nogil

  void free_txins(transaction_t *tx) nogil
  void free_txouts(transaction_t *tx) nogil
  void free_transaction(transaction_t *tx) nogil

  void free_unspent_txouts(unspent_transaction_t *unspent_tx) nogil
  void free_unspent_transaction(unspent_transaction_t *unspent_tx) nogil
