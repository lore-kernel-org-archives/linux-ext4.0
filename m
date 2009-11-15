From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4: directory blocks must be treated as metadata by
	ext4_forget()
Date: Sun, 15 Nov 2009 15:43:46 -0500
Message-ID: <20091115204346.GE4323@mit.edu>
References: <20091114232912.GF4221@mit.edu> <1258245059-17687-1-git-send-email-tytso@mit.edu> <20091115070447.GA26614@skywalker.linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Curt Wohlgemuth <curtw@google.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:33884 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753736AbZKOUno (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 15 Nov 2009 15:43:44 -0500
Content-Disposition: inline
In-Reply-To: <20091115070447.GA26614@skywalker.linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Nov 15, 2009 at 12:34:48PM +0530, Aneesh Kumar K.V wrote:
> 
> I guess we need to make sure we call ext4_forget with correct
> is_metadata values. I did the below patch. The xattr changes in the
> patch should be split as a separate one.  I am not sure why we do a
> get_bh there.

It doesn't hurt to call ext4_forget() with the correct values, but I
figured it was easier just to make ext4_forget() DTRT thing by
checking the inode type since it has access to i_mode.  My patch
didn't take into account symlinks, though.   Good catch on your part.

> Another question i have is, do we actually supporting freeing
> directory blocks when we delete directory entries ? I remember
> reading we don't have support for that.

No, we don't.

> So may be Curt is not
> seeing the ext4_forget being called because he is trying delete of
> directory entries. I guess he will have to do a rmdir directory to
> see the directory blocks freed.

I'm assuming the problem that Curt was seeing was due to directories
being deleted, and the blocks getting reused immediately afterwards
for data blocks.  I'm guessing the right was done via direct I/O,
which means it would have been posted right away, and somehow the
dirty buffer head some managed to not get forgotten via bforget().  In
the non-journal case, I don't see how that could happen, but I must be
missing something with the code paths.  My experiments show that
ext4_forget() is getting called, but apparently somehow bforget() must
be getting called after that point.

> If you think the changes are correct i will send proper patches with s-o-b

I already have a patch in the patch queue, and I'll just update it to
include checking for S_ISLNK(inode->i_mode).  I suppose I can add your
change to set is_metadata in ext4_remove_blocks(), but that only
handles the extents case.  The direct/indirect mapped case also has a
similar issue, which is why decided it was most straightforward to fix
it in ext4_forget().

> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index fed5b01..3c93a9a 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -482,9 +482,8 @@ ext4_xattr_release_block(handle_t *handle, struct inode *inode,
>  		ea_bdebug(bh, "refcount now=0; freeing");
>  		if (ce)
>  			mb_cache_entry_free(ce);
> -		ext4_free_blocks(handle, inode, bh->b_blocknr, 1, 1);
> -		get_bh(bh);
>  		ext4_forget(handle, 1, inode, bh, bh->b_blocknr);
> +		ext4_free_blocks(handle, inode, bh->b_blocknr, 1, 1);
>  	} else {
>  		le32_add_cpu(&BHDR(bh)->h_refcount, -1);
>  		error = ext4_handle_dirty_metadata(handle, inode, bh);

This change isn't needed, as you pointed out in a later e-mail,
ext4_xattr_release_block() isn't supposed to change the refcount of
the buffer_head; it is brelse'ed by its caller.

    		       		    	- Ted
