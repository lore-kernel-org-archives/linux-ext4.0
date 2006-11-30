From: Valerie Clement <valerie.clement@bull.net>
Subject: Re: [RFC][PATCH 4/4] BIG_BG: block group descriptor modifications
Date: Thu, 30 Nov 2006 17:04:31 +0100
Message-ID: <456F010F.4020704@bull.net>
References: <1164386918.17961.79.camel@ckrm> <20061125092346.GA4241@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:53944 "EHLO
	ecfrec.frec.bull.fr") by vger.kernel.org with ESMTP id S967836AbWK3QGb
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 30 Nov 2006 11:06:31 -0500
To: Andreas Dilger <adilger@clusterfs.com>
In-Reply-To: <20061125092346.GA4241@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andreas Dilger wrote:
> On Nov 24, 2006  17:48 +0100, Valerie Clement wrote:
>> @@ -133,6 +133,9 @@ struct ext4_group_desc
>>  	__le32	bg_block_bitmap_hi;	/* Blocks bitmap block MSB */
>>  	__le32	bg_inode_bitmap_hi;	/* Inodes bitmap block MSB */
>>  	__le32	bg_inode_table_hi;	/* Inodes table block MSB */
>> +	__le16	bg_free_blocks_count_hi;	/* Free blocks count MSB */
>> +	__le16	bg_free_inodes_count_hi;	/* Free inodes count MSB */
>> +	__le16	bg_used_dirs_count_hi;	/* Directories count MSB */
>>  };
>=20
> Does the ext4 code already avoid using "sizeof(struct ext4_group_desc=
)"
> or "sizeof(*gdp)" everywhere?  Otherwise this is very dangerous.
Currently, the code doesn't use sizeof of the structure or of a group=20
descriptor, but do you mean that adding padding to the structure is bet=
ter?

>=20
> Also note that the on-disk layout of this struct in e2fsprogs is a bi=
t
> incorrect - it has the above 3 __u16, but then immediately __u32 bg_r=
eserved
> so those fields are padded incorrectly.  I think it isn't a fatal pro=
blem,
> just something to be aware of and fix.
OK.

>=20
>> +#define EXT4_READ_SPLIT_LE32(__sb, __field)	\
>> +	((__u32)le16_to_cpu(__field) +		\
>> +	 (EXT4_HAS_INCOMPAT_FEATURE((__sb), EXT4_FEATURE_INCOMPAT_64BIT) ?=
 \
>> +	 (__u32)le16_to_cpu(__field##_hi) << 16 : 0))
>=20
> Is it better to make this INCOMPAT_64BIT or s_desc_size? Does INCOMPA=
T_64BIT
> always imply s_desc_size > 32?  Hmm, I guess it does, or we have no p=
lace to
> store the _hi part of the block addresses for a group.
I prefer using INCOMPAT_64BIT rather than s_desc_size.
Thank you Andreas to point that out, I missed to update my e2fsprogs=20
version to initialize s_desc_size with the right value in some cases.

   Val=E9rie
