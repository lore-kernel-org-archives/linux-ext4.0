From: Ric Wheeler <ricwheeler@gmail.com>
Subject: Re: ext4 64bit (disk >16TB) question
Date: Tue, 15 Jul 2008 16:15:46 -0400
Message-ID: <487D0572.50503@gmail.com>
References: <87bq10w8gv.fsf@frosties.localdomain> <20080715132734.68c64000@ichigo> <20080715195116.GL6239@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Jose R. Santos" <jrs@us.ibm.com>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.226]:30152 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758917AbYGOUPv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Jul 2008 16:15:51 -0400
Received: by wr-out-0506.google.com with SMTP id 69so3824299wri.5
        for <linux-ext4@vger.kernel.org>; Tue, 15 Jul 2008 13:15:50 -0700 (PDT)
In-Reply-To: <20080715195116.GL6239@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> On Jul 15, 2008  13:27 -0500, Jose R. Santos wrote:
>   
>> On Mon, 14 Jul 2008 21:50:56 +0200
>> Goswin von Brederlow <goswin-v-b@web.de> wrote:
>>     
>>> we are using lustre on a cluster of servers and raid boxes. Currently
>>> lustre is based on the ext3 code and has a limit of 8TiB for each
>>> filesystem. For us that results on having to split a servers storage
>>> into up to 4 chunks and run one fs on each which I would rather avoid.
>>> The solution for this would be to rebase the lustre patches to use
>>> ext4 instead, which should also reduce the patch set considerably.
>>> Lustre already patches a lot of ext4 features into the ext3 base.
>>>
>>>
>>> But before I start rebasing lustre I though I would first test out
>>> plain ext4 so I know any bugs I find will be from my rebasing and not
>>> already existing in ext4 itself. And there I run into a big problem:
>>> Current e2fsprogs (1.41) seem to be totaly unable to handle the ext4 64BIT
>>> feature, i.e. filesystems larger than 16TiB. The mkfs.ext4 always
>>> stops saying the disk exceeds the 32bit block count. And looking at
>>> the code I see a lot of blk_t (instead of blk64_t) and unsigned long
>>> (instead of unsigned long long [or even better blk64_t]) usage.
>>>
>>> I found ext4 64bit patches for e2fsprogs 1.39 that fix at least
>>> mkfs. Does anyone know if there is an updated patch set for 1.41
>>> anywhere? And when will that be added to e2fsprogs upstream?
>>>       
>> I've recently submitted a set of patches that covers most of the API
>> changes needed to support >16TB file systems (missing Ted bitmap
>> support of course).  Once the bitmap support is included, it _SHOULD_
>> be relatively painless to add mke2fs support with this series of patches.
>>     
>
> Jose,
> while waiting for the "efficient bitmap" support, how hard would it be
> to implement "inefficient bitmaps" that just malloc some GB of memory
> if needed?  This would at least allow people with huge devices to test
> mke2fs/ext4/e2fsck in the meantime.
>
> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
>
>   

I think that would be very useful - how much DRAM would we need for a 
16TB file system ;-) ?

ric

