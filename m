From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Question on fallocate/ftruncate sequence
Date: Thu, 23 Jul 2009 12:00:19 -0500
Message-ID: <4A689723.7000805@redhat.com>
References: <6601abe90907200936w61ebda92reae368a2b9efac66@mail.gmail.com>	 <4A64F37D.7020803@redhat.com>	 <1248211771.20743.2.camel@bobble.smo.corp.google.com>	 <20090721215421.GM4231@webber.adilger.int>	 <1248304214.14463.17.camel@bobble.smo.corp.google.com>	 <4A67D36D.20708@redhat.com> <1248366422.27509.1.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@sun.com>,
	Curt Wohlgemuth <curtw@google.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Frank Mayhar <fmayhar@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:39374 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753026AbZGWRAn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 23 Jul 2009 13:00:43 -0400
In-Reply-To: <1248366422.27509.1.camel@bobble.smo.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Frank Mayhar wrote:
> On Wed, 2009-07-22 at 22:05 -0500, Eric Sandeen wrote:
>> Frank Mayhar wrote:
>>> On Tue, 2009-07-21 at 15:54 -0600, Andreas Dilger wrote:
>> ...
>>
>>>> That said, we might need to have some kind of flag in the on-disk
>>>> inode to indicate that it was preallocated beyond EOF.  Otherwise,
>>>> e2fsck will try and extend the file size to match the block count,
>>>> which isn't correct.  We could also use this flag to determine if
>>>> truncate needs to be run on the inode even if the new size is the
>>>> same.
>>> After chatting with Curt about this today, it sounds like this needs two
>>> things.  One is your flag in the on-disk inode, set in fallocate() to
>>> indicate that it has an allocation past EOF.  E2fsck would use this to
>>> avoid "fixing" the file size to match the block count.  Truncate would
>>> use this to notice that there are blocks allocated past i_size and get
>>> rid of them.  It would be cleared by truncate or by ext4_get_blocks when
>>> using the last block of such an allocation.
>>>
>>> Does this make sense?  Have I missed anything?
>> I guess I'm not totally sold on the new on-disk flag; we can work out
>> blocks past EOF w/o needing a new flag can't we?
> 
> It's on-disk because e2fsck needs it to know when not to extend i_size
> to the actual allocated length of the file.  Were it not for that we
> could easily solve the fallocate/trucate problem with an in-memory flag
> only.

Sorry I skimmed to fast, skipped over the fsck part.  But:

# mkfs.ext4 /dev/sdb3
mke2fs 1.41.5 (23-Apr-2009)
...
# mount /dev/sdb3 /mnt/test
# touch /mnt/test/testfile
# /root/fallocate -n -l 16m /mnt/test/testfile
# ls -l /mnt/test/testfile
-rw-r--r-- 1 root root 0 Jul 23 12:13 /mnt/test/testfile
# du -h /mnt/test/testfile
16M	/mnt/test/testfile
# umount /mnt/test
# e2fsck -f /dev/sdb3
e2fsck 1.41.5 (23-Apr-2009)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
/dev/sdb3: 12/244800 files (0.0% non-contiguous), 37766/977956 blocks

there doesn't seem to be a problem in fsck w/ block past EOF, or am I
missing something else?

-Eric
