From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: [RFC][PATCH 7/8]ext4: move victim files for the target file (-f
 mode)
Date: Mon, 16 Jun 2008 17:39:35 +0900
Message-ID: <485626C7.2090106@rs.jp.nec.com>
References: <483FE289.7050302@rs.jp.nec.com> <4855D32A.1020000@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Theodore Tso <tytso@mit.edu>, Mingming Cao <cmm@us.ibm.com>
To: Shen Feng <shen@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:47158 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756956AbYFPIkK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Jun 2008 04:40:10 -0400
In-Reply-To: <4855D32A.1020000@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Shen Feng Wrote:
> 
> Akira Fujita Wrote:
>> ext4: online defrag-- Move victim files for the target file (-f mode)
>>
>> From: Akira Fujita <a-fujita@rs.jp.nec.com>
>>
>> Move victim files to make sufficient space and reallocates
>> the contiguous blocks for the target file.
>>
>> Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
>> Signed-off-by: Takashi Sato <t-sato@yk.jp.nec.com>
>> ---
>>  fs/ext4/balloc.c       |   10 +-
>>  fs/ext4/defrag.c       |  460 +++++++++++++++++++++++++++++++++++++++++++++---
>>  fs/ext4/ext4.h         |   29 +++-
>>  fs/ext4/ext4_extents.h |    5 +
>>  fs/ext4/extents.c      |   54 +++++--
>>  fs/ext4/ioctl.c        |    5 +-
>>  fs/ext4/mballoc.c      |    5 +
>>  fs/ext4/mballoc.h      |    1 +
>>  8 files changed, 522 insertions(+), 47 deletions(-)
>>
> 
> ...snip...
> 
>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>> index d0b1301..88fd100 100644
>> --- a/fs/ext4/ext4.h
>> +++ b/fs/ext4/ext4.h
>> @@ -94,6 +94,11 @@ struct ext4_allocation_request {
>>  	unsigned long len;
>>  	/* flags. see above EXT4_MB_HINT_* */
>>  	unsigned long flags;
>> +	/*
>> +	 * for ext4 online defrag:
>> +	 * the block group which is excepted from allocation target
>> +	 */
>> +	long long excepted_group;
>>  };
> 
> Why not ext4_group_t for excepted_group here?

ac_excepted_group has not only excepted block group number
but also -1 (it means any block groups are accepted).
So we should keep it as long long variable to show
the special status correctly in large ext4.

Regards,
Akira Fujita
