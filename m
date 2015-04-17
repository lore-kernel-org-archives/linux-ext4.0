From: Akos Csete <akos.csete@gmail.com>
Subject: Re: Fsck repair takes very long for 1,761 inodes containing
 multiply-claimed blocks on ext4
Date: Fri, 17 Apr 2015 16:05:04 -0400
Message-ID: <CAD-ux61ti+D7_O2Xrtap5WEi7aFryQ4JoX4eO+J7dcuJS=DZag@mail.gmail.com>
References: <CAD-ux60opdAx0+t3EmwR1GWT6t3rZv7CXhxNNbwQLKX6jz_z7Q@mail.gmail.com>
	<20150415190614.GA11592@birch.djwong.org>
	<20150416150045.GB7445@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ob0-f179.google.com ([209.85.214.179]:35714 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbbDQUFE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Apr 2015 16:05:04 -0400
Received: by obbfy7 with SMTP id fy7so77501804obb.2
        for <linux-ext4@vger.kernel.org>; Fri, 17 Apr 2015 13:05:04 -0700 (PDT)
In-Reply-To: <20150416150045.GB7445@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks for the helpful suggestions. So manually reducing the number of
multiply-claimed blocks would save significant time for e2fsck's phase
of cloning blocks in such cases. I assume that running fsck.ext4 -nf
between repairs and summing the number of multiply-claimed blocks
reported in pass 1d would be indicative of the remaining work,
although only half of the total needs to be cloned/deleted.

In the particular scenario I was looking at a storage side error
started blocking writes from the machine. Per e2fsck the resulting
contiguous block allocations for new files were claiming subsets of
contiguous blocks belonging to older files. For e.g. inode #172163416
below was claiming blocks from older files:

...
Pass 1B: Rescanning for multiply-claimed blocks
...
Multiply-claimed block(s) in inode 161484221: => lists 2,465
multiply-claimed contiguous blocks
Multiply-claimed block(s) in inode 161484230: => lists 51,687
multiply-claimed blocks, 4 subsets of contiguous blocks
Multiply-claimed block(s) in inode 161484232: => lists 4,096
multiply-claimed contiguous blocks
Multiply-claimed block(s) in inode 161484266: => lists 6,503
multiply-claimed contiguous blocks
Multiply-claimed block(s) in inode 161494510: => lists 24,576
multiply-claimed contiguous blocks
Multiply-claimed block(s) in inode 172163416: => lists 86,792
multiply-claimed blocks, 2 subsets of contiguous blocks
...
Pass 1C: Scanning directories for inodes with multiply-claimed blocks
Pass 1D: Reconciling multiply-claimed blocks
...
File /archive/DNS-000.00.9.253_201503311401_queries.log (inode
#161484221, mod time Tue Mar 31 15:05:32 2015)
  has 2465 multiply-claimed block(s), shared with 1 file(s):
/import/201504091101_queries.log (inode #172163416, mod time Thu Apr
9 18:07:22 2015)
...
File /archive/DNS-000.00.6.253_201503311401_queries.log (inode
#161484230, mod time Tue Mar 31 15:05:26 2015)
  has 51687 multiply-claimed block(s), shared with 143 file(s):
...
File /archive/DNS-000.00.10.252_201503311401_queries.log (inode
#161484232, mod time Tue Mar 31 15:05:31 2015)
  has 4096 multiply-claimed block(s), shared with 1 file(s):
/import/201504091101_queries.log (inode #172163416, mod time Thu Apr
9 18:07:22 2015)
...
File /archive/DNS-000.00.15.252_201503311401_queries.log (inode
#161484266, mod time Tue Mar 31 15:05:23 2015)
  has 6503 multiply-claimed block(s), shared with 1 file(s):
/import/201504091101_queries.log (inode #172163416, mod time Thu Apr
9 18:07:22 2015)
...
File /archive/DNS-000.00.6.253_201504030701_queries.log (inode
#161494510, mod time Fri Apr  3 08:05:12 2015)
  has 24576 multiply-claimed block(s), shared with 1 file(s):
  /import/201504091101_queries.log (inode #172163416, mod time Thu Apr
 9 18:07:22 2015)
...
File /import/201504091101_queries.log (inode #172163416, mod time Thu
Apr  9 18:07:22 2015)
  has 86792 multiply-claimed block(s), shared with 5 file(s):
/archive/DNS-000.00.9.253_201503311401_queries.log (inode #161484221,
mod time Tue Mar 31 15:05:32 2015)
/archive/DNS-000.00.15.252_201503311401_queries.log (inode #161484266,
mod time Tue Mar 31 15:05:23 2015)
/archive/DNS-000.00.10.252_201503311401_queries.log (inode #161484232,
mod time Tue Mar 31 15:05:31 2015)
/archive/DNS-000.00.6.253_201503311401_queries.log (inode #161484230,
mod time Tue Mar 31 15:05:26 2015)
/archive/DNS-000.00.6.253_201504030701_queries.log (inode #161494510,
mod time Fri Apr  3 08:05:12 2015)
...

Could I then just wipe the inodes of the older files (and restore them
later from backup) and let the new file claim those blocks? Or are the
new file's claim to those blocks suspect?

Thanks,
Akos

On Thu, Apr 16, 2015 at 11:00 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Wed, Apr 15, 2015 at 12:06:14PM -0700, Darrick J. Wong wrote:
>> On Wed, Apr 15, 2015 at 11:18:18AM -0400, Akos Csete wrote:
>> > I ran into a very long execution time, approaching 48 hours, with
>> > e2fsck 1.42.9 when running e2fsck -fyv on a 7.8TB volume after
>> > fsck.ext4 -nf found 1761 inodes containing multiply-claimed blocks.
>> > I've been tailing the e2fsck output combined with a timestamp and
>> > found progress is extremely slow.
>> > Is this slow processing expected? I checked Ted's response to a 2009
>> > posting for ext3 with a similar issue where he recommended selectively
>> > wiping inodes with debugfs clri then restoring files as needed. Are
>> > there any other options for ext4, perhaps other/faster repair
>> > alternatives?
>>
>> Unfortunately, the multiple-blocks cleaner runs one block at a time and is
>> quite slow.  1.42.12 might improve things somewhat since I cleaned out some of
>> the stranger things it would do, but it's still not fast.
>>
>> (Some day in the future maybe we'll support reflink in which case this whole
>> part of fsck can go away.)
>
> Actually, reflink won't make the problem go away.  What probably
> *will* make this problem much less of an issue is when the metadata
> checksum code is fully supported with the relesae of e2fsprogs 1.43,
> since the most common cause of the problem is when the storage device
> screws up and stores blocks to the wrong location on disk.
>
> One way of recovering from this is to take the output to date in the
> pass 1b/c/d output, and to examine the inodes which are multiply
> claimed. Either the inodes will look like total garbage, or more
> likely, there will be a contiguous sequence of 16 or 32 inodes which
> look identical to a contiguous sequence of 16 or 32 inodes somewhere
> else.  So the trick is to use debugfs and figure out which contiguous
> set of inodes appear to be correct, by correlating the file names of
> those inodes (assuming the directory can be found) with the inode
> contents and/or types and/or user/gorupownership.  Once you figure out
> which set of 16 or 32 inodes are the bad copy, delete them using
> debugfs's clri command.
>
> The pass1b/c/d algorithsm are O(n**2), and since a chunk of inodes can
> be resolved/eliminated at a time, after you clear up a chunk of the
> inodes, you can rerun e2fsck, and hopefully the next run will take
> less time.  If it still stalls out, you can take the output of e2fsck
> and use it to clear out more inode numbers.
>
>                                                 - Ted
