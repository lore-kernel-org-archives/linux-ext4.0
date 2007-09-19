From: Avantika Mathur <mathur@linux.vnet.ibm.com>
Subject: Re: [PATCH] Ext4: Uninitialized Block Groups
Date: Wed, 19 Sep 2007 12:19:22 -0700
Message-ID: <46F1763A.1040807@linux.vnet.ibm.com>
References: <46F06C7B.20308@linux.vnet.ibm.com> <1190203577.14472.25.camel@ext1.frec.bull.fr> <20070919164220.GJ32520@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Valerie Clement <valerie.clement@bull.net>,
	linux-ext4@vger.kernel.org, cmm@us.ibm.com, kalpak@clusterfs.com,
	girish@clusterfs.com
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:39400 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786AbXISTS2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Sep 2007 15:18:28 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l8JJIPF8005780
	for <linux-ext4@vger.kernel.org>; Wed, 19 Sep 2007 15:18:25 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l8JJIPsf529084
	for <linux-ext4@vger.kernel.org>; Wed, 19 Sep 2007 15:18:25 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l8JJIP35009898
	for <linux-ext4@vger.kernel.org>; Wed, 19 Sep 2007 15:18:25 -0400
In-Reply-To: <20070919164220.GJ32520@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andreas Dilger wrote:
> On Sep 19, 2007  14:06 +0200, Valerie Clement wrote:
>   
>> I ran some tests with the uninit_groups feature enabled and got error messages
>> when running e2fsck on my ext4 partition. e2fsck complains of an "invalid 
>> unused inodes count" in some group descriptors.
>> These errors occur when checking groups which have only one inode in use. The 
>> "free inodes" count has been decremented by one in these groups but not the 
>> "unused inodes" count.
>>
>> Index: linux-2.6.23-rc6/fs/ext4/ialloc.c
>> ===================================================================
>> --- linux-2.6.23-rc6.orig/fs/ext4/ialloc.c	2007-09-19 11:31:01.000000000 +0200
>> +++ linux-2.6.23-rc6/fs/ext4/ialloc.c	2007-09-19 11:31:41.000000000 +0200
>> @@ -633,13 +633,10 @@ got:
>>  	/* If we didn't allocate from within the initialized part of the inode
>>  	 * table then we need to initialize up to this inode. */
>>  	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_GDT_CSUM)) {
>> -		if (gdp->bg_flags & cpu_to_le16(EXT4_BG_INODE_UNINIT)) {
>> +		if (gdp->bg_flags & cpu_to_le16(EXT4_BG_INODE_UNINIT))
>>  			gdp->bg_flags &= cpu_to_le16(~EXT4_BG_INODE_UNINIT);
>> -			free = EXT4_INODES_PER_GROUP(sb);
>> -		} else {
>> -			free = EXT4_INODES_PER_GROUP(sb) -
>> +		free = EXT4_INODES_PER_GROUP(sb) -
>>  				le16_to_cpu(gdp->bg_itable_unused);
>> -		}
>>     
>
> Hmm, this is indeed incorrect, but I'm not sure solution is the right one.
> I guess in our testing we ran it for a long time and must have created
> more than a single inode per group...
>
> What about the following instead?  I think the assumption in the original
> code is that "it's a new group, all the inodes are free", but that is not
> correct - we want to make NONE of the inodes free initially so that
> bt_itable_unused is recalculated below:
>
> 		if (gdp->bg_flags & cpu_to_le16(EXT4_BG_INODE_UNINIT)) {
>  			gdp->bg_flags &= cpu_to_le16(~EXT4_BG_INODE_UNINIT);
> -			free = EXT4_INODES_PER_GROUP(sb);
> +			free = 0;
> 		} else {
> 			free = EXT4_INODES_PER_GROUP(sb) -
>  				le16_to_cpu(gdp->bg_itable_unused);
> 		}
>
> 		 if (ino > free)
>                        gdp->bg_itable_unused =
>                                 cpu_to_le16(EXT3_INODES_PER_GROUP(sb) - ino);
>
> Still a bit uneasy about off-by-one errors here though.  Is "ino" 0 or
> 1 for the first inode in the group.  We might need to have a -1 in the
> bg_itable_unused calculation still.
>   
ino is incremented right before this code, so the first inode in the 
group is represented by 1, not 0. So this fix looks good.
Aneesh has incorporated this fix and also removed the local crc16 code, 
I will be reposting his new patch to lkml.

thanks
Avantika
