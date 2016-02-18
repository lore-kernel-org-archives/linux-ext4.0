From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: problem in ext2fs_get_next_inode_full() ?
Date: Thu, 18 Feb 2016 15:30:35 -0700
Message-ID: <E32557C0-B912-4F00-BF85-F0A1A2B23496@dilger.ca>
References: <D2EB8E48.12F559%andreas.dilger@intel.com>
Mime-Version: 1.0 (Mac OS X Mail 9.2 \(3112\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f171.google.com ([209.85.192.171]:36025 "EHLO
	mail-pf0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757190AbcBRWaj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Feb 2016 17:30:39 -0500
Received: by mail-pf0-f171.google.com with SMTP id e127so38996702pfe.3
        for <linux-ext4@vger.kernel.org>; Thu, 18 Feb 2016 14:30:38 -0800 (PST)
In-Reply-To: <D2EB8E48.12F559%andreas.dilger@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Feb 18, 2016, at 3:05 PM, Dilger, Andreas <andreas.dilger@intel.com> wrote:
> 
> I was just looking at ext2fs_get_next_inode_full() to trace where we
> are using large inodes and whether we could change the APIs to just
> pass large inodes around instead of typecasting them.  It has the
> following hunk of code:
> 
>        if (extra_bytes) {
> 		memcpy(scan->temp_buffer+extra_bytes, scan->ptr,
> 		       scan->inode_size - extra_bytes);
> 		scan->ptr += scan->inode_size - extra_bytes;
> 		scan->bytes_left -= scan->inode_size - extra_bytes;
> 
> #ifdef WORDS_BIGENDIAN
> 		memset(inode, 0, bufsize);
> 		ext2fs_swap_inode_full(scan->fs,
> 				(struct ext2_inode_large *) inode,
> 				(struct ext2_inode_large *) scan->temp_buffer,
> 				0, bufsize);
> #else
> 		*inode = *((struct ext2_inode *) scan->temp_buffer);
> #endif
> 
> So if the inode is being swabbed then it handles the full inode size, but
> if it is not being swabbed (the common case) it appears that it is only
> copying the small inode into "*inode" using a struct assignment.  This
> appears like it would be dropping the large inode data, but I'm not sure
> if or when this "extra_bytes" case is hit.  The "else" clause appears to
> copy the requested (full) inode size properly via "memcpy(..., bufsize)".
> 
> Should the struct assignment be changed similarly to use memcpy()?

To follow up on my own email - I also see struct ext2_inode_cache_ent is
only caching the small inode, and not a large inode.  This would seem to
potentially cause loss of the large inode data if the inode cache is
used by tools like resize2fs or others that move around inodes?

Cheers, Andreas





