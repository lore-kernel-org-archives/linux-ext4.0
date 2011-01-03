From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: question about file space preallocation with fallocate
Date: Mon, 03 Jan 2011 11:07:01 -0600
Message-ID: <4D220235.7000709@redhat.com>
References: <AANLkTinRcYrMrOUYqqCM3Lkpnhinm4NXqzDg1p2p0+68@mail.gmail.com> <4D18CA33.6050800@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Filipe David Manana <fdmanana@apache.org>,
	linux-ext4@vger.kernel.org
To: Sunil Mushran <sunil.mushran@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24839 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198Ab1ACRHc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Jan 2011 12:07:32 -0500
In-Reply-To: <4D18CA33.6050800@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/27/2010 11:17 AM, Sunil Mushran wrote:
> On 12/27/2010 06:47 AM, Filipe David Manana wrote:
>> Hi,
>>
>> I have been playing around with fallocate to preallocate space for a
>> file with the mode FALLOC_FL_KEEP_SIZE.
>> I'm running with Linux kernel 2.6.35-24 and ext4 as the fs.
>>
>> I'm allocating 1Gb for a newly created file and then in a loop I write
>> 1Gb of data into that file in chunks of 1Kb.
>> fallocate is returning me 0, therefore it was successful.
>> However I don't see any performance gains compared to a version of
>> that same code that doesn't call fallocate.
>>
>> The test code which does this is:  http://friendpaste.com/2UR0n2U851u4IXmubeLZh0
>>
>> Am I doing something wrong?
> 
> fallocate() gives users the ability to allocate space instantly. One way
> to compare would be to time just fallocate() with another program
> writing zeros for that length.
> 
> But that's not the aim of the syscall. The aim is to allow the fs to 
> allocate
> the space in as large chunks as possible to allow for better read
> performance.

Well, all fallocate is really -supposed- to do is guarantee that the
space will be available for a future write.

"After a successful call to posix_fallocate(), subsequent writes to
bytes in the  specified range are guaranteed not to fail because of lack
of disk space."

A practical side effect is that it is often more contiguous, but that
is not guaranteed.  It -could- return your allocated space in very
fragmented extents.

> If you don't do fallocate() and allow writes to allocate in small chunks,
> as you are doing, the allocations on disks could be interleaved in face of
> multiple processes doing the same. Fragmented allocations can only hurt
> read performance.

As you followed up in later emails, the original test case isn't going
to show much if any difference; a 1G write is so small that it may well
all turn into a single delalloc write anyway.  Since ext4 maxes out at
128MB extents that's still several extents to allocate but it's not that
much overhead.

A more interesting test might be to do random writes into a large
file, and compare preallocated vs. not-preallocated.  Ext4 leaves
physical gaps for logical gaps though, so even that may not show a huge
difference in performance, esp. when you consider that the random writes
will cause "fragmentation" anyway in terms of written- and
unwritten-extents which must be converted ...

-Eric
