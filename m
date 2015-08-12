From: Johan Harvyl <johan@harvyl.se>
Subject: Re: resize2fs: Should never happen: resize inode corrupt! - lost
 key inodes
Date: Thu, 13 Aug 2015 00:00:50 +0200
Message-ID: <55CBC212.6000507@harvyl.se>
References: <55CA3BDE.7020401@harvyl.se> <20150811224718.GD20658@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:36764 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbbHLWAy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 12 Aug 2015 18:00:54 -0400
Received: by lagz9 with SMTP id z9so16607061lag.3
        for <linux-ext4@vger.kernel.org>; Wed, 12 Aug 2015 15:00:52 -0700 (PDT)
In-Reply-To: <20150811224718.GD20658@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2015-08-12 00:47, Theodore Ts'o wrote:
> On Tue, Aug 11, 2015 at 08:15:58PM +0200, Johan Harvyl wrote:
>> I recently attempted an operation I have done many many times before, add a
>> drive to a raid array followed by offline resize2fs to expand the ext4fs on
>> it.
> If you've read the old threads, you'll note that online resize is
> actually safer (has proven to have had less bugs) than offline
> resize, at least with respect to big ext4 file systems.  :-/
Hi,

Thank you for you quick respone.

I did notice posts about online resizes being safer, which frankly 
surprised me, I would have expected
the opposite.

I would like to try my best, with your guidance, to track down how I 
ended up in this state, if nothing
else to avoid others ending up in the same situation.

The filesystem was originally created (with -O 64bit) on a 4*4TB device, 
so slightly under
16 power-of-2 TB using mke2fs 1.42.10.

I did not manually add the resize_inode feature flag at that time, but 
it is possible that I could
have added it later with tune2fs although I can neither remember doing 
so nor think of a reason
I would have. Could any of the e2fsprogs have added the resize_inode 
flag automatically, for instance
when it was expanded the first time, from just below 16 TB to just below 
20 TB?

When should this incompatibility of feature flags have been discovered, 
was it wrong to even end up
in a state where it was enabled on a >16 TB filesystem? Should it have 
been caught in a sanity before
performing the offline resize?

> I'm not aware of any offline resize with 1.42.13, but it sounds like
> you were originally using mke2fs and resize2fs 1.42.10, which did have
> some bugs, and so the question is what sort of might it might have
> left things.
What kind of bugs are we talking about, mke2fs? resize2fs? e2fsck? Any 
specific commits of interest?
I scanned the git log -p --full-history v1.42.10..v1.42.13 -- resize/ 
and nothing really jumped out at me...

Are you thinking the fs was actually put into a bad state already when 
it was first expanded from 16 TB
to 20 TB with resize2fs 1.42.10 although it did not show at the time?

Can you think of why it would zero out the first thousands of inodes, 
like the root inode, lost+found
and so on? I am thinking that would help me assess the potential damage 
to the files. Could I perhaps
expect the same kind of zeroed out blocks at regular intervals all over 
the device?

> It looks like you were resizing the file system from 18TB to 22TB.
perhaps not important, but to be clear, 20 TB -> 24 TB
> There shouldn't have been a resize inode if the file system was larger
> than 16TB, and so it sounds like is that was what tickled this error message:
And judging by the error and the code leading up to that error, my guess 
is there never was a resize inode
on that filesystem even though the feature flag was for some reason set.
>> # resize2fs /dev/md0
>> Should never happen: resize inode corrupt!
> This was after most of the resize work has been done, so the question
> is what we need to do to get your file system up and running again.
>
> What does "e2fsck -fn /dev/md0" report?

Since the journal inode (as well as the root inode) have been zeroed out 
in the resize process it exits
immediately with:
e2fsck 1.42.13 (17-May-2015)
ext2fs_check_desc: Corrupt group descriptor: bad block for inode table
e2fsck: Group descriptors look bad... trying backup blocks...
Superblock has an invalid journal (inode 8).
Clear? no

e2fsck: Illegal inode number while checking ext3 journal for /dev/md0

/dev/md0: ********** WARNING: Filesystem still has errors **********
#



I built the v1.42.13 tag with the fatal error removed hoping it would 
continue and I ended up with:
# ./e2fsck/e2fsck -fn /dev/md0
e2fsck 1.42.13 (17-May-2015)
ext2fs_check_desc: Corrupt group descriptor: bad block for inode table
./e2fsck/e2fsck: Group descriptors look bad... trying backup blocks...
Superblock has an invalid journal (inode 8).
Clear? no

./e2fsck/e2fsck: Illegal inode number while checking ext3 journal for 
/dev/md0
Resize inode not valid.  Recreate? no
....

Many hours later I checked the progress as it had not completed and it 
was still utilizing
100% of one core:
25544 root      20   0   78208  70700   2424 R  93.8  0.3 791:14.82 e2fsck

iotop/iostat indicated no significant disk activity on the device in 
question. I have not had time yet
to debug where it was stuck. An e2fsck -fn on that device, when it was 
still healthy, would typically
take an hour or two, not 10+ h.

>
> Hopefully "e2fsck -fy /dev/md0" will fix things for you, but if you
> haven't made backups, we should be careful before we move forward.
>
> 							- Ted
>
I have backups of the most important things, but before trying something 
that actually modifies
the fs I would like to do as thorough analysis as I can of what happened 
in order to avoid repeats
for myself and others as I believe there is a bug in at least one of the 
e2fsprogs that allowed for this
to happen.

thanks,
-johan

