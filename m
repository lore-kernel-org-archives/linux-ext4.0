From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH] fs: fix filesystem_sync vs write race on rw=>ro remount
Date: Mon, 25 Jan 2010 02:01:17 +0300
Message-ID: <87my03w1j6.fsf@openvz.org>
References: <87sk9vd92c.fsf@openvz.org>
	<20100124195309.GX19799@ZenIV.linux.org.uk>
	<87r5pfw6ew.fsf@openvz.org>
	<20100124213707.GY19799@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f226.google.com ([209.85.219.226]:35047 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941Ab0AXXBb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 24 Jan 2010 18:01:31 -0500
In-Reply-To: <20100124213707.GY19799@ZenIV.linux.org.uk> (Al Viro's message of
	"Sun, 24 Jan 2010 21:37:07 +0000")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Al Viro <viro@ZenIV.linux.org.uk> writes:

> On Mon, Jan 25, 2010 at 12:15:51AM +0300, Dmitry Monakhov wrote:
>
>> > It's not a solution.  You get an _attempted_ remount ro making writes
>> > fail, even if it's going to be unsuccessful.  No go...
>> We have two options for new writers:
>> 1) Fail it via -EROFS
>>    Yes, remount may fail, but it is really unlikely.
>> 2) Defer(block) new writers on until we complete or fail remount
>>    for example like follows. Do you like second solution ?
>
> Umm...  I wonder what the locking implications would be...  Frankly,
> I suspect that what we really want is this:
> 	* per-superblock write count of some kind, bumped when we decide
> that writeback is inevitable and dropped when we are done with it (the
> same thing goes for async part of unlink(), etc.)
> 	* fs_may_remount_ro() checking that write count
> So basically we try to push those short-term writers to completion and
> if new ones had come while we'd been doing that (or some are really
> stuck) we fail remount with -EBUSY.
>
> As a short-term solution the second patch would do probably (-stable and .33),
> but in the next cycle I'd rather see something addressing the real problem.
> fs_may_remount_ro() in its current form is really broken by design - it
> should not scan any lists (which is where your race comes from, BTW)
This is not actually true. The race happens not only because
fs_may_remount_ro() is not atomic, but because we have two stages
1) fs_may_remount_ro()
2) sync_filesystem()
Even when we make first stage atomic, we still have race between
second stage and new writers.
BTW: Your idea about per-sb counter may be useful here but
it must be not reference count, but it may be used like i_version
For example:
mnt_want_write()
{
   mnt->mnt_sb->s_wr_count++;
}
mnt_drop_write()
{
   mnt->mnt_sb->s_wr_count++;
}
do_remount_sb {
    cur = mnt->mnt_sb->s_wr_count;
    if (fs_may_remount_ro())
         return -EBUSY;
    sync_filesystem()
    if (cur != mnt->mnt_sb->s_wr_count)
         return -EBUSY;
}


