From: Valerie Clement <valerie.clement@bull.net>
Subject: Re: Error with the latest stable series of the patch queue.
Date: Tue, 19 Feb 2008 18:38:48 +0100
Message-ID: <47BB1428.1090809@bull.net>
References: <20080219152136.GA7177@skywalker> <47BB0E95.1000606@bull.net> <20080219172227.GD7177@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Mingming Cao <cmm@us.ibm.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:36531 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752820AbYBSRhq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Feb 2008 12:37:46 -0500
In-Reply-To: <20080219172227.GD7177@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
>> I've got also several issues while running ffsb tests today. The tests
>> ended with success but e2fsck reported an error:
>>
>>  Pass 1: Checking inodes, blocks, and sizes
>>  Inode 3367164, i_size is 57380864, should be 57442304.  Fix?
>>
>> Inode 3367164 is allocated in the last group of the filesystem.
>>
>> As I changed the allocation algorithm for the last group in the patch
>> "ext4_fix_block_alloc_algorithm_for_last_group.patch", I removed this
>> patch and ran again the same test. I didn't reproduce the issue.
>>
>> *But* I reproduced it on a filesystem created with a smaller block size
>> value (= 1024 instead of 4096 previously) and with a kernel *without*
>> my patch applied. e2fsck reports the same error on inodes created in the
>> last group. Sometimes in this configuration, error messages are also
>> displayed on the console:
>>
>> EXT4-fs error (device sdc): ext4_valid_block_bitmap: Invalid block bitmap 
>> - block_group = 7358, block = 60276737
>> EXT4-fs error (device sdc): ext4_valid_block_bitmap: Invalid block bitmap 
>> - block_group = 7358, block = 60276737
>>
>> and e2fsck reports errors like:
>> Inode 2113777 has corrupt extent index at block 61165699 (logical -1) entry 0
>> Fix?
>>
>> So, there is a problem when allocating inodes in the last group:
>> - without my patch when block size value is 1024,
>> - with my patch when block size value is 4096.
>>
>> Could you check if your tests allocate inodes in the last group and run
>> also e2fsck to see if it reports errors.
>>
>> For the moment, I have no idea how to fix that problem.
>>
> 
> This looks like a completely different problem. Will try to see if i can
> reproduce it here.
  OK, thanks a lot.

FYI I also reproduced it with 4096 block size when configuring 16000
blocks per group (instead of 32768 per default) when my patch is
not applied.
    Valerie
