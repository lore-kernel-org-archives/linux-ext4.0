From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Error with the latest stable series of the patch queue.
Date: Tue, 19 Feb 2008 22:52:27 +0530
Message-ID: <20080219172227.GD7177@skywalker>
References: <20080219152136.GA7177@skywalker> <47BB0E95.1000606@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Mingming Cao <cmm@us.ibm.com>
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:44140 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945AbYBSRWf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Feb 2008 12:22:35 -0500
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp05.au.ibm.com (8.13.1/8.13.1) with ESMTP id m1JHMJ0u012225
	for <linux-ext4@vger.kernel.org>; Wed, 20 Feb 2008 04:22:19 +1100
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1JHQBPm276302
	for <linux-ext4@vger.kernel.org>; Wed, 20 Feb 2008 04:26:11 +1100
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m1JHMXDa003449
	for <linux-ext4@vger.kernel.org>; Wed, 20 Feb 2008 04:22:33 +1100
Content-Disposition: inline
In-Reply-To: <47BB0E95.1000606@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 19, 2008 at 06:15:01PM +0100, Valerie Clement wrote:
> Aneesh Kumar K.V wrote:
>> Hi all,
>>
>> I am seeing the below error in the console. But the tests are reported
>> as success.
>>
>> EXT4-fs: mballoc enabled
>> EXT4-fs error (device sda7): ext4_ext_find_extent: bad header in inode
>> #204044: invalid magic - magic 0, entries 0, max 0(0), depth 0(0)
>> EXT4-fs error (device sda7): ext4_ext_find_extent: bad header in inode
>> #204045: invalid magic - magic 0, entries 0, max 0(0), depth 0(0)
>> EXT4-fs error (device sda7): ext4_ext_find_extent: bad header in inode
>> #204047: invalid magic - magic 0, entries 0, max 0(0), depth 0(0)
>> EXT4-fs error (device sda7): ext4_ext_find_extent: bad header in inode
>> #204056: invalid magic - magic 0, entries 0, max 0(0), depth 0(0)
>> EXT4-fs error (device sda7): ext4_ext_find_extent: bad header in inode
>> #204061: invalid magic - magic 0, entries 0, max 0(0), depth 0(0)
>> EXT4-fs error (device sda7): ext4_ext_find_extent: bad header in inode
>> #204065: invalid magic - magic 0, entries 0, max 0(0), depth 0(0)
>> EXT4-fs error (device sda7): ext4_ext_find_extent: bad header in inode
>> #204068: invalid magic - magic 0, entries 0, max 0(0), depth 0(0)
>> EXT4-fs error (device sda7): ext4_ext_find_extent: bad header in inode
>> #204069: invalid magic - magic 0, entries 0, max 0(0), depth 0(0)
>> EXT4-fs error (device sda7): ext4_ext_find_extent: bad header in inode
>> #204071: invalid magic - magic 0, entries 0, max 0(0), depth 0(0)
>> EXT4-fs error (device sda7): ext4_ext_find_extent: bad header in inode
>> #204077: invalid magic - 
>>

The above problem is due to symlink having extent flag set but not
having extent tree initialized. That was mainly due to inheriting the
inode i_flag from parent directory. I am right now testing fix for this.


> Hi Aneesh,
>
> I've got also several issues while running ffsb tests today. The tests
> ended with success but e2fsck reported an error:
>
>  Pass 1: Checking inodes, blocks, and sizes
>  Inode 3367164, i_size is 57380864, should be 57442304.  Fix?
>
> Inode 3367164 is allocated in the last group of the filesystem.
>
> As I changed the allocation algorithm for the last group in the patch
> "ext4_fix_block_alloc_algorithm_for_last_group.patch", I removed this
> patch and ran again the same test. I didn't reproduce the issue.
>
> *But* I reproduced it on a filesystem created with a smaller block size
> value (= 1024 instead of 4096 previously) and with a kernel *without*
> my patch applied. e2fsck reports the same error on inodes created in the
> last group. Sometimes in this configuration, error messages are also
> displayed on the console:
>
> EXT4-fs error (device sdc): ext4_valid_block_bitmap: Invalid block bitmap 
> - block_group = 7358, block = 60276737
> EXT4-fs error (device sdc): ext4_valid_block_bitmap: Invalid block bitmap 
> - block_group = 7358, block = 60276737
>
> and e2fsck reports errors like:
> Inode 2113777 has corrupt extent index at block 61165699 (logical -1) entry 0
> Fix?
>
> So, there is a problem when allocating inodes in the last group:
> - without my patch when block size value is 1024,
> - with my patch when block size value is 4096.
>
> Could you check if your tests allocate inodes in the last group and run
> also e2fsck to see if it reports errors.
>
> For the moment, I have no idea how to fix that problem.
>

This looks like a completely different problem. Will try to see if i can
reproduce it here.

-aneesh
>
>
>
>
>
>
>
