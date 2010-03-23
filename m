From: jing zhang <zj.barak@gmail.com>
Subject: Re: [PATCH] ext4: memory leakage in ext4_mb_init()
Date: Tue, 23 Mar 2010 20:47:39 +0800
Message-ID: <ac8f92701003230547p3e56a9cdnff8ce874535db117@mail.gmail.com>
References: <ac8f92701003210701j5926f2c4v843e36bc602a0444@mail.gmail.com>
	 <20100322012758.GE11560@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@sun.com>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61701 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072Ab0CWMrk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Mar 2010 08:47:40 -0400
Received: by gyg8 with SMTP id 8so3178504gyg.19
        for <linux-ext4@vger.kernel.org>; Tue, 23 Mar 2010 05:47:40 -0700 (PDT)
In-Reply-To: <20100322012758.GE11560@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2010/3/22, tytso@mit.edu <tytso@mit.edu>:
> On Sun, Mar 21, 2010 at 10:01:06PM +0800, jing zhang wrote:
>> From: Jing Zhang <zj.barak@gmail.com>
>>
>> Date: Sun Mar 21 21:59:35     2010
>>
>> Cc: Theodore Ts'o <tytso@mit.edu>
>> Cc: Andreas Dilger <adilger@sun.com>
>> Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
>> Signed-off-by: Jing Zhang <zj.barak@gmail.com>
>>
>> ---
>>
>> --- linux-2.6.32/fs/ext4/mballoc.c	2009-12-03 11:51:22.000000000 +0800
>> +++ ext4_mm_leak/mballoc3.c	2010-03-21 21:37:18.000000000 +0800
>> @@ -2360,6 +2360,24 @@ err_freesgi:
>>  	return -ENOMEM;
>>  }
>>
>> +static void ext4_mb_destroy_backend(struct super_block *sb)
>> +{
>> +	ext4_group_t ngroups = ext4_get_groups_count(sb);
>> +	ext4_group_t i;
>> +	struct ext4_sb_info *sbi = EXT4_SB(sb);
>> +	int j;
>> +	int num_meta_group_infos = (ngroups + EXT4_DESC_PER_BLOCK(sb) -1)
>> +					>> EXT4_DESC_PER_BLOCK_BITS(sb);
>> +	for (i = 0; i < ngroups; i++)
>> +		kfree(ext4_get_group_info(sb, i));
>> +
>> +	for (j = 0; j < num_meta_group_infos; j++)
>> +		kfree(sbi->s_group_info[j]);
>> +
>> +	kfree(sbi->s_group_info);
>> +	iput(sbi->s_buddy_cache);
>> +}
>> +
>
> It would be better if this could be done by making ext4_mb_release()
> more flexible, and then calling ext4_mb_release() if there is an error
> setting up the data structures in ext4_mb_init().
>
> 						- Ted
>

Yeah, Ted, going through ext4_mb_release() is clearer.

---

diff --git a/linux-2.6.32/fs/ext4/mballoc.c b/ext4_mm_leak/mballoc3.c
index bba1282..99ca2de 100644
--- a/linux-2.6.32/fs/ext4/mballoc.c
+++ b/ext4_mm_leak/mballoc3.c
@@ -2417,8 +2417,7 @@ int ext4_mb_init(struct super_block *sb, int
needs_recovery)

 	sbi->s_locality_groups = alloc_percpu(struct ext4_locality_group);
 	if (sbi->s_locality_groups == NULL) {
-		kfree(sbi->s_mb_offsets);
-		kfree(sbi->s_mb_maxs);
+		ext4_mb_release(sb);
 		return -ENOMEM;
 	}
 	for_each_possible_cpu(i) {
@@ -2511,7 +2510,8 @@ int ext4_mb_release(struct super_block *sb)
 				atomic_read(&sbi->s_mb_discarded));
 	}

-	free_percpu(sbi->s_locality_groups);
+	if (sbi->s_locality_groups)
+		free_percpu(sbi->s_locality_groups);
 	if (sbi->s_proc)
 		remove_proc_entry("mb_groups", sbi->s_proc);
