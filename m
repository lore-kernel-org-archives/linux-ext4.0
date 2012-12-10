From: Darren Hart <dvhart@linux.intel.com>
Subject: Re: [PATCH RFC 0/3] ext2fsprogs: Symlink support and doc fix
Date: Mon, 10 Dec 2012 07:54:45 -0800
Message-ID: <50C605C5.7080806@linux.intel.com>
References: <1354744565-12594-1-git-send-email-dvhart@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:24801 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754434Ab2LJPzD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 10 Dec 2012 10:55:03 -0500
In-Reply-To: <1354744565-12594-1-git-send-email-dvhart@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Just a bump as a reminder so this series doesn't drop off the Inbox
queue :-)

Thanks,

Darren

On 12/05/2012 01:56 PM, Darren Hart wrote:
> As we appear to have agreed that adding symlink support to debugfs via a new
> ext2fs_symlink() function in libext2fs was something that needed doing, I
> thought I'd use this as a trial run for my first contribution to the ext2fsprogs
> package before I continue working on the larger project of completing initial
> directory support for mke2fs.
> 
> While I modeled this patch after existing code, their were some inconcsistencies
> in the code examples I used that I'd welcome input on. In particular:
> 
> o Should the ext2fs_link() happen right after ext2fs_new_inode()? Or should it
>   happen closer to the end of the operation? do_write() and ext2fs_mkdir()
>   handle this differently.
> 
> o Is it necessary to allocate the first block and assign it to the inode or the
>   extents? ext2fs_mkdir() does this, do_write() does not. I opted for the
>   simpler of the two and it passes my initial simple tests.
> 
> o Should I pass "mode" to ext2fs_new_inode() even though it is ignored?
> 
> o Would it make sense to try once to expand_dir rather than bailing out of
>   ext2fs_mkdir() and ext2fs_symlink() if the directory is full?
> 
> o What would we like the initial uid,gid,mode,*time values to be for
>   files/directories/links/etc. created with libext2fs?
> 
> Finally, I made an attempt to follow the coding style I observed in the code,
> but if I missed something, please let me know.
> 
> Thanks,
> 
> Darren Hart
> Intel Open Source Technology Center
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Technical Lead - Linux Kernel
