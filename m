From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4 crypto: handle ENOKEY correctly
Date: Fri, 29 May 2015 16:44:29 -0400
Message-ID: <20150529204429.GH18540@thunk.org>
References: <1432917543-26495-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>, G@thunk.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37537 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756450AbbE2Uoc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 29 May 2015 16:44:32 -0400
Content-Disposition: inline
In-Reply-To: <1432917543-26495-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 29, 2015 at 08:39:03PM +0400, Dmitry Monakhov wrote:
> Currently we try to hide ENOKEY inside ext4_get_encryption_info(), but
> it is not always correct. There are two class of callers ext4_get_encryption_info()
> 1) The one where we can ignore ENOKEY
>     - ext4_setup_fname_crypto()
>     - ext4_is_child_context_consistent_with_parent()
> 2) The one do care about any error because expect that ei->i_crypt_info will
>    be initalized after ext4_get_encryption_info() succeed
>    - ext4_file_mmap
>    - ext4_file_open
>    - ext4_inherit_context (key may becomes obsoleted, revoked, dead any time)
> 
> So let's return ENOKEY from ext4_get_encryption_info() if necessery and let caller
> handle it correctly.

I don't think that's the right way to go.  We should add checks to
ext4_file_open, sure.  But the problem is that i_crypt_info can get
set to NULL after the file is succesfully opened.  So we need to
handle i_crypt_info being NULL everywhere.  So the BUG_ON() in
ext4_get_crypto_ctx() needs to be replaced with:

	if (ci == NULL)
		return ERR_PTR(-ENOKEY);

I'll also add documentation making it clear that having
ext4_get_encryption_info() returning with i_crypt_info set to NULL is
considered a successful return, and that callers like
ext4_file_mmap(), ext4_file_open(), ext4_inherit_context(),
needs to check if i_crypt_info is NULL instead.

      	       	  	       	       - Ted
