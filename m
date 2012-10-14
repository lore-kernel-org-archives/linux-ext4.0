From: "George Spelvin" <linux@horizon.com>
Subject: Re: metadata_csum set but no space in dir leaf for checksum
Date: 14 Oct 2012 13:40:46 -0400
Message-ID: <20121014174046.3102.qmail@science.horizon.com>
References: <20121014145508.GC6207@thunk.org>
Cc: linux-ext4@vger.kernel.org, linux@horizon.com
To: adilger@dilger.ca, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from science.horizon.com ([71.41.210.146]:24665 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751590Ab2JNRkr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 14 Oct 2012 13:40:47 -0400
In-Reply-To: <20121014145508.GC6207@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

tytso@mit.edu wrote:
> Was this a freshly created ext4 file system with the metadata_csum
> checksum, or was this a previously existing ext4 file system where the
> metadata_csum feature was added later?

The latter.  Sorry, I meant to imply that whan I said that the directories
hadn't been modified for years (= longer than the metadata_chum feature has
been in the kernel).

> I've pushed an update to the e2fsprogs repository which allows htree
> and "ls -c" to actually show us the directory leaf block checksums.
> Previously, they were hidden, which means that it's hard to tell
> whether a directory had all of its directory blocks properly
> checksummed or not.

Here's some sample output.  Note that the machine has been rebooted
to install 7.6.2 since my last e-mail, which forced an fsck, although
that's far from the first fsck since e2fsprogs_1.43~WIP was installed;
I had already tried e2fsck -D as recommended before posting.

