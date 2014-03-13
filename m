From: Robert Yang <liezhi.yang@windriver.com>
Subject: Re: [PATCH] create_inode: fix gcc -Wall complaints
Date: Thu, 13 Mar 2014 10:21:28 +0800
Message-ID: <53211628.9090505@windriver.com>
References: <1394595670-11193-1-git-send-email-tytso@mit.edu> <20140312034539.GC26898@thunk.org> <20140312034841.GC31864@birch.djwong.org> <20140312143215.GA15334@thunk.org> <20140312200219.GC9070@birch.djwong.org> <20140312205110.GF15334@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:58853 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbaCMCVg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 12 Mar 2014 22:21:36 -0400
In-Reply-To: <20140312205110.GF15334@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On 03/13/2014 04:51 AM, Theodore Ts'o wrote:
> On Wed, Mar 12, 2014 at 01:02:19PM -0700, Darrick J. Wong wrote:
>>>
>>> gcc -Wall, via "make gcc-wall" and "make gcc-wall-new"
>>
>> Annoyingly, I ran make gcc-wall on Ubuntu 12.04 (gcc 4.6, glibc 2.15=
) and got
>> this splat:
>>
>> /usr/include/x86_64-linux-gnu/sys/stat.h:456: multiple definition of=
 `stat'
>> ../lib/libquota.a(quotaio_v2.o):/usr/include/x86_64-linux-gnu/sys/st=
at.h:456: first defined here
>>
>> Not sure how to fix this, other than changing WFLAGS to start with -=
std=3Dgnu99.
>> gcc 4.8/glibc 2.19 on Ubuntu 14 are no better.
>
> Hmm, I'm using Debian testing, with gcc 4.8 and eglibc 2.18, and it's
> working fine.  I'm curious, are people noticing problems with gcc-wal=
l
> on Fedora?
>

I got the similar error as Darrick on Fedora 19 x86_64:

$ make gcc-wall

[snip]
rehash.c:504:10: warning: nested extern declaration of =91ext2fs_dirent=
_file_type=92=20
[-Wnested-externs]
/usr/include/sys/stat.h:455: multiple definition of `stat'
=2E./lib/libquota.a(quotaio_v2.o):/usr/include/sys/stat.h:455: first de=
fined here
/usr/include/sys/stat.h:462: multiple definition of `lstat'
=2E./lib/libquota.a(quotaio_v2.o):/usr/include/sys/stat.h:462: first de=
fined here
/usr/include/sys/stat.h:469: multiple definition of `fstat'
=2E./lib/libquota.a(quotaio_v2.o):/usr/include/sys/stat.h:469: first de=
fined here
/usr/include/sys/stat.h:477: multiple definition of `fstatat'
=2E./lib/libquota.a(quotaio_v2.o):/usr/include/sys/stat.h:477: first de=
fined here
/usr/include/sys/stat.h:485: multiple definition of `mknod'
=2E./lib/libquota.a(quotaio_v2.o):/usr/include/sys/stat.h:485: first de=
fined here
/usr/include/sys/stat.h:494: multiple definition of `mknodat'
=2E./lib/libquota.a(quotaio_v2.o):/usr/include/sys/stat.h:494: first de=
fined here
/usr/include/sys/stat.h:504: multiple definition of `stat64'
=2E./lib/libquota.a(quotaio_v2.o):/usr/include/sys/stat.h:504: first de=
fined here
/usr/include/sys/stat.h:511: multiple definition of `lstat64'
=2E./lib/libquota.a(quotaio_v2.o):/usr/include/sys/stat.h:511: first de=
fined here
/usr/include/sys/stat.h:518: multiple definition of `fstat64'
=2E./lib/libquota.a(quotaio_v2.o):/usr/include/sys/stat.h:518: first de=
fined here
/usr/include/sys/stat.h:526: multiple definition of `fstatat64'
=2E./lib/libquota.a(quotaio_v2.o):/usr/include/sys/stat.h:526: first de=
fined here
collect2: error: ld returned 1 exit status
[snip]

// Robert

> 					- Ted
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
