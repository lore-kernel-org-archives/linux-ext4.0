From: Nikola Pajkovsky <nikola.pajkovsky@gooddata.com>
Subject: Re: xfstests generic/130 hang with non-4k block size ext4 on 4.7-rc1 kernel
Date: Thu, 16 Jun 2016 16:42:58 +0200
Message-ID: <8737odw5xp.fsf@gooddata.com>
References: <20160601165800.GI10350@eguan.usersys.redhat.com>
	<20160602085840.GH19636@quack2.suse.cz>
	<20160602121750.GC32574@quack2.suse.cz>
	<20160603101612.GJ10350@eguan.usersys.redhat.com>
	<20160603115844.GB2470@quack2.suse.cz>
	<20160608125631.GA19589@quack2.suse.cz>
	<pan$6abef$45fa540$7a7a0c36$ef55c356@applied-asynchrony.com>
	<87oa7a6d1q.fsf@gooddata.com> <20160609150405.GB19882@quack2.suse.cz>
	<87oa79h9on.fsf@gooddata.com> <20160616132620.GA2106@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Holger =?utf-8?Q?Hoffst=C3=A4tte?=
	<holger@applied-asynchrony.com>, linux-ext4@vger.kernel.org,
	Jan Kara <jack@suse.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:35815 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754038AbcFPOnC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Jun 2016 10:43:02 -0400
Received: by mail-wm0-f46.google.com with SMTP id v199so195239302wmv.0
        for <linux-ext4@vger.kernel.org>; Thu, 16 Jun 2016 07:43:01 -0700 (PDT)
In-Reply-To: <20160616132620.GA2106@quack2.suse.cz> (Jan Kara's message of
	"Thu, 16 Jun 2016 15:26:20 +0200")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jan Kara <jack@suse.cz> writes:

> On Fri 10-06-16 07:52:56, Nikola Pajkovsky wrote:
>> Jan Kara <jack@suse.cz> writes:
>> > On Thu 09-06-16 09:23:29, Nikola Pajkovsky wrote:
>> >> Holger Hoffst=C3=A4tte <holger@applied-asynchrony.com> writes:
>> >>=20
>> >> > On Wed, 08 Jun 2016 14:56:31 +0200, Jan Kara wrote:
>> >> > (snip)
>> >> >> Attached patch fixes the issue for me. I'll submit it once a f=
ull xfstests
>> >> >> run finishes for it (which may take a while as our server room=
 is currently
>> >> >> moving to a different place).
>> >> >>=20
>> >> >> 								Honza
>> >> >> --=20
>> >> >> Jan Kara <jack@suse.com>
>> >> >> SUSE Labs, CR
>> >> >> From 3a120841a5d9a6c42bf196389467e9e663cf1cf8 Mon Sep 17 00:00=
:00 2001
>> >> >> From: Jan Kara <jack@suse.cz>
>> >> >> Date: Wed, 8 Jun 2016 10:01:45 +0200
>> >> >> Subject: [PATCH] ext4: Fix deadlock during page writeback
>> >> >>=20
>> >> >> Commit 06bd3c36a733 (ext4: fix data exposure after a crash) un=
covered a
>> >> >> deadlock in ext4_writepages() which was previously much harder=
 to hit.
>> >> >> After this commit xfstest generic/130 reproduces the deadlock =
on small
>> >> >> filesystems.
>> >> >
>> >> > Since you marked this for -stable, just a heads-up that the pre=
vious patch
>> >> > for the data exposure was rejected from -stable (see [1]) becau=
se it
>> >> > has the mismatching "!IS_NOQUOTA(inode) &&" line, which didn't =
exist
>> >> > until 4.6. I removed it locally but Greg probably wants an offi=
cial patch.
>> >> >
>> >> > So both this and the previous patch need to be submitted.
>> >> >
>> >> > [1] http://permalink.gmane.org/gmane.linux.kernel.stable/18074{=
4,5,6}
>> >>=20
>> >> I'm just wondering if the Jan's patch is not related to blocked
>> >> processes in following trace. It very hard to hit it and I don't =
have
>> >> any reproducer.
>> >
>> > This looks like a different issue. Does the machine recover itself=
 or is it
>> > a hard hang and you have to press a reset button?
>>=20
>> The machine is bit bigger than I have pretend. It's 18 vcpu with 160=
 GB
>> ram and machine has dedicated mount point only for PostgreSQL data.
>>=20
>> Nevertheless, I was able always to ssh to the machine, so machine it=
self
>> was not in hard hang and ext4 mostly gets recover by itself (it took
>> 30min). But I have seen situation, were every process who 'touch' th=
e ext4
>> goes immediately to D state and does not recover even after hour.
>
> If such situation happens, can you run 'echo w >/proc/sysrq-trigger' =
to
> dump stuck processes and also run 'iostat -x 1' for a while to see ho=
w much
> IO is happening in the system? That should tell us more.


Link to 'echo w >/proc/sysrq-trigger' is here, because it's bit bigger
to mail it.

   http://expirebox.com/download/68c26e396feb8c9abb0485f857ccea3a.html

I was running iotop and there was traffic roughly ~20 KB/s write.

What was bit more interesting, was looking at

   cat /proc/vmstat | egrep "nr_dirty|nr_writeback"

nr_drity had around 240 and was slowly counting up, but nr_writeback ha=
d
~8800 and was stuck for 120s.

--=20
Nikola
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