Kernel errors from previous boot:
EXT4-fs error (device md5): ext4_dirent_csum_verify:262: inode #7260289: comm nfsd: metadata_csum set but no space in dir leaf for checksum.  Please run e2fsck -D.
EXT4-fs error (device md5): ext4_find_entry:1217: inode #7260289: comm nfsd: checksumming directory block 0
(I haven't got any such messages this boot yet.)

debugfs:  htree <7260289>
Root node dump:
         Reserved zero: 0
         Hash Version: 1
         Info length: 8
         Indirect levels: 0
         Flags: 0
Number of entries (count): 2
Number of entries (limit): 507
Checksum: 0xa282c705
Entry #0: Hash 0x00000000, block 1
Entry #1: Hash 0xc651c0c8, block 2

Entry #0: Hash 0x00000000, block 1
Reading directory block 1, phys 177033588
7260297 0x07e44c12-0faba58c (20) BIO_f_md.3   
7260395 0x098518f4-0c003f88 (32) SSL_get_ex_new_index.3   
7260434 0x0b07da66-55c318e1 (20) DH_size.3   
7260450 0x0c8deec2-c462c33e (32) RSA_get_ex_new_index.3   
7260312 0x0d627b76-6875fcb6 (24) SSL_CTX_new.3   
7260364 0x0e53ecee-89487934 (16) DH_new.3   
7260446 0x0f1f7f1c-e722617e (28) ERR_remove_state.3   
7260365 0x10f722b4-da2ebccb (28) SSL_set_session.3   
7260429 0x1118e44a-79b7a654 (32) SSL_set_connect_state.3   
7260393 0x1258a2c2-31c867d0 (20) BIO_read.3   
7260463 0x1306ac8a-3adf907d (20) BN_CTX_new.3   
7260350 0x1472b13a-8b35e3d0 (20) BIO_new.3   
7260449 0x1699b994-de4de844 (28) SSL_CTX_set_mode.3   
7260360 0x19394452-643f773d (24) SSL_set_bio.3   
7260320 0x1de219a2-ca9255b5 (36) SSL_CTX_get_verify_mode.3   
7260432 0x1f163fac-0cd43465 (28) SSL_CTX_sessions.3   
7260406 0x22ce5344-f01b3cbd (16) mdc2.3   
7260325 0x22d8ec4a-fb9836ed (20) DSA_new.3   
7260435 0x23e17b88-c7a41c37 (28) SSL_CTX_set_verify.3   
7260299 0x2647e06c-c4df2de5 (36) SSL_CTX_use_certificate.3   
7260335 0x26c44e76-9b506ed8 (20) BN_bn2bin.3   
7260454 0x283d9158-12ec2d76 (36) SSL_CTX_set_cipher_list.3   
7260337 0x29410c46-baf27c7d (16) crypto.3   
7260442 0x29bcf498-e6659eed (12) dh.3   
7260300 0x2fe4a052-4a9da069 (24) RSA_set_method.3   
7260453 0x3059ae72-6db5c903 (24) DSA_set_method.3   
7260396 0x315f51d4-e7e87296 (20) BIO_f_null.3   
7260426 0x33a32a0c-1359ea4d (24) RAND_cleanup.3   
7260303 0x33ddf774-6d307a09 (20) BN_rand.3   
7260409 0x37207c50-27ed9aba (24) EVP_DigestInit.3   
7260401 0x391694a4-ceefe1cc (20) BIO_ctrl.3   
7260347 0x397cd3d6-d0a72718 (20) DSA_size.3   
7260367 0x3b947d46-6734fc03 (20) threads.3   
7260392 0x3d2d9be8-a9f19cda (24) BIO_s_accept.3   
7260425 0x3d6520fc-2fbec36c (24) BIO_s_connect.3   
7260416 0x4197cad6-975fe469 (20) SSL_new.3   
7260348 0x426002b4-1abf7e14 (20) SSL_read.3   
7260391 0x42cd2f5a-593db7e5 (20) BN_zero.3   
7260424 0x44aea34a-03252089 (32) DSA_get_ex_new_index.3   
7260357 0x47716494-c7ce8abe (24) EVP_OpenInit.3   
7260343 0x483ab2e4-d4957e68 (32) RAND_set_rand_method.3   
7260386 0x4a052e32-6ab3c4dd (24) d2i_DHparams.3   
7260389 0x4a4e7e66-5010db9e (16) rsa.3   
7260397 0x4a84fb84-a74612e7 (36) SSL_load_client_CA_file.3   
7260308 0x4aaa5cdc-c382f299 (28) EVP_EncryptInit.3   
7260294 0x4ae7dcb6-c57edfb1 (28) RSA_public_encrypt.3   
7260349 0x4f5b95ea-3de25cb2 (36) RSA_sign_ASN1_OCTET_STRING.3   
7260415 0x508078d6-550ab0c9 (32) SSL_CTX_add_session.3   
7260356 0x535a129c-77a03365 (32) SSL_CTX_flush_sessions.3   
7260292 0x57236a66-96c665a6 (24) EVP_VerifyInit.3   
7260427 0x581d8d96-249f01c4 (20) SSL_accept.3   
7260352 0x58531a7a-022cacff (24) BN_add_word.3   
7260459 0x5867dcb0-3541daa3 (20) BIO_push.3   
7260376 0x58e1b4dc-791b7446 (20) SSL_free.3   
7260419 0x59900d72-ad3a5fed (40) SSL_SESSION_get_ex_new_index.3   
7260310 0x5b73fc92-9c4f4c39 (32) BN_mod_mul_reciprocal.3   
7260423 0x5cdb94be-8f038dc8 (28) SSL_get_version.3   
7260362 0x5d45c2c6-5c2e79d1 (28) RSA_generate_key.3   
7260460 0x5fa795b0-abd5ee50 (36) SSL_CTX_set_client_CA_list.3   
7260368 0x60611a70-924c950a (24) SSL_get_rbio.3   
7260359 0x60a25512-ae72c504 (28) RSA_blinding_on.3   
7260333 0x62978cc6-8e0de4b9 (24) DSA_SIG_new.3   
7260383 0x63557068-5a7e9bca (40) SSL_CTX_add_extra_chain_cert.3   
7260329 0x65f56e94-daf2bd63 (32) BN_mod_mul_montgomery.3   
7260404 0x6792287a-b059fda1 (24) BIO_f_cipher.3   
7260413 0x690c4f08-94542063 (40) SSL_CTX_set_session_id_context.3   
7260444 0x6b2488b0-60b88931 (24) DH_set_method.3   
7260361 0x6b3738d8-59ec9746 (20) blowfish.3   
7260438 0x6b5f3ecc-99fd3f8d (24) EVP_SealInit.3   
7260316 0x6b924c70-1476bf92 (24) bn_internal.3   
7260405 0x6ecf55fc-e9ac14fd (32) RSA_private_encrypt.3   
7260412 0x7017950e-d3fda7e1 (16) des.3   
7260351 0x718be2aa-f35d3d50 (16) hmac.3   
7260445 0x71c58d24-cd9f708f (20) BIO_s_null.3   
7260304 0x750c9df4-adc5601e (20) lh_stats.3   
7260418 0x758bd64e-f5ddfe49 (28) SSL_set_shutdown.3   
7260373 0x75ab6cfc-6fc5d924 (32) SSL_SESSION_get_time.3   
7260317 0x76bcc8ee-0b37b434 (20) RSA_sign.3   
7260344 0x77cc15c8-d9abda3b (24) BN_mod_inverse.3   
7260398 0x790c9414-b63ef97c (16) buffer.3   
7260379 0x7965a398-db8daec3 (16) rand.3   
7260458 0x7bd85424-d2c04dc4 (32) SSL_CTX_set_timeout.3   
7260387 0x7cb24310-2194a2d3 (24) BN_CTX_start.3   
7260319 0x7ce216e0-46eb9017 (28) d2i_SSL_SESSION.3   
7260322 0x7fff90aa-a33dd3d1 (24) ERR_GET_LIB.3   
7260345 0x8002b920-80699a79 (20) BN_copy.3   
7260338 0x81fb4e96-0f4850d4 (28) DSA_generate_key.3   
7260293 0x8576c43e-9119dde4 (16) md5.3   
7260372 0x859c9a00-958b064f (20) SSL_set_fd.3   
7260414 0x85f4a08e-642759b3 (36) OpenSSL_add_all_algorithms.3   
7260330 0x8b61293e-9c4dda9d (32) SSL_get_client_CA_list.3   
7260346 0x8e3f5fa2-73de4cc2 (36) SSL_CTX_set_ssl_version.3   
7260307 0x8f0f3ffc-2fe1a538 (24) SSL_get_error.3   
7260421 0x902e3b8c-933e4c23 (16) BN_cmp.3   
7260314 0x90990216-13e0411c (36) SSL_CTX_sess_set_get_cb.3   
7260311 0x91542446-3efc3c19 (40) RSA_padding_add_PKCS1_type_1.3   
7260339 0x916a733a-13e03394 (24) SSL_shutdown.3   
7260324 0x921d8f86-d161419d (20) BIO_s_file.3   
7260332 0x9322a50c-8c178506 (28) CRYPTO_set_ex_data.3   
7260327 0x9607dca0-ed531046 (20) RSA_print.3   
7260340 0x964df74a-4f123b2b (16) lhash.3   
7260455 0x96ee17ae-669fb783 (32) DH_get_ex_new_index.3   
7260447 0x984caf30-96255edd (12) bn.3   
7260440 0x985c0eea-59094ec6 (36) SSL_get_peer_cert_chain.3   
7260437 0x995fd9a8-f7799455 (28) ERR_error_string.3   
7260384 0xa24af59a-680e3202 (32) SSL_get_current_cipher.3   
7260411 0xa2979c52-cdcc48ac (20) SSL_clear.3   
7260366 0xa360c30e-0084373a (20) DSA_dup_DH.3   
7260452 0xa6df47b8-d19464ac (24) ERR_get_error.3   
7260433 0xa861c724-bda7fc99 (44) SSL_get_ex_data_X509_STORE_CTX_idx.3   
7260428 0xaace0160-90769bb0 (24) ERR_put_error.3   
7260326 0xab63d5a8-62a03ec8 (16) ripemd.3   
7260358 0xabc410e2-b7b7cb97 (28) d2i_RSAPublicKey.3   
7260403 0xac26eedc-7e802c54 (20) BIO_s_mem.3   
7260417 0xac84ce1a-b33fbeb0 (16) bio.3   
7260400 0xae53fb20-ef9de0c6 (20) BIO_s_fd.3   
7260381 0xaef4d31e-33518ab0 (24) SSL_CTX_free.3   
7260422 0xb2cefcc8-0b75b42e (36) SSL_CTX_get_ex_new_index.3   
7260441 0xb76293b2-e7014662 (36) DSA_generate_parameters.3   
7260390 0xb7639512-1ea915ad (24) SSL_pending.3   
7260296 0xb8c7fbe6-59bde09f (20) BN_set_bit.3   
7260394 0xba9f33e4-988cea51 (40) SSL_CTX_set_session_cache_mode.3   
7260443 0xbae7470a-db03ace8 (28) ERR_load_strings.3   
7260290 0xbbbf6d1c-fe642056 (16) ssl.3   
7260456 0xbe933d7a-c569d017 (16) BN_new.3   
7260341 0xbf8d5172-1d9f2680 (20) RSA_size.3   
7260388 0xc396b7cc-bdd7c6db (24) EVP_SignInit.3   
7260399 0xc3d14f26-58509c5f (16) err.3   
7260457 0xc4ef58fe-aec81b22 (40) SSL_CTX_load_verify_locations.3   
7260461 0xc5a1635a-dafc33ec (820) ERR_print_errors.3   
leaf block checksum: 0x2b610fb1  
Entry #1: Hash 0xc651c0c8, block 2
Reading directory block 2, phys 177033589
7260328 0xc651c0c8-8474dec8 (24) RAND_load_file.3   
7260355 0xc6e96896-68c1c178 (28) SSL_get_session.3   
7260462 0xc97406bc-00534e19 (40) SSL_CTX_set_default_passwd_cb.3   
7260336 0xcbda376c-dc040695 (32) SSL_CTX_set_options.3   
7260448 0xd1d9338c-f6a4c5ba (40) SSL_CTX_sess_set_cache_size.3   
7260354 0xd265dde8-ccc52a73 (24) DSA_do_sign.3   
7260377 0xd390e694-85edfcc3 (16) dsa.3   
7260305 0xd39b2744-ed9e3360 (28) BN_generate_prime.3   
7260298 0xd448aff6-e2c915a2 (28) SSL_library_init.3   
7260410 0xd5f8ff1a-53e2a115 (24) BN_num_bytes.3   
7260402 0xd60c9a08-a4769341 (32) SSL_CTX_sess_number.3   
7260321 0xd67a78a4-d828bb19 (28) ERR_clear_error.3   
7260334 0xd764ca30-0a0cf608 (16) rc4.3   
7260436 0xd839305c-889aa8af (16) BN_add.3   
7260430 0xda67905c-9a3f37c8 (20) RAND_add.3   
7260439 0xdd479a9e-d14ab495 (20) SSL_write.3   
7260302 0xe09701de-7a3e5dda (24) SSL_connect.3   
7260306 0xe191f45a-9a88502b (32) SSL_CIPHER_get_name.3   
7260385 0xe36833f8-e51ccbbb (24) BIO_s_socket.3   
7260420 0xe3fb937e-ba724ee8 (24) BIO_f_buffer.3   
7260353 0xe41d3ac6-52f50651 (32) DH_generate_parameters.3   
7260448 0xd1d9338c-f6a4c5ba (40) SSL_CTX_sess_set_cache_size.3   
7260354 0xd265dde8-ccc52a73 (24) DSA_do_sign.3   
7260377 0xd390e694-85edfcc3 (16) dsa.3   
7260305 0xd39b2744-ed9e3360 (28) BN_generate_prime.3   
7260298 0xd448aff6-e2c915a2 (28) SSL_library_init.3   
7260410 0xd5f8ff1a-53e2a115 (24) BN_num_bytes.3   
7260402 0xd60c9a08-a4769341 (32) SSL_CTX_sess_number.3   
7260321 0xd67a78a4-d828bb19 (28) ERR_clear_error.3   
7260334 0xd764ca30-0a0cf608 (16) rc4.3   
7260436 0xd839305c-889aa8af (16) BN_add.3   
7260430 0xda67905c-9a3f37c8 (20) RAND_add.3   
7260439 0xdd479a9e-d14ab495 (20) SSL_write.3   
7260302 0xe09701de-7a3e5dda (24) SSL_connect.3   
7260306 0xe191f45a-9a88502b (32) SSL_CIPHER_get_name.3   
7260385 0xe36833f8-e51ccbbb (24) BIO_s_socket.3   
7260420 0xe3fb937e-ba724ee8 (24) BIO_f_buffer.3   
7260353 0xe41d3ac6-52f50651 (32) DH_generate_parameters.3   
7260382 0xe470e540-ad6a769e (20) BIO_s_bio.3   
7260370 0xe47e18b6-5c2acaaf (32) OPENSSL_VERSION_NUMBER.3   
7260291 0xe745ee12-31852c60 (36) SSL_get_peer_certificate.3   
7260331 0xe8aca5bc-8533f093 (28) DH_generate_key.3   
7260369 0xe8e229a4-c6009e80 (20) SSL_get_fd.3   
7260451 0xe94553c6-24d50e9d (16) evp.3   
7260431 0xeab56bc4-e1292617 (20) RAND_egd.3   
7260313 0xec91f97c-f6ca95bd (24) BIO_f_base64.3   
7260407 0xed830c0c-0a70cc87 (28) BIO_set_callback.3   
7260363 0xeda9ab6c-56f7d734 (20) BIO_f_ssl.3   
7260323 0xf11d8d6e-b94537d0 (28) BIO_new_bio_pair.3   
7260380 0xf19e29ea-e444ca30 (28) SSL_get_ciphers.3   
7260371 0xf1c34548-18cc4fa8 (32) SSL_set_verify_result.3   
7260315 0xf3477a92-640173f8 (20) RSA_new.3   
7260375 0xf3894ac6-ae397b11 (24) BIO_find_type.3   
7260318 0xf4fb2558-ce5db5c7 (16) sha.3   
7260342 0xf5810be4-030e965b (32) SSL_get_verify_result.3   
7260295 0xfaab4b04-99b5b844 (20) DSA_sign.3   
7260374 0xfbfa5630-f088e63d (28) BIO_should_retry.3   
7260378 0xfd0ab79a-b0a0f06a (24) RSA_check_key.3   
7260301 0xfd2e36cc-1d932012 (28) SSL_SESSION_free.3   
7260309 0xfdc7a154-3b7ba204 (20) RAND_bytes.3   
7260408 0xfecc1752-e2317e2c (2988) ERR_load_crypto_strings.3   
leaf block checksum: 0xf00f0643  
---------------------

