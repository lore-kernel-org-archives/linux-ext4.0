From: Curt Wohlgemuth <curtw@google.com>
Subject: Re: ext4: 1k-blocksize loopback corruption without removing backing file
Date: Thu, 21 Apr 2011 15:54:53 -0700
Message-ID: <BANLkTik3TZB7eaPOAxADHZ=9k540WjrYHg@mail.gmail.com>
References: <87k4ensbn6.fsf@rho.meyering.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext <linux-ext4@vger.kernel.org>
To: Jim Meyering <jim@meyering.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:6464 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755576Ab1DUWy6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Apr 2011 18:54:58 -0400
Received: from hpaq11.eem.corp.google.com (hpaq11.eem.corp.google.com [172.25.149.11])
	by smtp-out.google.com with ESMTP id p3LMsvU9013307
	for <linux-ext4@vger.kernel.org>; Thu, 21 Apr 2011 15:54:57 -0700
Received: from qyk35 (qyk35.prod.google.com [10.241.83.163])
	by hpaq11.eem.corp.google.com with ESMTP id p3LMstuU027344
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Thu, 21 Apr 2011 15:54:56 -0700
Received: by qyk35 with SMTP id 35so139293qyk.20
        for <linux-ext4@vger.kernel.org>; Thu, 21 Apr 2011 15:54:55 -0700 (PDT)
In-Reply-To: <87k4ensbn6.fsf@rho.meyering.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

As Eric mentions, disabling mblk_io_submit makes this work.

I've reproduced this on my system, and I'm testing a fix for it which
I'll try to post tomorrow.  It's limited to block size < page size
partitions.

Curt

On Thu, Apr 21, 2011 at 11:27 AM, Jim Meyering <jim@meyering.net> wrote=
:
> Much like this report,
>
> =A0 =A0loopback-mounted ext4 sees hole-filling (on rawhide, but not F=
15)
> =A0 =A0http://thread.gmane.org/gmane.comp.file-systems.ext4/24454
>
> but not requiring that one remove the backing file, this script shows=
 the
> same sort of corruption with a loopback-ext4-in-loopback-ext4 file sy=
stem:
> [Note these FS are small enough that they get a blocksize of 1024 by =
default.
> =A0When I specify -b 2048 or 4096, the problem goes away. ]
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> #!/bin/sh
> set -e
> dd if=3D/dev/zero of=3Dblob bs=3D9k count=3D1000 >/dev/null 2>&1
> mkdir mnt
> mkfs -q -t ext4 -F blob
> mount -oloop blob mnt
>
> c1=3D$PWD
> cd mnt
>
> dd if=3D/dev/zero of=3Dblob bs=3D4k count=3D1000 >/dev/null 2>&1
> mkdir m2
> mkfs -q -t ext4 -F blob
> mount -oloop blob m2
>
> c2=3D$PWD
> cd m2
>
> # Create a reference file. =A0Just like the following one,
> # but with explicit NULs in place of holes.
> perl -e '$n=3D1024; for (1..71) { print "\0"x$n, chr($_)x$n };' \
> =A0-e 'close *STDOUT or die "$!"' > ref
>
> # Seek 1KB, write 1KB of data, seek 1KB, write 1KB of data, etc....
> perl -e '$n =3D 1 * 1024; *F =3D *STDOUT;' \
> =A0-e 'for (1..71) { sysseek (*F, $n, 1)' \
> =A0-e '&& syswrite (*F, chr($_)x$n) or die "$!"}' > j1
>
> # filefrag -vs j1
>
> sync
> cmp -s ref j1 && fail=3D0 || fail=3D1
>
> cd /
> umount "$c2/m2" "$c1/mnt"
> rm -rf "$c1/blob" "$c1/mnt"
>
> exit $fail
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> This shows that it fails most of the time for me in tmpfs on a rawhid=
e
> guest (2.6.39-0.rc3.git2.0.fc16.x86_64) running on an F15 host. =A0YM=
WV.
>
> =A0 =A0$ while :; do ./ext4-bug; printf $?; done
> =A0 =A0111111110111111110111111011111111110101111111111
> =A0 =A0[Exit 130 (INT)]
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
