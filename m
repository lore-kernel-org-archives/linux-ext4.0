From: Jan Kara <jack@suse.cz>
Subject: Coverity complaints about new crypto code
Date: Tue, 5 May 2015 09:54:36 +0200
Message-ID: <20150505075436.GA11943@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51575 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753227AbbEEHyi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 5 May 2015 03:54:38 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

  Coverity complains about the new ext4 crypto code. The complaint is that
ext4_fname_crypto_alloc_buffer() and ext4_fname_crypto_namelen_on_disk()
check for ctx being NULL but they dereference it before that check.
I've checked and didn't find callers that would actually pass NULL into
these functions so do we want to remove the unused check or move the
dereference? I think it would be worth cleaning up just that we don't fall
into the trap sometime later...

								Honza

----- Forwarded message from scan-admin@coverity.com -----

** CID 1296585:  Null pointer dereferences  (REVERSE_INULL)
/fs/ext4/crypto_fname.c: 500 in ext4_fname_crypto_alloc_buffer()


________________________________________________________________________________________________________
*** CID 1296585:  Null pointer dereferences  (REVERSE_INULL)
/fs/ext4/crypto_fname.c: 500 in ext4_fname_crypto_alloc_buffer()
494     int ext4_fname_crypto_alloc_buffer(struct ext4_fname_crypto_ctx *ctx,
495     				   u32 ilen, struct ext4_str *crypto_str)
496     {
497     	unsigned int olen;
498     	int padding = 4 << (ctx->flags & EXT4_POLICY_FLAGS_PAD_MASK);
499     
>>>     CID 1296585:  Null pointer dereferences  (REVERSE_INULL)
>>>     Null-checking "ctx" suggests that it may be null, but it has already been dereferenced on all paths leading to the check.
500     	if (!ctx)
501     		return -EIO;
502     	if (padding < EXT4_CRYPTO_BLOCK_SIZE)
503     		padding = EXT4_CRYPTO_BLOCK_SIZE;
504     	olen = ext4_fname_crypto_round_up(ilen, padding);
505     	crypto_str->len = olen;

** CID 1296586:  Null pointer dereferences  (REVERSE_INULL)
/fs/ext4/crypto_fname.c: 476 in ext4_fname_crypto_namelen_on_disk()


________________________________________________________________________________________________________
*** CID 1296586:  Null pointer dereferences  (REVERSE_INULL)
/fs/ext4/crypto_fname.c: 476 in ext4_fname_crypto_namelen_on_disk()
470     int ext4_fname_crypto_namelen_on_disk(struct ext4_fname_crypto_ctx *ctx,
471     				      u32 namelen)
472     {
473     	u32 ciphertext_len;
474     	int padding = 4 << (ctx->flags & EXT4_POLICY_FLAGS_PAD_MASK);
475     
>>>     CID 1296586:  Null pointer dereferences  (REVERSE_INULL)
>>>     Null-checking "ctx" suggests that it may be null, but it has already been dereferenced on all paths leading to the check.
476     	if (ctx == NULL)
477     		return -EIO;
478     	if (!(ctx->has_valid_key))
479     		return -EACCES;
480     	ciphertext_len = (namelen < EXT4_CRYPTO_BLOCK_SIZE) ?
481     		EXT4_CRYPTO_BLOCK_SIZE : namelen;


________________________________________________________________________________________________________
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
