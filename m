From: Jan Kara <jack@suse.cz>
Subject: Re: xfstests generic/130 hang with non-4k block size ext4 on 4.7-rc1
 kernel
Date: Tue, 21 Jun 2016 12:11:56 +0200
Message-ID: <20160621101156.GA6299@quack2.suse.cz>
References: <20160603115844.GB2470@quack2.suse.cz>
 <20160608125631.GA19589@quack2.suse.cz>
 <pan$6abef$45fa540$7a7a0c36$ef55c356@applied-asynchrony.com>
 <87oa7a6d1q.fsf@gooddata.com>
 <20160609150405.GB19882@quack2.suse.cz>
 <87oa79h9on.fsf@gooddata.com>
 <20160616132620.GA2106@quack2.suse.cz>
 <8737odw5xp.fsf@gooddata.com>
 <20160620113950.GD6882@quack2.suse.cz>
 <87porc3tiq.fsf@gooddata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>,
	Holger =?iso-8859-1?Q?Hoffst=E4tte?=
	<holger@applied-asynchrony.com>, linux-ext4@vger.kernel.org,
	Jan Kara <jack@suse.com>
To: Nikola Pajkovsky <nikola.pajkovsky@gooddata.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35014 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437AbcFUKXq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 21 Jun 2016 06:23:46 -0400
Content-Disposition: inline
In-Reply-To: <87porc3tiq.fsf@gooddata.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 20-06-16 14:59:57, Nikola Pajkovsky wrote:
> Jan Kara <jack@suse.cz> writes:
> > On Thu 16-06-16 16:42:58, Nikola Pajkovsky wrote:
> >> Jan Kara <jack@suse.cz> writes:
> >>=20
> >> > On Fri 10-06-16 07:52:56, Nikola Pajkovsky wrote:
> >> >> Jan Kara <jack@suse.cz> writes:
> >> >> > On Thu 09-06-16 09:23:29, Nikola Pajkovsky wrote:
> >> >> >> Holger Hoffst=E4tte <holger@applied-asynchrony.com> writes:
> >> >> >>=20
> >> >> >> > On Wed, 08 Jun 2016 14:56:31 +0200, Jan Kara wrote:
> >> >> >> > (snip)
> >> >> >> >> Attached patch fixes the issue for me. I'll submit it onc=
e a full xfstests
> >> >> >> >> run finishes for it (which may take a while as our server=
 room is currently
> >> >> >> >> moving to a different place).
> >> >> >> >>=20
> >> >> >> >> 								Honza
> >> >> >> >> --=20
> >> >> >> >> Jan Kara <jack@suse.com>
> >> >> >> >> SUSE Labs, CR
> >> >> >> >> From 3a120841a5d9a6c42bf196389467e9e663cf1cf8 Mon Sep 17 =
00:00:00 2001
> >> >> >> >> From: Jan Kara <jack@suse.cz>
> >> >> >> >> Date: Wed, 8 Jun 2016 10:01:45 +0200
> >> >> >> >> Subject: [PATCH] ext4: Fix deadlock during page writeback
> >> >> >> >>=20
> >> >> >> >> Commit 06bd3c36a733 (ext4: fix data exposure after a cras=
h) uncovered a
> >> >> >> >> deadlock in ext4_writepages() which was previously much h=
arder to hit.
> >> >> >> >> After this commit xfstest generic/130 reproduces the dead=
lock on small
> >> >> >> >> filesystems.
> >> >> >> >
> >> >> >> > Since you marked this for -stable, just a heads-up that th=
e previous patch
> >> >> >> > for the data exposure was rejected from -stable (see [1]) =
because it
> >> >> >> > has the mismatching "!IS_NOQUOTA(inode) &&" line, which di=
dn't exist
> >> >> >> > until 4.6. I removed it locally but Greg probably wants an=
 official patch.
