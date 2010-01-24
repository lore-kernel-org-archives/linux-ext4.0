From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH] fs: fix filesystem_sync vs write race on rw=>ro remount
Date: Sun, 24 Jan 2010 19:53:09 +0000
Message-ID: <20100124195309.GX19799@ZenIV.linux.org.uk>
References: <87sk9vd92c.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:42379 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027Ab0AXTxL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 24 Jan 2010 14:53:11 -0500
Content-Disposition: inline
In-Reply-To: <87sk9vd92c.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jan 24, 2010 at 02:41:15PM +0300, Dmitry Monakhov wrote:
> Currently on rw=>ro remount we have following race
> | mount /mnt -oremount,ro | write-task |
> |-------------------------+------------|
> |                         | open(RDWR) |
> | shrink_dcache_sb(sb);   |            |
> | sync_filesystem(sb);    |            |
> |                         | write()    |
> |                         | close()    |
> | fs_may_remount_ro(sb)   |            |
> | sb->s_flags = new_flags |            |
> Later writeback or sync() will result in error due to MS_RDONLY flag
> In case of ext4 this result in jbd2_start failure on writeback
> ext4_da_writepages: jbd2_start: 1024 pages, ino 1431; err -30 
> In fact all others are affected by this error but it is not visible
> because the skip s_flags check on writeback. For example ext3 check
> (s_flags & MS_RDONLY) only if page has no buffers during journal start.
> 
> In order to prevent the race we have to block new writers before
> fs_may_remount_ro() and sync_filesystem(). Let's introduce new
> sb->s_flags MS_RO_REMOUNT flag for this purpose. But suddenly we have
> no available space in MS_XXX bits, let's share this bit with MS_REMOUNT.
> This is possible because MS_REMOUNT used only for passing arguments
> from flags to sys_mount() and never used in sb->s_flags.

It's not a solution.  You get an _attempted_ remount ro making writes
fail, even if it's going to be unsuccessful.  No go...
