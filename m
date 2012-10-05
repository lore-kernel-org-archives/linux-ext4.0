From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix ext4_flush_completed_IO wait semantics
Date: Fri, 5 Oct 2012 08:40:27 -0400
Message-ID: <20121005124027.GA21358@thunk.org>
References: <1349289807-18811-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jack@suse.cz
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:53954 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932491Ab2JEMkc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Oct 2012 08:40:32 -0400
Content-Disposition: inline
In-Reply-To: <1349289807-18811-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 03, 2012 at 10:43:27PM +0400, Dmitry Monakhov wrote:
> -int ext4_flush_completed_IO(struct inode *inode)
> +int ext4_flush_unwritten_io(struct inode *inode)
>  {
> -	return ext4_do_flush_completed_IO(inode, NULL);
> +	int ret;
> +	WARN_ON_ONCE(!mutex_is_locked(&inode->i_mutex));
> +	ret = ext4_do_flush_completed_IO(inode, NULL);
> +	ext4_unwritten_wait(inode);
> +	return ret;
>  }
>  

This WARN_ON is triggering on the truncate path...

------------[ cut here ]------------
WARNING: at /usr/projects/linux/ext4/fs/ext4/page-io.c:232 ext4_flush_unwritten_io+0x2d/0x4c()
Hardware name: Bochs
Modules linked in:
Pid: 1907, comm: findfs Not tainted 3.6.0-rc1-00071-gb1edc6d #441
Call Trace:
 [<c0159cb3>] warn_slowpath_common+0x68/0x7d
 [<c0272ebd>] ? ext4_flush_unwritten_io+0x2d/0x4c
 [<c0159cdc>] warn_slowpath_null+0x14/0x18
 [<c0272ebd>] ext4_flush_unwritten_io+0x2d/0x4c
 [<c028fa09>] ext4_ext_truncate+0x21/0x174
 [<c0270cbb>] ? ext4_mark_inode_dirty+0x172/0x1a9
 [<c026ed9e>] ext4_truncate+0x7b/0xb9
 [<c0272414>] ext4_evict_inode+0x1ec/0x2e3
 [<c021a724>] evict+0x94/0x135
 [<c021a939>] iput+0x174/0x17a
 [<c02122bd>] do_unlinkat+0xc8/0x106
 [<c06d8b5e>] ? restore_all+0xf/0xf
 [<c0199909>] ? trace_hardirqs_on_caller+0x103/0x154
 [<c02138f0>] sys_unlink+0x15/0x17
 [<c06d8b25>] syscall_call+0x7/0xb
---[ end trace cdd8306e94494df8 ]---

							- Ted

