From: Valerie Clement <valerie.clement@bull.net>
Subject: Re: [RFC][PATCH 1/12] new ext4 group desc struct in e2fsprogs
Date: Tue, 12 Jun 2007 13:44:22 +0200
Message-ID: <466E8716.7080101@bull.net>
References: <466D7B60.3050108@bull.net> <20070611232120.GF5181@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:56845 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbXFLLnC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 Jun 2007 07:43:02 -0400
In-Reply-To: <20070611232120.GF5181@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andreas Dilger wrote:
> On Jun 11, 2007  18:42 +0200, Valerie Clement wrote:
>> @@ -213,7 +213,11 @@ struct struct_ext2_filsys {
>>  	int				fragsize;
>>  	dgrp_t				group_desc_count;
>>  	unsigned long			desc_blocks;
>> +#ifdef _EXT4FS_
>> +	struct ext4_group_desc *	group_desc;
>> +#else
>>  	struct ext2_group_desc *	group_desc;
>> +#endif
>=20
> The way similar changes were incorporated into e2fsprogs in the past
> (e.g. large inode support) is to pass an ext2_group_desc around and
> in places where access to the "large" part of the struct are needed
> this is typecast and conditional upon the appropriate superblock fiel=
d
> or feature, as it is in the kernel.  This also avoids the need to cha=
nge
> the parameter everywhere.
>=20
> This is important because even "ext4" filesystems may only have 32-by=
te
> group descriptors if they are formatted as ext3 and upgraded.
>=20
> For large inodes, this is using "s_inode_size", and for the group
> descriptor it should use "s_desc_size" and INCOMPAT_64BIT.
>=20

Yes, I see the problem. I'll make the changes in this way.
Thanks,
   Val=E9rie
