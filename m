From: Valerie Clement <valerie.clement@bull.net>
Subject: Re: Problems with mballoc and uninit_groups option
Date: Mon, 14 Jan 2008 15:05:41 +0100
Message-ID: <478B6C35.3060606@bull.net>
References: <47877758.1070603@bull.net> <20080111154552.GA7339@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:48686 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbYANOEO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Jan 2008 09:04:14 -0500
In-Reply-To: <20080111154552.GA7339@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> On Fri, Jan 11, 2008 at 03:04:08PM +0100, Valerie Clement wrote:
>> Hi,
>>
>> I've got problems with mballoc when I create the ext4 filesystem wit=
h =20
>> the "uninit_groups" option enabled.
>>
>> First, I do a single test on a filesystem created without the =20
>> "uninit_groups" option and mounted with the defaults option:
>>   dd if=3D/dev/zero of=3D/mnt/test/foo bs=3D1M count=3D1024
>>
>> In this case, the file blocks are allocated in the groups 4, 5, 6, 7=
, 8, =20
>> 9, 10.
>>
>> When the filesystem is created with the "uninit_groups" option enabl=
ed =20
>> and mounted with the defaults option, I do the same dd command.
>>
>> In this case, the file blocks are allocated in the groups 5, 7, 9, 2=
5, =20
>> 27, 49, 81. It seems that the blocks could be allocated only in the =
=20
>> already initialized groups.
>>
>=20
> That is because we skip the uninitialized group in ext4_mb_good_group=
=2E
> I guess we are trying criteria 0 allocation and we skip uninit group =
for
> criteria 0 . You can tune by setting higher value for
> /proc/fs/ext4/partition/orders2_req. Setting it to a high value would
> skip criteria 0 allocation for small requests.

Hi Aneesh,
thanks for your answer but I'm not sure your solution is the right one=20
to fix the problem.

I added traces in the mballoc code and found perhaps something=20
incorrect: while running the dd command, the function=20
ext4_mb_init_cache() is called, which calls ext4_init_block_bitmap() fo=
r=20
an uninitialized group. But the flag EXT4_BG_BLOCK_UNINIT is not reset=20
after. Shouldn't it be reset here?

> I guess you are using delayed allocation ?
Yes

   Val=E9rie
