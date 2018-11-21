Return-Path: <SRS0=ZxZh=OA=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33710 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725939AbeKUPn1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 21 Nov 2018 10:43:27 -0500
Date: Wed, 21 Nov 2018 00:10:31 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Cc: linux-ext4@vger.kernel.org
Subject: Re: [PATCH e2fsprogs 7/9] lib/ext2fs: Support encoding when
 calculating dx hashes
Message-ID: <20181121051031.GE26006@thunk.org>
References: <20181015211220.27370-1-krisman@collabora.co.uk>
 <20181015211220.27370-8-krisman@collabora.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181015211220.27370-8-krisman@collabora.co.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 15, 2018 at 05:12:18PM -0400, Gabriel Krisman Bertazi wrote:
> diff --git a/lib/ext2fs/dirhash.c b/lib/ext2fs/dirhash.c
> index 4ba3f35c091f..2198a6fd4d2a 100644
> --- a/lib/ext2fs/dirhash.c
> +++ b/lib/ext2fs/dirhash.c
>  /* dirhash.c */
> -extern errcode_t ext2fs_dirhash(int version, const char *name, int len,
> +extern errcode_t ext2fs_dirhash(const struct nls_table *charset, int version,
> +				int hash_flags, const char *name, int len,
>  				const __u32 *seed,
>  				ext2_dirhash_t *ret_hash,
>  				ext2_dirhash_t *ret_minor_hash);

We can't change function signatures in libext2fs, because this would
breaks the shared libraries ABI.

So when you want to add a new function parameter to a shared library
function, what you should do is create a new function that has the new
parameter, and call it something like ext2_dirhash2().  Then
ext2_dirhash() can be implemented in terms of ext2_dirhash2().

Also, my preference would be to insert new input paramters after len, e.g.:

extern errcode_t ext2fs_dirhash2(int version, const char *name, int len,
				 int hash_flags,
				 const struct nls_table *charset,
				 const __u32 *seed,
				 ext2_dirhash_t *ret_hash,
				 ext2_dirhash_t *ret_minor_hash);
	
					- Ted
