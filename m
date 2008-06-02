From: Shen Feng <shen@cn.fujitsu.com>
Subject: Re: [PATCH] ext4: Fix use of uninitialized data
Date: Mon, 02 Jun 2008 18:02:21 +0800
Message-ID: <4843C52D.20400@cn.fujitsu.com>
References: <1210790832-20680-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1210790832-20680-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20080602000842.GA24339@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org,
	alex@clusterfs.com, adilger@sun.com
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:54431 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752375AbYFBKFB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Jun 2008 06:05:01 -0400
In-Reply-To: <20080602000842.GA24339@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



Theodore Tso Wrote:
> On Thu, May 15, 2008 at 12:17:11AM +0530, Aneesh Kumar K.V wrote:
>> @@ -3134,8 +3135,7 @@ static void ext4_mb_use_inode_pa(struct ext4_allocation_context *ac,
>>  static void ext4_mb_use_group_pa(struct ext4_allocation_context *ac,
>>  				struct ext4_prealloc_space *pa)
>>  {
>> -	unsigned len = ac->ac_o_ex.fe_len;
>> -
>> +	unsigned int len = ac->ac_o_ex.fe_len;
>>  	ext4_get_group_no_and_offset(ac->ac_sb, pa->pa_pstart,
>>  					&ac->ac_b_ex.fe_group,
>>  					&ac->ac_b_ex.fe_start);
>> -- 
> 
> This change had nothing to do with fixing the use of unitialized data,
> but when I started looking more closely, it raised a potential signed
> vs. unsigned issue: ac_o_ex is a struct ext4_free_extent, and fe_len
> is an int.
> 
> So here we are assigning an int to an unsigned int.  Later, len is
> assigned to ac_b_ex.len, which means assigning an unsigned int to an
> int.  In other places, fe_len (an int) is compared against pa_free
> (which is an unsigned short), and fe_len gets assined to pa_free, once
> again mixing signed and unsigned.
> 
> Can someone who is really familiar with this code check this out?  I
> think the following pseudo-patch to mballoc.h might be in order:
> 
>  struct ext4_free_extent {
>  	ext4_lblk_t fe_logical;
>  	ext4_grpblk_t fe_start;
>  	ext4_group_t fe_group;
> -	int fe_len;
> +	unsigned int fe_len;
>  };
> 

I'm studying the ext4 code these days.
The data types always confuse me.

The length of a ext4_extent ee_len is define as unsigned short.

struct ext4_extent {
	__le32	ee_block;	/* first logical block extent covers */
	__le16	ee_len;		/* number of blocks covered by extent */
	__le16	ee_start_hi;	/* high 16 bits of physical block */
	__le32	ee_start_lo;	/* low 32 bits of physical block */
};

So I think fe_len should also be defined as unsigned short.
Is that right?

-Shen Feng
