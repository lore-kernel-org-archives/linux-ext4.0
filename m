From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH][e2fsprogs] New bitmap and inode table allocation for
	FLEX_BG
Date: Thu, 3 Apr 2008 23:24:43 -0400
Message-ID: <20080404032443.GA362@mit.edu>
References: <20080401031311.10442.12267.stgit@gara.konoha.net> <20080403131240.GA13486@mit.edu> <20080403092858.5e3a7bb2@gara.konoha.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:52691 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752385AbYDDDZr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Apr 2008 23:25:47 -0400
Content-Disposition: inline
In-Reply-To: <20080403092858.5e3a7bb2@gara.konoha.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 03, 2008 at 09:28:58AM -0500, Jose R. Santos wrote:
> I blame Undo Manager for being so slow that cause me to skip some of
> the testing needed to be done.  

If that means we need a patch to disable the undo manager, via a
command-line option, feel free.  :-)

> I was incorrectly checking the feature
> flag instead of checking the value of fs->super->s_log_groups_per_flex.

Actually, you should check both, and we need to make mke2fs have an
intelligent default, which can be overridden via mke2fs.conf.

Also, it looks like this patch doesn't create a valid filesystem in
combination with meta_bg:

mke2fs G 32 -O meta_bg,flex_bg,uninit_groups,^resize_inode /tmp/foo.img

Then try running "e2fsck -f /tmp/foo.img" with the patch applied.

One obvious question is why is this patch so fragile....?  Is there
some way we can make it more likely not to break given other changes
to e2fsprogs in the future.

						- Ted
