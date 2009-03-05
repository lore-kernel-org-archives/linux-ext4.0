From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] fix ext4_free_inode vs. ext4_claim_inode race
Date: Wed, 04 Mar 2009 22:21:59 -0600
Message-ID: <49AF5367.5040006@redhat.com>
References: <49AE05D1.9050607@redhat.com> <49AF0AA0.3080506@redhat.com> <20090305040340.GC17949@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:51313 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752677AbZCEEWF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Mar 2009 23:22:05 -0500
In-Reply-To: <20090305040340.GC17949@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> On Wed, Mar 04, 2009 at 05:11:28PM -0600, Eric Sandeen wrote:
>> Eric Sandeen wrote:
>>
>> Index: linux-2.6/fs/ext4/ialloc.c
>> ===================================================================
>> --- linux-2.6.orig/fs/ext4/ialloc.c
>> +++ linux-2.6/fs/ext4/ialloc.c
>> @@ -609,26 +609,33 @@ static int ext4_claim_inode(struct super
>>  			struct buffer_head *inode_bitmap_bh,
>>  			unsigned long ino, ext4_group_t group, int mode)
>>  {
>> -	int free = 0, retval = 0, count;
>> +	int free = 0, bitset, count;
>>  	struct ext4_sb_info *sbi = EXT4_SB(sb);
>>  	struct ext4_group_desc *gdp = ext4_get_group_desc(sb, group, NULL);
>>
>> -	spin_lock(sb_bgl_lock(sbi, group));
>> -	if (ext4_set_bit(ino, inode_bitmap_bh->b_data)) {
>> -		/* not a free inode */
>> -		retval = 1;
>> -		goto err_ret;
>> +	/* if uninit, protect against ext4_read_inode_bitmap initialization */
>> +	bitset = -1;
>> +	if (gdp->bg_flags & cpu_to_le16(EXT4_BG_INODE_UNINIT)) {
>> +		spin_lock(sb_bgl_lock(sbi, group));
>> +		if (gdp->bg_flags & cpu_to_le16(EXT4_BG_INODE_UNINIT))
>> +			bitset = ext4_set_bit(ino, inode_bitmap_bh->b_data);
>> +		spin_unlock(sb_bgl_lock(sbi, group));
>>  	}
> 
> 
> That won't work. We need set the bit and clear the  INODE_UNINIT flag
> by holding the spin_lock. In ext4_read_inode_bitmap we check the
> INODE_UNINIT flag and re-init the inode bitmap. So we may end up 
> re-initing the bitmap if we don't clear the INODE_UNINIT flag holding
> the spin lock

Yeah, I guess maybe that's the same old race we had to start with isn't it.

Remind me again why we don't just clear UNINIT when we read in the
bitmap in and ... init it?

-Eric
