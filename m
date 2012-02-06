From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 3/3] filemap: don't call generic_write_sync for -EIOCBQUEUED
Date: Mon, 06 Feb 2012 11:33:29 -0500
Message-ID: <x497gzzrkfa.fsf@segfault.boston.devel.redhat.com>
References: <1327698949-12616-1-git-send-email-jmoyer@redhat.com>
	<1327698949-12616-4-git-send-email-jmoyer@redhat.com>
	<20120202175219.GB6640@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, xfs@oss.sgi.com,
	linux-fsdevel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5406 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754513Ab2BFQdz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 6 Feb 2012 11:33:55 -0500
In-Reply-To: <20120202175219.GB6640@quack.suse.cz> (Jan Kara's message of
	"Thu, 2 Feb 2012 18:52:19 +0100")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jan Kara <jack@suse.cz> writes:

>   Hello,
>
> On Fri 27-01-12 16:15:49, Jeff Moyer wrote:
>> As it stands, generic_file_aio_write will call into generic_write_sync
>> when -EIOCBQUEUED is returned from __generic_file_aio_write.  EIOCBQUEUED
>> indicates that an I/O was submitted but NOT completed.  Thus, we will
>> flush the disk cache, potentially before the write(s) even make it to
>> the disk!
>   Yeah. It seems to be a problem introduced by Tejun's rewrite of barrier
> code, right? Before that we'd drain the IO queue when cache flush is issued
> and thus effectively wait for IO completion...

Right, though hch seems to think even then the problem existed.

>>  Up until now, this has been the best we could do, as file
>> systems didn't bother to flush the disk cache after an O_SYNC AIO+DIO
>> write.  After applying the prior two patches to xfs and ext4, at least
>> the major two file systems do the right thing.  So, let's go ahead and
>> fix this backwards logic.
>   But doesn't this break filesystems which you didn't fix explicitely even
> more than they were? You are right they might have sent cache flush too
> early but they'd at least propely force all metadata modifications (e.g.
> from allocation) to disk. But after this patch O_SYNC will have simply no
> effect for these filesystems.

Yep.  Note that we're calling into generic_write_sync with a negative
value.  I followed that call chain all the way down and convinced myself
that it was "mostly harmless," but it sure as heck ain't right.  I'll
audit other file systems to see whether it's a problem.  btrfs, at
least, isn't affected by this.

> Also I was thinking whether we couldn't implement the fix in VFS. Basically
> it would be the same like the fix for ext4. Like having a per-sb workqueue
> and queue work calling generic_write_sync() from end_io handler when the
> file is O_SYNC? That would solve the issue for all filesystems...

Well, that would require buy-in from the other file system developers.
What do the XFS folks think?

Cheers,
Jeff
