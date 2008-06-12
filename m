From: Jean-Pierre Dion <jean-pierre.dion@bull.net>
Subject: Re: [PATCH] ext4: fix online resize group descriptors corruption
Date: Thu, 12 Jun 2008 16:56:55 +0200
Message-ID: <48513937.5000708@bull.net>
References: <1213263754.6549.45.camel@localhost> <20080612105945.GB3726@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: frederic.bohe@ext.bull.net, tytso@mit.edu,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:49231 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbYFLO6K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Jun 2008 10:58:10 -0400
In-Reply-To: <20080612105945.GB3726@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Andreas,

thank you for this review of Fr=C3=A9d=C3=A9ric's patch
and your comments that help.

=46r=C3=A9d=C3=A9ric just joined our team a few days ago and
this kind of help is very usefull.

=46r=C3=A9d=C3=A9ric has not a great experience in Linux
but he has a strong one in embedded systems
and telecoms. Correct me where I am wrong Fr=C3=A9d=C3=A9ric. ;-)


jean-pierre


Andreas Dilger a =C3=A9crit :
> On Jun 12, 2008  11:42 +0200, Fr=EF=BF=BDd=EF=BF=BDric Boh=EF=BF=BD w=
rote:
>  =20
>> From: Frederic Bohe <frederic.bohe@bull.net>
>>
>> This is the patch for the group descriptor table corruption during
>> online resize pointed out by Theodore Tso.
>> The issue was due to the ext4 group descriptor which can be either
>> 32 or 64 bytes long.
>> Only the 64 bytes structure was taken into account.
>>
>> diff -rup a/fs/ext4/resize.c b/fs/ext4/resize.c
>> --- a/fs/ext4/resize.c
>> +++ b/fs/ext4/resize.c
>> @@ -855,7 +855,8 @@ int ext4_group_add(struct super_block *s
>>  	 */
>> =20
>>  	/* Update group descriptor block for new group */
>> -	gdp =3D (struct ext4_group_desc *)primary->b_data + gdb_off;
>> +	gdp =3D (struct ext4_group_desc *)(
>> +	       (__u8 *)primary->b_data + gdb_off * EXT4_DESC_SIZE(sb));
>>    =20
>
> Normally pointer arithmetic is done by casting to (char *)...
> Otherwise, patch looks sensible, though it could be reformatted to=20
> match the normal coding style a bit better:
>
> 	gdp =3D (struct ext4_group_desc *)((char *)primary->b_data +
> 					 gdb_off * EXT4_DESC_SIZE(sb));
>
> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>  =20

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
