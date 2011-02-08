From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 0/5] mballoc: trivial code cleanup
Date: Tue, 8 Feb 2011 10:54:05 +0200
Message-ID: <AANLkTinbE9tmtfQKXuVXL0m_O6==yWOf3VxpVHwGaP0H@mail.gmail.com>
References: <4D4E294E.4080507@coly.li>
	<AANLkTimT3i1oOSh02oTtvN_OmHcYwhNOABLV4cT7VV5p@mail.gmail.com>
	<20110207174125.GB3457@thunk.org>
	<AANLkTimOaQSdJa9aXEs_UM0pAO92S0_zGT5w7kU33etk@mail.gmail.com>
	<20110207222450.GF3457@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: i@coly.li, Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:63602 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491Ab1BHIyH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Feb 2011 03:54:07 -0500
Received: by qwa26 with SMTP id 26so3958277qwa.19
        for <linux-ext4@vger.kernel.org>; Tue, 08 Feb 2011 00:54:05 -0800 (PST)
In-Reply-To: <20110207222450.GF3457@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 8, 2011 at 12:24 AM, Ted Ts'o <tytso@mit.edu> wrote:
> On Mon, Feb 07, 2011 at 10:59:54PM +0200, Amir Goldstein wrote:
>> it says alloc_sem protects against lazy init of adjacent groups
>> and says nothing about protecting block group specific data structur=
es...
>>
>> what am I missing???
>
> You're missing ext4_mb_load_buddy(), which takes grp->alloc_sem, and
> which is released by ext4_mb_unload_buddy(). =A0No, it's not the most
> obvious code in the world...
>

OK Ted, you leave me no choice... I need to paste the code of mb_load_b=
uddy():

1157        e4b->alloc_semp =3D &grp->alloc_sem;
1158
1159        /* Take the read lock on the group alloc
1160         * sem. This would make sure a parallel
1161         * ext4_mb_init_group happening on other
1162         * groups mapped by the page is blocked
1163         * till we are done with allocation
1164         */
1165repeat_load_buddy:
1166        down_read(e4b->alloc_semp);
1167
1168        if (unlikely(EXT4_MB_GRP_NEED_INIT(grp))) {
1169                /* we need to check for group need init flag
1170                 * with alloc_semp held so that we can be sure
1171                 * that new blocks didn't get added to the group
1172                 * when we are loading the buddy cache
1173                 */
1174                up_read(e4b->alloc_semp);
1175                /*
1176                 * we need full data about the group
1177                 * to make a good selection
1178                 */
1179                ret =3D ext4_mb_init_group(sb, group);
1180                if (ret)
1181                        return ret;
1182                goto repeat_load_buddy;
1183        }
1184

ext4_mb_load_buddy() *only* takes down_read(grp->alloc_sem),
except for the first time after mount, in which ext4_mb_init_group() ta=
kes
down_write(grp->alloc_sem), releases it, and then repeat_load_buddy lab=
el
will re-take down_read(grp->alloc_sem).

Essentially, this means that after time Ti(group), all users take only =
read
access to grp->alloc_sem, which is kind of futile...

Your statement that alloc_sem is needed certainly makes sense, but I ju=
st don't
see it in the code.
As un-obvious as the code may be, you cannot protect data structures
without anyone taking write access to the semaphore on allocation routi=
nes.
Also, I believe that buddy data structures are modified in
ext4_mb_generate_buddy()
under the protection of ext4_lock_group().

So at the risk of having to buy you a beer on LFS I will repeat my
nagging question:
What am I missing???

Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
