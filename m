From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: [PATCH]ext4: fix s_dirty_blocks_counter if block allocation	failed
 with nodelalloc
Date: Thu, 04 Dec 2008 10:27:25 +0900
Message-ID: <493731FD.5040809@rs.jp.nec.com>
References: <4933BAC2.6080004@rs.jp.nec.com> <20081201103641.GA13242@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, Li Zefan <lizf@cn.fujitsu.com>,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:58440 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbYLDB2D (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Dec 2008 20:28:03 -0500
In-Reply-To: <20081201103641.GA13242@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hi Aneesh,
Aneesh Kumar K.V wrote:
> On Mon, Dec 01, 2008 at 07:21:54PM +0900, Akira Fujita wrote:
>> ext4: Fix s_dirty_blocks_counter if block allocation failed with nodelalloc
>>
>> From: Akira Fujita <a-fujita@rs.jp.nec.com>
>>
>> If block allocation failed after marking claimed blocks as dirty blocks
>> with nodelalloc, we have to subtract these blocks from
>> s_dirty_blocks_counter in error handling.
>> Otherwise s_dirty_blocks_counter goes wrong so that
>> filesystem's free blocks decreases incorrectly.
> 
> Why did the block allocation fail ? With delayed allocation ENOSPC
> should not happen during block allocation. That would mean we did
> something wrong in block reservation.

My case was *nodelalloc* and FS was almost full.
This problem occurs in multiple defrag running in short time.
Usually defrag releases temporary inode's blocks with iput,
then FS free blocks are recover but contiguous blocks do not recover
until next journal commit.
so we can not re-use contiguous blocks immediately.
There are enough free blocks in FS so that
ext4_claim_free_blocks marks claimed blocks as dirty,
but ext4_regular_allocator can not find enough blocks,
so mb_new_blocks returns ENOSPC without decreasing dirty blocks.

Regards,
Akira Fujita

