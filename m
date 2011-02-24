From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [RFC][PATCH] ext2: Resolve i_nlink race in ext2_rename
Date: Thu, 24 Feb 2011 06:37:49 +0000
Message-ID: <20110224063749.GV22723@ZenIV.linux.org.uk>
References: <1298528501-32176-1-git-send-email-johunt@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	sandeen@redhat.com, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Josh Hunt <johunt@akamai.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:49623 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932381Ab1BXGhw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Feb 2011 01:37:52 -0500
Content-Disposition: inline
In-Reply-To: <1298528501-32176-1-git-send-email-johunt@akamai.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 23, 2011 at 10:21:41PM -0800, Josh Hunt wrote:
> [resending: left Jan off the original mail by accident]
> 
> We have a multi-threaded workload which is currently "losing" files in the form
> of unattached inodes. The workload is link, rename, unlink intensive. This is
> happening on an ext2 filesystem and have reproduced the issue in kernel
> 2.6.37.  Here's a sample strace:
> 
>     open("/a/tmp/tmpfile.1296184058", O_WRONLY|O_CREAT|O_TRUNC|O_LARGEFILE, 0666) = 9
>     link("/a/tmp/tmpfile.1296184058", "/a/tmp/tmpfile.28117.1296184059") = 0
>     rename("/a/tmp/tmpfile.28117.1296184059", "/a/tmp/tmpfile") = 0
>     stat64("/a/tmp/tmpfile", {st_mode=S_IFREG|0644, st_size=24248267, ...}) = 0
>     link("/a/tmp/tmpfile", "/a/tmp/submit/tmpfile")        = 0
>     open("/a/tmp/tmpfile.1296184058", O_RDONLY) = 13
>     open("/a/tmp/submit/tmpfile.send.q9SNoL", O_RDWR|O_CREAT|O_EXCL, 0600) = 824
>     rename("/a/tmp/submit/tmpfile", "/a/tmp/submit/tmpfile.send.q9SNoL")                = 0
>     unlink("/a/tmp/tmpfile.1296184058") = 0
>     open("/a/tmp/submit/tmpfile.send.q9SNoL", O_RDONLY) = 827
>     open("/a/tmp/submit/tmpfile.send.q9SNoL", O_RDONLY) = 828
>     open("/a/tmp/submit/tmpfile.send.q9SNoL", O_RDONLY) = 829
>     unlink("/a/tmp/submit/tmpfile.send.q9SNoL") = 0
> 
> The application behavior shown above repeats indefinitely with most filenames
> changing during each iteration except for 'tmpfile'. Looking into this issue I
> see that vfs_rename_other() only takes i_mutex for the new inode and the new
> inode's directory as well as the old directory's mutex. This works for
> modifying the dir entry and appears to be fine for most filesystems, but
> ext2 and a few others (exofs, minix, nilfs2, omfs, sysv, ufs) modify i_nlink
> inside of their respective rename functions without grabbing the i_mutex. The
> modifications are done through calls to inode_inc_link_count(old_inode) and
> inode_dec_link_count(old_inode), etc.
> 
> Taking the mutex for the old inode appears to resolve the issue of the
> lost files/unattached inodes that I am seeing with this workload. I've attached
> a patch below doing what I've described above. If this is an accepted solution
> I believe other filesystems may also be affected by this and I could provide
> a patch for those as well.

I don't know...  The thing is, we mostly do that to make life easier for
fsck in case of crash.  Other than that, there's no reason to play with
link count of that sucker at all.  The question is, do we really want
such rename() interrupted by dirty shutdown to result in what looks like two
legitimate links to that inode without any indications of what had happened?
Note that fsck (at least on ext2) will correct link counts anyway and if
nothing else, we probably want some noise pointing to the inode in question...

IOW, maybe it's better to rip these inc/dec for old_inode out and replace
them with mark_inode_dirty() in place where we currently do dec.  Comments?
