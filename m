From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH V2] ext4: avoid deadlock on sync-mounted FS w/o journal
Date: Mon, 20 Feb 2012 23:08:31 -0500
Message-ID: <20120221040831.GG25249@thunk.org>
References: <4F3D9439.3050908@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Martin.Wilck@ts.fujitsu.com
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:53585 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752524Ab2BUEIe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Feb 2012 23:08:34 -0500
Content-Disposition: inline
In-Reply-To: <4F3D9439.3050908@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 16, 2012 at 03:41:45PM -0800, Eric Sandeen wrote:
> From: Martin.Wilck@ts.fujitsu.com
> 
> Processes hang forever on a sync-mounted ext2 file system that
> is mounted with the ext4 module (default in Fedora 16).
> 
> I can reproduce this reliably by mounting an ext2 partition with
> "-o sync" and opening a new file an that partition with vim. vim
> will hang in "D" state forever.  The same happens on ext4 without
> a journal.
> 
> I am attaching a small patch here that solves this issue for me.
> In the sync mounted case without a journal,
> ext4_handle_dirty_metadata() may call sync_dirty_buffer(), which
> can't be called with buffer lock held.
> 
> Also move mb_cache_entry_release inside lock to avoid race
> fixed previously by 8a2bfdcb ext[34]: EA block reference count racing fix
> Nonte too that ext2 fixed this same problem in 2006 with
> b2f49033 [PATCH] fix deadlock in ext2
> 
> Signed-off-by: Martin.Wilck@ts.fujitsu.com
> [sandeen@redhat.com: move mb_cache_entry_release before unlock, edit commit msg]
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Thanks, applied.

						- Ted
