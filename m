From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: Files full of zeros with coreutils-8.11 and xfs (FIEMAP related?)
Date: Thu, 5 May 2011 19:47:29 +0800
Message-ID: <BANLkTikM4kekeaa2EQTtP02ondKL1X3+3g@mail.gmail.com>
References: <20110414102608.GA1678@x4.trippels.de>
	<20110414120635.GB1678@x4.trippels.de>
	<20110414140222.GB1679@x4.trippels.de>
	<4DA70BD3.1070409@draigBrady.com>
	<4DA717B2.3020305@sandeen.net>
	<4DA7182B.8050409@draigBrady.com>
	<4DA71920.9@sandeen.net>
	<BANLkTikW72q_2pEoVTmag8+gMsCcZ-fR8w@mail.gmail.com>
	<BANLkTimoLeWMJgNFGW+zdeUeJyZ-_+8fMQ@mail.gmail.com>
	<4DC28A00.7010309@draigBrady.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>,
	linux-ext4@vger.kernel.org, coreutils@gnu.org,
	Markus Trippelsdorf <markus@trippelsdorf.de>
To: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigbrady.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:53309 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947Ab1EELra convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 May 2011 07:47:30 -0400
Received: by vxi39 with SMTP id 39so2204166vxi.19
        for <linux-ext4@vger.kernel.org>; Thu, 05 May 2011 04:47:29 -0700 (PDT)
In-Reply-To: <4DC28A00.7010309@draigBrady.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2011/5/5 P=E1draig Brady <P@draigbrady.com>:
> On 14/04/11 17:10, Yongqiang Yang wrote:
>> Hi,
>>
>> I am off my working computer. =A0Maybe below fix could fix the probl=
em.
>>
>> fs/ext4/extent.c
>> static int ext4_ext_walk_space(struct inode *inode, ext4_lblk_t bloc=
k,
>> 1877 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (block >=3D le32_to_c=
pu(ex->ee_block)) {
>> 1878 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
>> 1879 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* some part =
of requested space is covered
>> 1880 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* by found e=
xtent
>> 1881 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> 1882 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 start =3D block=
;
>> 1883 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 end =3D le32_to=
_cpu(ex->ee_block)
>> 1884 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 + ext4_ext_get_actual_len(ex);
>> 1885 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (block + num=
 < end)
>> 1886 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 end =3D block + num;
>> =A0 =A0 =A0 =A0+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (=
!ext4_ext_is_uninitialized(ex))
>> 1887 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 exists =3D 1;
>> 1888 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
>> 1889 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 BUG();
>> 1890 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>
> Hi,
>
> To follow up on the above. =A0I'm under the impression
> that ext4 is expected to return extents for what
> is written, irrespective of whether it's reached the
> disk or not. I.E. the preallocation case where this fails
No.  It just returns extent info now - allocated extents and delayed
extents.  In the preallocation case, it returns unwritten extents.
And the code above does not work.

> was an oversite, for which the above might fix.
>
> So is the above summary correct, and has there
> been any more thoughts on a fix?
>
> cheers,
> P=E1draig.
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
