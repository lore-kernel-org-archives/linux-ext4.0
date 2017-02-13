From: Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH] ext4: don't BUG when truncating encrypted inodes on the
 orphan list
Date: Mon, 13 Feb 2017 10:19:55 -0800
Message-ID: <20170213181955.GA44321@google.com>
References: <20170211031942.11783-1-tytso@mit.edu>
 <20170212220900.GA566@zzz>
 <20170213151927.vi4pzuggm5t6kqe5@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Biggers <ebiggers3@gmail.com>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f50.google.com ([209.85.214.50]:35173 "EHLO
        mail-it0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750975AbdBMSUA (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Feb 2017 13:20:00 -0500
Received: by mail-it0-f50.google.com with SMTP id 203so197489717ith.0
        for <linux-ext4@vger.kernel.org>; Mon, 13 Feb 2017 10:20:00 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20170213151927.vi4pzuggm5t6kqe5@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 13, 2017 at 10:19:27AM -0500, Theodore Ts'o wrote:
> 
> > > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > > index bc282f9d0969..831d025e59ad 100644
> > > --- a/fs/ext4/inode.c
> > > +++ b/fs/ext4/inode.c
> > > @@ -3944,6 +3944,10 @@ static int ext4_block_truncate_page(handle_t *handle,
> > >  	unsigned blocksize;
> > >  	struct inode *inode = mapping->host;
> > >  
> > > +	/* If we are processing an encrypted inode during orphan list handling */
> > > +	if (!fscrypt_has_encryption_key(inode))
> > > +		return 0;
> > > +
> > >  	blocksize = inode->i_sb->s_blocksize;
> > >  	length = blocksize - (offset & (blocksize - 1));
> > 
> > Shouldn't it be:
> > 
> > 	if (ext4_encrypted_inode(inode) && S_ISREG(inode->i_mode) &&
> > 	    !fscrypt_has_encryption_key(inode))
> > 		return 0;
> > 
> > ... since only encrypted regular files should be skipped?
> 
> We certainly don't want to add the ext4_encrypted_inode() test, since
> this can fail even if -O encrypt is not enabled.  As for checking for
> regular files, we could potentially fall into this code path for
> non-regular files too (symlinks with length greater than 60 bytes come
> to mind), and if we don't have the encryption key, there's no *point*
> to try to zero beyond i_size --- and if we do, we're going to fail
> with a BUG.
> 

Are you sure?  ext4_encrypted_inode() only checks the inode flag; it doesn't
check the superblock flag too.  If we check for just
!fscrypt_has_encryption_key(), the zeroing will get skipped for all
*unencrypted* files too.

Also, my suggestion matches the logic in
__ext4_block_zero_page_range() where the BUG() is actually being hit:

                if (S_ISREG(inode->i_mode) &&
                    ext4_encrypted_inode(inode)) {
                        /* We expect the key to be set. */
                        BUG_ON(!fscrypt_has_encryption_key(inode));
                        BUG_ON(blocksize != PAGE_SIZE);
                        WARN_ON_ONCE(fscrypt_decrypt_page(page->mapping->host,
                                                page, PAGE_SIZE, 0, page->index));
                }


- Eric
