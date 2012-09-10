From: Mike Fleetwood <mike.fleetwood@googlemail.com>
Subject: Re: How to query ext2/3/4 total fs size while mounted?
Date: Mon, 10 Sep 2012 11:39:39 +0100
Message-ID: <CAMU1PDic_hPBogL_orM5XYjhYxGRdATTrdJxU=GuqFrtSYG28Q@mail.gmail.com>
References: <CAMU1PDg-WrH9TS-U9SfeMfV2FTBz7Md+7PR1k55aMTFVq=7NiA@mail.gmail.com>
	<20120908003927.GE2542@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:38075 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755918Ab2IJKjk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 10 Sep 2012 06:39:40 -0400
Received: by qaas11 with SMTP id s11so784717qaa.19
        for <linux-ext4@vger.kernel.org>; Mon, 10 Sep 2012 03:39:39 -0700 (PDT)
In-Reply-To: <20120908003927.GE2542@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 8 September 2012 01:39, Theodore Ts'o <tytso@mit.edu> wrote:
> On Fri, Sep 07, 2012 at 09:12:49PM +0100, Mike Fleetwood wrote:
>>
>> Is it safe to read the super block off disk using ext2fs_open() or by
>> running dumpe2fs for a mounted file system?  What if the file system has
>> just been resized?  Are there any other methods for querying the total
>> file system size?
>
> Yes, it would be safe to read the superblock off a mounted disk.
> There is always going to be a race if someone is resizing the file
> system as you read the file system, but that's true for the statfs
> system call as well.

It would also be easiest if GParted can use the free blocks from the on
disk super block too, rather than calling statvfs().  How up to date
will the on disk free blocks figure be?

My testing using a slowly allocating space workload finds ext2 writes
the super block every 6 seconds keeping the blocks free figure up to
date.  However for ext3 & ext4 the super block doesn't change.  I guess
because all the meta data updates are journalled and can be replayed on
crash.

Freezing and unfreezing ext3/4 does get the blocks free figure in the
super block updated, but GParted shouldn't be freezing and unfreezing a
file system just to get the free space.  I guess that GParted should
just use statvfs() to query free blocks.

Thanks,
Mike
