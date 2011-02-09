From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 0/5] mballoc: trivial code cleanup
Date: Wed, 9 Feb 2011 11:09:32 +0200
Message-ID: <AANLkTin0tSCT8p26MQhi0kx6V-B9vYiZ=ryog6D980nX@mail.gmail.com>
References: <4D4E294E.4080507@coly.li>
	<AANLkTimT3i1oOSh02oTtvN_OmHcYwhNOABLV4cT7VV5p@mail.gmail.com>
	<20110207174125.GB3457@thunk.org>
	<AANLkTimOaQSdJa9aXEs_UM0pAO92S0_zGT5w7kU33etk@mail.gmail.com>
	<20110207222450.GF3457@thunk.org>
	<AANLkTinbE9tmtfQKXuVXL0m_O6==yWOf3VxpVHwGaP0H@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: i@coly.li, Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:55306 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189Ab1BIJJe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Feb 2011 04:09:34 -0500
Received: by qyj19 with SMTP id 19so1190066qyj.19
        for <linux-ext4@vger.kernel.org>; Wed, 09 Feb 2011 01:09:33 -0800 (PST)
In-Reply-To: <AANLkTinbE9tmtfQKXuVXL0m_O6==yWOf3VxpVHwGaP0H@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 8, 2011 at 10:54 AM, Amir Goldstein <amir73il@gmail.com> wr=
ote:
> On Tue, Feb 8, 2011 at 12:24 AM, Ted Ts'o <tytso@mit.edu> wrote:
>> On Mon, Feb 07, 2011 at 10:59:54PM +0200, Amir Goldstein wrote:
>>> it says alloc_sem protects against lazy init of adjacent groups
>>> and says nothing about protecting block group specific data structu=
res...
>>>
>>> what am I missing???
>>
>> You're missing ext4_mb_load_buddy(), which takes grp->alloc_sem, and
>> which is released by ext4_mb_unload_buddy(). =A0No, it's not the mos=
t
>> obvious code in the world...
>>
>
> OK Ted, you leave me no choice... I need to paste the code of mb_load=
_buddy():
>
> 1157 =A0 =A0 =A0 =A0e4b->alloc_semp =3D &grp->alloc_sem;
> 1158
> 1159 =A0 =A0 =A0 =A0/* Take the read lock on the group alloc
> 1160 =A0 =A0 =A0 =A0 * sem. This would make sure a parallel
> 1161 =A0 =A0 =A0 =A0 * ext4_mb_init_group happening on other
> 1162 =A0 =A0 =A0 =A0 * groups mapped by the page is blocked
> 1163 =A0 =A0 =A0 =A0 * till we are done with allocation
> 1164 =A0 =A0 =A0 =A0 */
> 1165repeat_load_buddy:
> 1166 =A0 =A0 =A0 =A0down_read(e4b->alloc_semp);
> 1167
> 1168 =A0 =A0 =A0 =A0if (unlikely(EXT4_MB_GRP_NEED_INIT(grp))) {
> 1169 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* we need to check for group nee=
d init flag
> 1170 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * with alloc_semp held so that w=
e can be sure
> 1171 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * that new blocks didn't get add=
ed to the group
> 1172 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * when we are loading the buddy =
cache
> 1173 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
> 1174 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0up_read(e4b->alloc_semp);
> 1175 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/*
> 1176 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * we need full data about the gr=
oup
> 1177 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * to make a good selection
> 1178 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
> 1179 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D ext4_mb_init_group(sb, gr=
oup);
> 1180 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (ret)
> 1181 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return ret;
> 1182 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto repeat_load_buddy;
> 1183 =A0 =A0 =A0 =A0}
> 1184
>
> ext4_mb_load_buddy() *only* takes down_read(grp->alloc_sem),
> except for the first time after mount, in which ext4_mb_init_group() =
takes
> down_write(grp->alloc_sem), releases it, and then repeat_load_buddy l=
abel
> will re-take down_read(grp->alloc_sem).
>
> Essentially, this means that after time Ti(group), all users take onl=
y read
> access to grp->alloc_sem, which is kind of futile...
>
> Your statement that alloc_sem is needed certainly makes sense, but I =
just don't
> see it in the code.
> As un-obvious as the code may be, you cannot protect data structures
> without anyone taking write access to the semaphore on allocation rou=
tines.
> Also, I believe that buddy data structures are modified in
> ext4_mb_generate_buddy()
> under the protection of ext4_lock_group().
>
> So at the risk of having to buy you a beer on LFS I will repeat my
> nagging question:
> What am I missing???
>

I found out what I was missing (it's in the comment in line 1169 above)=
=2E
I wrongly assumed the EXT4_GROUP_INFO_NEED_INIT_BIT is set only
once in a lifetime of an ext4_group_info, but I was wrong. It may also =
be set
when adding blocks to an existing group from ext4_group_extend().

Still, I think that the use cases in which down_read(alloc_sem) is need=
ed are
very unlikely() and can be covered with the following check:

=A0   if (blocks_per_page > 2 || group =3D=3D sbi->s_groups_count - 1)
=A0 =A0 =A0   /* Synchronize init of adjacent group and adding of block=
s to
last group */
=A0 =A0 =A0   e4b->alloc_semp =3D &grp->alloc_sem;
=A0   else
=A0 =A0 =A0   e4b->alloc_semp =3D NULL;

I will post a patch for review.

Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
