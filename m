From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: [RFC][PATCH 7/9]ext4: Add the EXT4_IOC_FIEMAP_INO ioctl
Date: Thu, 06 Nov 2008 16:39:08 +0900
Message-ID: <49129F1C.7050600@rs.jp.nec.com>
References: <49019EF6.4000706@rs.jp.nec.com> <20081026084048.GF3184@webber.adilger.int> <20081026084848.GA9270@infradead.org> <20081031100547.GA22093@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org,
	Theodore Tso <tytso@mit.edu>, Mingming Cao <cmm@us.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:58044 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbYKFHjl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Nov 2008 02:39:41 -0500
In-Reply-To: <20081031100547.GA22093@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Christoph,
Christoph Hellwig wrote:
> Akira, can you please comment on these issues before going on?
> I think the generation issue is a particularly important one if you
> want to allow defrag by normal users.

For a regular user defrag (-f), I'll add the check
to solve the generation issue in the following procedures (1-4).
Please check whether my approach is right or not.

1. Acquire the extents information of inode in kernel space
    and then return it to user space with EXT4_IOC_FIEMAP_INO.

2. Calculate the victim extents from the combination of
    extents (the result of 1) and free space extents.

3. Pass the victim extents (move to the other block group to make free space)
    from user space to kernel space with EXT4_IOC_MOVE_VICTIM.

4. In kernel space, make sure the permission and the extents construction
    of the passed inode (the passed inode still covers
    the victim extent area or not).
    If there is no problem, defrag continues its process.

If check (4) failed, it means victim extents was changed
and that area might be already used by other users, so defrag will fail.

If my approach doesn't seem to be a problem, I will work on it.

Regards,
Akira Fujita

> On Sun, Oct 26, 2008 at 04:48:48AM -0400, Christoph Hellwig wrote:
>> On Sun, Oct 26, 2008 at 02:40:48AM -0600, Andreas Dilger wrote:
>>> This was mentioned last time these patches were posted, but there was
>>> no reply from you.  Christoph suggested a more generic VFS open-by-inum,
>>> which isn't impossible to do but would cause a lot of controversy I
>>> think, while the EXT4_IOC_WRAPPER is at least contained within ext4,
>>> but is more generically useful than EXT4_IOC_FIEMAP_INO.
>> I'll hack up a generic open_by_handle and then we can gather the
>> reaction - it shouldn't be more than about one or two hundred lines of
>> code.  Note that you really want an open by handle and not just inum for
>> a defragmentation tool - without the generation you can easily run into
>> races.
>>
>> Btw, any reason the XFS approach of passing in *file descriptors* for both
>> the inode to be defragmented and the "donor" inode doesn't work for you?

