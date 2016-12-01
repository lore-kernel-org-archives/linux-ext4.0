From: Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH] ext4: fix reading new encrypted symlinks on no-journal
 filesystems
Date: Thu, 1 Dec 2016 11:57:31 -0800
Message-ID: <20161201195731.GA131121@google.com>
References: <1479318627-143193-1-git-send-email-ebiggers@google.com>
 <2FD4E662-B708-4C34-B1FC-8D42083322A2@dilger.ca>
 <20161118184704.GA73496@google.com>
 <75C88E0E-FF89-4D20-B11C-8F705E249BDD@dilger.ca>
 <20161121231924.GG30672@google.com>
 <4CB8CE8B-8AFE-4266-9983-4B2555702EF3@dilger.ca>
 <20161201192705.nys7rs2py5q342ju@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
        linux-ext4 <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f53.google.com ([74.125.83.53]:36788 "EHLO
        mail-pg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934004AbcLAT5f (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Dec 2016 14:57:35 -0500
Received: by mail-pg0-f53.google.com with SMTP id f188so97961016pgc.3
        for <linux-ext4@vger.kernel.org>; Thu, 01 Dec 2016 11:57:35 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20161201192705.nys7rs2py5q342ju@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 01, 2016 at 02:27:05PM -0500, Theodore Ts'o wrote:
> So in the long term I think we can move to using i_size to determine
> fast symlinks, but I think there's a bigger issue hiding here, which
> is that we shouldn't be using delayed allocation for symlinks in the
> first place.  In the first place, symlinks will never be more than a
> block, so there's no advantage in using delalloc.  In the second
> place, it means that on a crash the symlink could invalid (zero
> length) --- and on a commit the symlink should be commited to disk.
> 
> Eric, do you have a test case which verifies this?  Normally I would
> think this rarely happens because the dentry cache should hide this
> particular issue.  I think a simpler fix up, which also avoids the
> "symlink could be lost on a crash" problem, is this:
> 
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index b48ca0392b9c..4ffb680780e5 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2902,7 +2902,8 @@ static int ext4_da_write_begin(struct file *file, struct address_space *mapping,
>  
>  	index = pos >> PAGE_SHIFT;
>  
> -	if (ext4_nonda_switch(inode->i_sb)) {
> +	if (ext4_nonda_switch(inode->i_sb) ||
> +	    S_ISLNK(inode->i_mode)) {
>  		*fsdata = (void *)FALL_BACK_TO_NONDELALLOC;
>  		return ext4_write_begin(file, mapping, pos,
>  					len, flags, pagep, fsdata);
> 
> 
> 					     	    - Ted
> 

Hi Ted,

The problem of a slow encrypted symlink being misinterpreted as a fast one can
be reproduced by generic/360 if you run it just right:

	kvm-xfstests -c nojournal -m test_dummy_encryption generic/360

It can also be reproduced by generic/402 from v2 of my encryption xfstests
patchset with 'kvm-xfstests -c nojournal generic/402'.  But running that one
requires applying xfstests and xfsprogs patches (until they get upstream).

The problem can be reliably reproduced because the symlink target is not cached
by the VFS.  ext4_encrypted_get_link() gets called whenever the symlink is
followed or whenever someone does sys_readlink.

I agree that delayed allocation doesn't make sense for symlinks so your proposed
fix is better.  I verified that it passes both of the xfstests mentioned above.

Eric
