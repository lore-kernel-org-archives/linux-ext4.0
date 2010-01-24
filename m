From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH] fs: fix filesystem_sync vs write race on rw=>ro remount
Date: Sun, 24 Jan 2010 21:37:07 +0000
Message-ID: <20100124213707.GY19799@ZenIV.linux.org.uk>
References: <87sk9vd92c.fsf@openvz.org> <20100124195309.GX19799@ZenIV.linux.org.uk> <87r5pfw6ew.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:48711 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366Ab0AXVhJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 24 Jan 2010 16:37:09 -0500
Content-Disposition: inline
In-Reply-To: <87r5pfw6ew.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 25, 2010 at 12:15:51AM +0300, Dmitry Monakhov wrote:

> > It's not a solution.  You get an _attempted_ remount ro making writes
> > fail, even if it's going to be unsuccessful.  No go...
> We have two options for new writers:
> 1) Fail it via -EROFS
>    Yes, remount may fail, but it is really unlikely.
> 2) Defer(block) new writers on until we complete or fail remount
>    for example like follows. Do you like second solution ?

Umm...  I wonder what the locking implications would be...  Frankly,
I suspect that what we really want is this:
	* per-superblock write count of some kind, bumped when we decide
that writeback is inevitable and dropped when we are done with it (the
same thing goes for async part of unlink(), etc.)
	* fs_may_remount_ro() checking that write count
So basically we try to push those short-term writers to completion and
if new ones had come while we'd been doing that (or some are really
stuck) we fail remount with -EBUSY.

As a short-term solution the second patch would do probably (-stable and .33),
but in the next cycle I'd rather see something addressing the real problem.
fs_may_remount_ro() in its current form is really broken by design - it
should not scan any lists (which is where your race comes from, BTW)

