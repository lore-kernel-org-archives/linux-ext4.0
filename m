From: Alexander Beregalov <a.beregalov@gmail.com>
Subject: Re: 2.6.33-rc1: kernel BUG at fs/ext4/inode.c:1063 (sparc)
Date: Fri, 25 Dec 2009 22:33:05 +0300
Message-ID: <a4423d670912251133u795338a4wd32d5cdef8c36c75@mail.gmail.com>
References: <a4423d670912241428n6917d2adsad887548612cf8ce@mail.gmail.com>
	 <a4423d670912241449y2da43d5fi3e5a18c114b84178@mail.gmail.com>
	 <87hbrfdylc.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:36422 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbZLYTdI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Dec 2009 14:33:08 -0500
In-Reply-To: <87hbrfdylc.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>> It seems I can easily reproduce it.
>> But I can't compile 2.6.33-rc2 :)
>>
>> scripts/kconfig/conf -s arch/sparc/Kconfig
>> =C2=A0 CHK =C2=A0 =C2=A0 include/linux/version.h
>> =C2=A0 CHK =C2=A0 =C2=A0 include/generated/utsrelease.h
>> =C2=A0 CALL =C2=A0 =C2=A0scripts/checksyscalls.sh
>> =C2=A0 CHK =C2=A0 =C2=A0 include/generated/compile.h
>> =C2=A0 GZIP =C2=A0 =C2=A0kernel/config_data.gz
>> =C2=A0 CC =C2=A0 =C2=A0 =C2=A0fs/configfs/inode.o
>> =C2=A0 IKCFG =C2=A0 kernel/config_data.h
>> =C2=A0 LD [M] =C2=A0fs/btrfs/btrfs.o
>> =C2=A0 CC =C2=A0 =C2=A0 =C2=A0kernel/configs.o
>> fs/btrfs/sysfs.o: file not recognized: File truncated
> This happens because of =C2=A0delayed allocation. Each time BUG or
> unexpected power off happens during object files usually becomes
> broken. IMHO this is expected issue. Just recompile from beginning
> # make clean; make -j4

It does not help, it still fails.
I will try to crosscompile the kernel with Ted's patch on another host.

> As soon as your testcase is kernel compilation.
> Strange i'm living with quota patches on my notebook more than
> a month( two weeks with the version committed to quota git tree)
> with and without quota . But this never happens.
> Currently i'm trying to reproduce the bug on 2.6.33-rc2
> Please add keep me in cc because seems the bug was introduced
> (or just triggered) by my quota patches.
>> make[2]: *** [fs/btrfs/btrfs.o] Error 1
>> make[1]: *** [fs/btrfs] Error 2
>> make[1]: *** Waiting for unfinished jobs....
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
