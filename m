From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: [PATCH][RFC] ext4: avoid taking down_read(&grp->alloc_sem)
Date: Mon, 14 Feb 2011 20:18:11 +0200
Message-ID: <AANLkTimxw0e37XbwW8PwXgLEyCEC2zH_wThCjBpbsEhm@mail.gmail.com>
References: <AANLkTimUmo5v14oKodaBKFtZPEHHuR9kZS5OSVtEFj2c@mail.gmail.com>
	<AANLkTimgCcW0fQzQ3W=vhkTSWt=0=xPoaBucrM=mfHXG@mail.gmail.com>
	<2D97EC87-86D8-41D9-8779-BB4A48E60E89@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:57957 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab1BNSSN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Feb 2011 13:18:13 -0500
Received: by qwa26 with SMTP id 26so3332618qwa.19
        for <linux-ext4@vger.kernel.org>; Mon, 14 Feb 2011 10:18:12 -0800 (PST)
In-Reply-To: <2D97EC87-86D8-41D9-8779-BB4A48E60E89@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 14, 2011 at 6:30 PM, Andreas Dilger <adilger@dilger.ca> wro=
te:
> On 2011-02-14, at 0:52, "Amir G." <amir73il@users.sourceforge.net> wr=
ote:
>>> @@ -1160,7 +1160,15 @@ ext4_mb_load_buddy(struct super_block *sb,
>>>
>>> + =A0 =A0 =A0 /*
>>> + =A0 =A0 =A0 =A0* We only need to take the read lock if other grou=
ps share the buddy
>>> + =A0 =A0 =A0 =A0* page with this group or if blocks may be added t=
o this (last) group
>>> + =A0 =A0 =A0 =A0* by ext4_group_extend().
>>> + =A0 =A0 =A0 =A0*/
>>> + =A0 =A0 =A0 if (blocks_per_page > 2 || group =3D=3D sbi->s_groups=
_count - 1)
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 e4b->alloc_semp =3D &grp->alloc_sem;
>
> No comment on whether this change is safe or not, but shouldn't this =
check be:
>
> =A0 =A0 =A0 =A0if (blocks_per_page > 1 ||
>

No, it should be groups_per_page > 1, as Aneesh suggested,
which translates to blocks_per_group > 2, but this is obviously not
clear from the code...
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
