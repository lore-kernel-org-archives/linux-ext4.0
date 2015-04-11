From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 13/22] ext4 crypto: implement the ext4 decryption read
 path
Date: Sat, 11 Apr 2015 09:38:39 -0400
Message-ID: <20150411133839.GH6540@thunk.org>
References: <1428012659-12709-1-git-send-email-tytso@mit.edu>
 <1428012659-12709-14-git-send-email-tytso@mit.edu>
 <FEE31C23-6965-4762-A9A6-D19EF014A719@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	jaegeuk@kernel.org, mhalcrow@google.com,
	Ildar Muslukhov <ildarm@google.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34185 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754196AbbDKNim (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 11 Apr 2015 09:38:42 -0400
Content-Disposition: inline
In-Reply-To: <FEE31C23-6965-4762-A9A6-D19EF014A719@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 08, 2015 at 12:51:04PM -0600, Andreas Dilger wrote:
> > @@ -200,9 +201,15 @@ static const struct vm_operations_struct ext4_file_vm_ops = {
> > 
> > static int ext4_file_mmap(struct file *file, struct vm_area_struct *vma)
> > {
> > +	int res = 0;
> 
> This function is using "res", the one below "ret".  It would be nice to
> have some consistency.  "rc" is probably the most common and would be
> my preference for new/modified code.

Good point; I've restructured this code to make it simpler (and to
avoid conflicting with the DAX patches).  So it now looks like this:

	if (ext4_encrypted_inode(inode)) {
		int err = ext4_generate_encryption_key(inode);
		if (err)
			return 0;
	}

(I'm not a fan of rc, myself, but this makes the declaration and use
of the function much closer together than what we had before, which
makes it much easier to understand.  I'm guessing Microsoft had a
coding policy which stated that all functions have to only have one
return function at the end of the function, since I've noticed that
both Ildar and Michael seem to code that way, even when it requires
using goto statements and/or making the code less clear.)

> > +#ifdef CONFIG_EXT4_FS_ENCRYPTION
> > +		if (S_ISREG(inode->i_mode) &&
> > +		    ext4_encrypted_inode(inode)) {
> > +			/* We expect the key to be set. */
> > +			BUG_ON(!ext4_has_encryption_key(inode));
> > +			BUG_ON(blocksize != PAGE_CACHE_SIZE);
> > +			WARN_ON_ONCE(ext4_decrypt_one(inode, page));
> > +		}
> > +#endif
> 
> This could avoid the #ifdef since ext4_encrypted_inode() is declared (0)
> in the !CONFIG_EXT4_FS_ENCRYPTION case.  The compiler will optimize out
> the resulting unreachable code in that case and make this code easier
> to read.

Good point, done.

> If the (bio->bi_private != NULL) check was moved to a helper function:
> 
> static inline bool ext4_bio_encrypted(struct bio *bio)
> {
> #ifdef CONFIG_EXT4_FS_ENCRYPTION
> 	return unlikely(bio->bi_private != NULL);
> #else
> 	return false;
> #endif
> }
> 
> Then the inline #ifdefs could be removed here, since the resulting

Sure, that makes the code a bit more readable, thanks.

> > +		if (err)
> > +			ext4_release_crypto_ctx(ctx);
> > +		else {
> 
> The if/else should have matching {} blocks.

Meh, I don't really think it's that important, but sure.

> > @@ -94,9 +137,15 @@ int ext4_mpage_readpages(struct address_space *mapping,
> > 	unsigned page_block;
> > 	struct block_device *bdev = inode->i_sb->s_bdev;
> > 	int length;
> > +	int do_decryption = 0;
> 
> Can be bool instead of int.

Actually, since we only use do_decryption in one place now, I'll just remove this and this:

> > +#ifdef CONFIG_EXT4_FS_ENCRYPTION
> > +	if (ext4_encrypted_inode(inode) && S_ISREG(inode->i_mode))
> > +		do_decryption = 1;
> > +#endif
> #ifdef can be removed.

And move the condition to the one place where we test for do_decryption.

Thanks,

					- Ted

    
