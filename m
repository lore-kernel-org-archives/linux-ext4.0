From: Alexey Lyashkov <alexey.lyashkov@gmail.com>
Subject: Re: [PATCH] ext4: preload block group descriptors
Date: Tue, 28 Feb 2017 19:29:53 +0300
Message-ID: <07A374AA-EEE9-435C-816A-5CE5F53BFF4A@gmail.com>
References: <1487609153-3367-1-git-send-email-artem.blagodarenko@gmail.com>
 <20170228161956.GE5266@birch.djwong.org>
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Cc: Artem Blagodarenko <artem.blagodarenko@gmail.com>,
        linux-ext4@vger.kernel.org,
        Andrew Perepechko <andrew.perepechko@seagate.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:36100 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751451AbdB1QbE (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Feb 2017 11:31:04 -0500
Received: by mail-pg0-f68.google.com with SMTP id 25so2131461pgy.3
        for <linux-ext4@vger.kernel.org>; Tue, 28 Feb 2017 08:29:57 -0800 (PST)
In-Reply-To: <20170228161956.GE5266@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


> 28 =D1=84=D0=B5=D0=B2=D1=80. 2017 =D0=B3., =D0=B2 19:19, Darrick J. =
Wong <darrick.wong@oracle.com> =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BB(=
=D0=B0):
>=20
> On Mon, Feb 20, 2017 at 07:45:53PM +0300, Artem Blagodarenko wrote:
>> From: Andrew Perepechko <andrew.perepechko@seagate.com>
>>=20
>> With enabled meta_bg option block group descriptors
>> reading IO is not sequential and requires optimization.
>>=20
>> Signed-off-by: Andrew Perepechko <andrew.perepechko@seagate.com>
>> ---
>> fs/ext4/super.c | 6 ++++++
>> 1 file changed, 6 insertions(+)
>>=20
>> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
>> index a673558..0e52c91 100644
>> --- a/fs/ext4/super.c
>> +++ b/fs/ext4/super.c
>> @@ -3879,6 +3879,12 @@ static int ext4_fill_super(struct super_block =
*sb, void *data, int silent)
>>=20
>> 	bgl_lock_init(sbi->s_blockgroup_lock);
>>=20
>> +	/* Pre-read the descriptors into the buffer cache */
>> +	for (i =3D 0; i < db_count; i++) {
>> +		block =3D descriptor_loc(sb, logical_sb_block, i);
>> +		sb_breadahead(sb, block);
>> +	}
>=20
> Why does the libext2fs patch start readahead only on the meta bgs
> whereas this patch starts it for all of them?  I suppose it's just as
> well that the kernel prefetches all of them, but I was curious. :)
>=20
Just because a simplify code.=20
libext2fs makes read a first gd porting via single read call, it fast.
while just meta_bg generate a random io load.
while a kernel part just a copy/paste a second loop :) Artem have a =
modified version for this patch,
when sb_bread_unmovable moved into ext4_check_descriptors to have chance =
increase window between read-ahead call and access to the buffer.
What about such change?


> --D
>=20
>> +
>> 	for (i =3D 0; i < db_count; i++) {
>> 		block =3D descriptor_loc(sb, logical_sb_block, i);
>> 		sbi->s_group_desc[i] =3D sb_bread_unmovable(sb, block);
>> --=20
>> 1.8.3.1
