From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] direct-io: fix stale data exposure from concurrent buffered read
Date: Mon, 09 May 2016 09:55:26 -0400
Message-ID: <x49futr72up.fsf@segfault.boston.devel.redhat.com>
References: <1462033162-21837-1-git-send-email-guaneryu@gmail.com>
	<x49twic5m6m.fsf@segfault.boston.devel.redhat.com>
	<20160506104622.GB10350@eguan.usersys.redhat.com>
	<x49d1oz5l64.fsf@segfault.boston.devel.redhat.com>
	<20160507030400.GC10350@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Jan Kara <jack@suse.cz>, "Theodore T'so" <tytso@google.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Eryu Guan <guaneryu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3955 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072AbcEINz2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 May 2016 09:55:28 -0400
In-Reply-To: <20160507030400.GC10350@eguan.usersys.redhat.com> (Eryu Guan's
	message of "Sat, 7 May 2016 11:04:00 +0800")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eryu Guan <guaneryu@gmail.com> writes:

> On Fri, May 06, 2016 at 10:13:39AM -0400, Jeff Moyer wrote:
>> Eryu Guan <guaneryu@gmail.com> writes:
>> 
>> > On Thu, May 05, 2016 at 03:39:29PM -0400, Jeff Moyer wrote:
>> >> I think this code operates on blocks for a reason: we're trying to
>> >> determine if we'll trigger block allocation, right?  For example,
>> >> consider a sparse file with i_size of 2k, and a write to offset 2k into
>> >> the file, with a file system block size of 4k.  Should that have create
>> >> set or not?
>> >
>> > Thanks for pointing this out! I think 'create' should be 0 in this case,
>> > my test failed in this case, with both 4.6-rc6 stock kernel and my
>> > patched kernel.
>> >
>> > I'm testing an updated patch now, hopefully it's doing the right thing.
>> > It's basiclly something like:
>> >
>> > if (offset < i_size)
>> > 	create = 0;
>> > else if ((block_in_file >> blkfactor) == (i_size >> (blkbits + blkfactor)) &&
>> > 	 (i_size & ((1 << (blkbits + blkfactor)) - 1)))
>> > 	create = 0;
>> 
>> I think that can be simplified to a single check;  something like:
>> 
>> 	if (block_in_file < total_blocks_in_file)
>> 		create = 0;
>
> I may miss something, but this doesn't seem right to me. Still take your
> example, on a 4k block size & 512 sector size filesystem

... where blocks are in file system block size units.  So:

if (fs_block_in_file < total_fs_blocks_in_file)


> Thanks very much! I'll split it to two patches, first one is a cleanup,
> has no function change, second one is the real fix. This should make the
> review easier.

Typically the mininmal fix goes first (for ease of backporting to
stable), and then the cleanup.  As I said, though, this isn't critical,
I'll take a look.

Thanks!
Jeff