> >> >> >> >
> >> >> >> > So both this and the previous patch need to be submitted.
> >> >> >> >
> >> >> >> > [1] http://permalink.gmane.org/gmane.linux.kernel.stable/1=
8074{4,5,6}
> >> >> >>=20
> >> >> >> I'm just wondering if the Jan's patch is not related to bloc=
ked
> >> >> >> processes in following trace. It very hard to hit it and I d=
on't have
> >> >> >> any reproducer.
> >> >> >
> >> >> > This looks like a different issue. Does the machine recover i=
tself or is it
> >> >> > a hard hang and you have to press a reset button?
> >> >>=20
> >> >> The machine is bit bigger than I have pretend. It's 18 vcpu wit=
h 160 GB
> >> >> ram and machine has dedicated mount point only for PostgreSQL d=
ata.
> >> >>=20
> >> >> Nevertheless, I was able always to ssh to the machine, so machi=
ne itself
> >> >> was not in hard hang and ext4 mostly gets recover by itself (it=
 took
> >> >> 30min). But I have seen situation, were every process who 'touc=
h' the ext4
> >> >> goes immediately to D state and does not recover even after hou=
r.
> >> >
> >> > If such situation happens, can you run 'echo w >/proc/sysrq-trig=
ger' to
> >> > dump stuck processes and also run 'iostat -x 1' for a while to s=
ee how much
> >> > IO is happening in the system? That should tell us more.
> >>=20
> >>=20
> >> Link to 'echo w >/proc/sysrq-trigger' is here, because it's bit bi=
gger
> >> to mail it.
> >>=20
> >>    http://expirebox.com/download/68c26e396feb8c9abb0485f857ccea3a.=
html
> >
> > Can you upload it again please? I've got to looking at the file onl=
y today
> > and it is already deleted. Thanks!
>=20
> http://expirebox.com/download/c010e712e55938435c446cdc01a0b523.html

OK, I had a look into the traces and JBD2 thread just waits for the buf=
fers
is has submitted for IO to complete. The rest is just blocked on that. =
=46rom
the message "INFO: task jbd2/vdc-8:4710 blocked for more than 120 secon=
ds.
severity=3Derr" we can see that the JBD2 process has been waiting for a
significant amount of time. Now the question is why it takes so long fo=
r
the IO to complete - likely not a fs problem but somewhere below - bloc=
k
layer or the storage itself.

What is the underlying storage? And what IO scheduler do you use? Seein=
g
that the device is 'vdc' - that suggests you are running in a guest - i=
s
there anything interesting happening on the host at that moment? Is IO =
from
other guests / the host stalled at that moment as well?

> >> I was running iotop and there was traffic roughly ~20 KB/s write.
> >>=20
> >> What was bit more interesting, was looking at
> >>=20
> >>    cat /proc/vmstat | egrep "nr_dirty|nr_writeback"
> >>=20
> >> nr_drity had around 240 and was slowly counting up, but nr_writeba=
ck had
> >> ~8800 and was stuck for 120s.
> >
> > Hum, interesting. This would suggest like IO completion got stuck f=
or some
> > reason. We'll see more from the stacktraces hopefully.
>=20
> I have monitor /sys/kernel/debug/bdi/253:32/stats for 10 mins per 1 s=
ec.
> Values are all same as follows:
>=20
>     --[ Sun Jun 19 06:11:08 CEST 2016
>     BdiWriteback:            15840 kB
>     BdiReclaimable:          32320 kB
>     BdiDirtyThresh:              0 kB
>     DirtyThresh:           1048576 kB
>     BackgroundThresh:       131072 kB
>     BdiDirtied:         6131163680 kB
>     BdiWritten:         6130214880 kB
>     BdiWriteBandwidth:      324948 kBps
>     b_dirty:                     2
>     b_io:                        3
>     b_more_io:                   0
>     bdi_list:                    1
>     state:                       c

OK, so all the IO looks stalled for that period of it.

> Maybe those values can cause issue and kicks in writeback to often an=
d
> block everyone else.
>=20
>    $ sysctl -a | grep dirty | grep -v ratio
>    vm.dirty_background_bytes =3D 134217728
>    vm.dirty_bytes =3D 1073741824
>    vm.dirty_expire_centisecs =3D 1500
>    vm.dirty_writeback_centisecs =3D 500

This looks healthy.

> I even have output of command, if you're interested.
>=20
>   $ trace-cmd record -e ext4 -e jbd2 -e writeback -e block sleep 600

Traces from block layer may be interesting but you'd need the trace sta=
rted
before the hang starts so that you see what happened with the IO that
jbd2/vdc-8:4710 is waiting for.

								Honza
--=20
Jan Kara <jack@suse.com>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
