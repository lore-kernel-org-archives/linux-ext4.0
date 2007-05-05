From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: random bug generator (was: 2.6.21-git4 Scheduler, NOHZ, VFS bugs)
Date: Sat, 05 May 2007 20:04:54 +0200
Message-ID: <463CC746.7050402@googlemail.com>
References: <463B5D63.2030109@googlemail.com>	 <20070504110158.d2808170.akpm@linux-foundation.org> <6bffcb0e0705050625m6bb05dc0ne0864ec2dba19256@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>,
	Thomas Gleixner <tglx@linutronix.de>, viro@ftp.linux.org.uk,
	linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Linus Torvalds <torvalds@linux-foundation.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:54492 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934180AbXEESEw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 May 2007 14:04:52 -0400
Received: by ug-out-1314.google.com with SMTP id 44so841617uga
        for <linux-ext4@vger.kernel.org>; Sat, 05 May 2007 11:04:50 -0700 (PDT)
In-Reply-To: <6bffcb0e0705050625m6bb05dc0ne0864ec2dba19256@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

Michal Piotrowski napisa=B3(a):
> On 04/05/07, Andrew Morton <akpm@linux-foundation.org> wrote:
>> On Fri, 04 May 2007 18:20:51 +0200 Michal Piotrowski
>> <michal.k.k.piotrowski@gmail.com> wrote:
>>
>> > I ran this script tree times,
>> >
>> > #! /bin/sh
>> >
>> > for i in `find /sys/ -type f`
>> > do
>> >     echo "wy=B6wietlam $i"
>> >     sudo cat $i > /dev/null
>> > done
>> >
>> > First run - scheduler bug
>> > Second run - NOHZ bug
>> > Third - VFS bug
>> >
>> > Hmmmm...
>> >
>> > [93298.252601] BUG: at /mnt/md0/devel/linux-git/kernel/sched.c:324=
1
>> add_preempt_count()
>> > [93298.260334]  [<c0105039>] show_trace_log_lvl+0x1a/0x2f
>> > [93298.265507]  [<c0105720>] show_trace+0x12/0x14
>> > [93298.269974]  [<c01057d2>] dump_stack+0x16/0x18
>> > [93298.274434]  [<c011d18a>] add_preempt_count+0x89/0x8b
>> > [93298.279501]  [<c0126492>] irq_enter+0xd/0x2e
>> > [93298.283788]  [<c0114c1e>] smp_apic_timer_interrupt+0x2a/0x84
>> > [93298.289458]  [<c0104b2b>] apic_timer_interrupt+0x33/0x38
>> > [93298.294783]  [<c0257b79>] show_uevent+0x58/0xcd
>> > [93298.299329]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
>> > [93390.468056] NOHZ: local_softirq_pending 22
>> > [93447.105850] NOHZ: local_softirq_pending 22
>> > [93450.332884] BUG: unable to handle kernel paging request at
>> virtual address 3e343c0c
>> > [93450.340626]  printing eip:
>> > [93450.343333] c018e2bc
>> > [93450.345520] *pde =3D 00000000
>> > [93450.348314] Oops: 0000 [#1]
>>
>> Nice.  What was the last file which it read before crashing?
>>
>> Are you able to consistently crash it by reading just that file?
>=20
> Random files, random bugs (usually it starts with a slab corruption).
>=20
> git-bisect will give an answer.

So this is a random bug generator...

git-bisect bad
16574dccd8f62dc1b585325f8a6a0aab10047ed8 is first bad commit
commit 16574dccd8f62dc1b585325f8a6a0aab10047ed8
Author: Kay Sievers <kay.sievers@vrfy.org>
Date:   Fri Apr 6 01:40:38 2007 +0200

    Driver core: make uevent-environment available in uevent-file

    This allows sysfs to show the environment variables that are availa=
ble
    if the uevent happens.  This lets userspace not have to cache all o=
f
    this information as the kernel already knows it.

    Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

:040000 040000 34152258985968083c04ab003ced54d73e92a790 c3301e8cd7705c2=
93817c6747b3cc59d6cbf14bb M      drivers

http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-git4/gi=
t-config

Regards,
Michal

--=20
Michal K. K. Piotrowski
Kernel Monkeys
(http://kernel.wikidot.com/start)
