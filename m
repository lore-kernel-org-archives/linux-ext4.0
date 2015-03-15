From: Dmitry Monakhov <dmonlist@gmail.com>
Subject: Re: very slow SSD with fsync
Date: Sun, 15 Mar 2015 17:35:03 +0300
Message-ID: <87vbi2qqg8.fsf@openvz.org>
References: <5502F8A3.4020608@smop.co.uk> <20150313152559.GB21922@thunk.org> <55033BA5.9000806@smop.co.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"
Cc: linux-ext4@vger.kernel.org
To: Adrian Bridgett <adrian@smop.co.uk>, Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:36036 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440AbbCOOgh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 15 Mar 2015 10:36:37 -0400
Received: by wgra20 with SMTP id a20so21343140wgr.3
        for <linux-ext4@vger.kernel.org>; Sun, 15 Mar 2015 07:36:35 -0700 (PDT)
In-Reply-To: <55033BA5.9000806@smop.co.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Adrian Bridgett <adrian@smop.co.uk> writes:

> On 13/03/15 15:25, Theodore Ts'o wrote:
>> The obvious thing to do is to try using blktrace to see which I/O
>> operations are triggering the problem.  It may just be that the hard
>> drive's internal FTL metadata is very badly fragmented.
> Damn :-(  Seems a bit odd as it's only a few months old (not used much)=20
> and OSX _seems_ fine.
>
> Not quite sure what to look for in blktrace.  I see the sync but the=20
> timestamps in blktrace are near instantaneous vs 1.3, 2.2 seconds=20
> reported by strace.   Trying a "find" and watching it stall blktrace=20
> shows this - which to my amateur eyes shows a 0.5s gap between the read=20
> request at 1.815589 and being issued at 2.373.  Two completions being=20
> the only occurrence in the middle.  Maybe queue depth was full - but we=20
> have a two completions earlier.
>
>
>    8,0    0      226     1.812363080   271  D  WS 498955904 + 16 (=20=20=
=20=20=20
> 988) [jbd2
> /dm-0-8]
>    8,0    0      227     1.812439052     0  C  WS 498955904 + 16 (=20
> 75972) [0]
>    8,4    0      228     1.812456484   271  A FWS 0 + 0 <- (252,0) 0
>    8,0    0      229     1.812456838   271  Q FWS [jbd2/dm-0-8]
>    8,4    0      230     1.812457124   271  A FWS 0 + 0 <- (252,0) 0
>    8,0    0      231     1.812457237   271  Q FWS [jbd2/dm-0-8]
>    8,0    0      232     1.812458007   271  G FWS [jbd2/dm-0-8]
>    8,0    0      233     1.812458478   271  I FWS (     471) [jbd2/dm-0-8]
>    8,0    0      234     1.812465182   271  G FWS [jbd2/dm-0-8]
>    8,0    0      235     1.812465316   271  I FWS (     134) [jbd2/dm-0-8]
>    8,0    0      236     1.815446245     0  C  RM 507106648 + 8 (=20
> 3778637) [0]
>    8,4    2       11     1.815585457 31072  A  RM 16875872 + 8 <-=20
> (252,0) 1687382
> 4
>    8,0    2       12     1.815585633 31072  A  RM 507107680 + 8 <- (8,4)=
=20
> 16875872
>    8,0    2       13     1.815586124 31072  Q  RM 507107680 + 8 [find]
>    8,0    2       14     1.815588326 31072  G  RM 507107680 + 8 [find]
>    8,0    2       15     1.815589269 31072  I  RM 507107680 + 8 ( 943)=20
> [find]
>    8,0    0      237     1.830102994     0  C  WS 0 (17739914) [0]
>    8,0    0      238     2.373458367     0  C  WS 0 [0]
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
As far as I can see it stuck on superblock completion which was issued
as 228'th request. It takes ~500ms to complete it. Tend to agree with
Ted looks likely your SSD has problems probably with FTL layer.
In order to check that filesystem is not related with the issye you may try=
 RAW IO:

###umount your filesystem. *This is important, otherwise you may corrupt yo=
ur FS*
#umount /$YOUR_FS
### Read and write back your superblock. Second operation should give
###  you same timings as superblock commit from JBD2=20
#dd if=3D/dev/$YOUR_DISK of=3Dsuper_block bs=3D4k count=3D4 iflag=3Ddirect
#dd if=3Dsuper_block of=3D/dev/$YOUR_DISK bs=3D4k count=3D4 conv=3Dfsync,no=
trunc oflag=3Ddirect

Superblock is most frequently rewritten block in whole disk, so if
previous filesystem do not issued TRIM requests back to SSD, so it's FTL may
become very slow. You should try fstrim(8), probably it can helps=20

>    8,0    0      239     2.373469557     0  D  RM 507107680 + 8=20
> (557880288) [swap
> per/0]
>    8,4    0      240     2.373486949 15158  A WFS 8724112 + 8 <- (252,0)=
=20
> 8722064
>    8,0    0      241     2.373487336 15158  A WFS 498955920 + 8 <- (8,4)=
=20
> 8724112
>    8,0    0      242     2.373488480 15158  Q WFS 498955920 + 8=20
> [kworker/0:2]
>    8,0    0      243     2.373490158 15158  G WFS 498955920 + 8=20
> [kworker/0:2]
>    8,0    0      244     2.373491573 15158  I WFS 498955920 + 8 ( 1415)=20
> [kwork
> er/0:2]
>    8,0    0      245     2.373491927 15158  D  WS 498955920 + 8 ( 354)=20
> [kworker/0:2]
>    8,0    0      246     2.373596570     0  C  WS 498955920 + 8 (=20
> 104643) [0]
>    8,0    0      247     2.375251869     0  C  RM 507107680 + 8 (=20
> 1782312) [0]
>    8,4    2       16     2.375452116 31072  A  RM 16875072 + 8 <-=20
> (252,0) 16873024
>    8,0    2       17     2.375452283 31072  A  RM 507106880 + 8 <- (8,4)=
=20
> 16875072
>    8,0    2       18     2.375452776 31072  Q  RM 507106880 + 8 [find]
>
> I'm looking at  'watch -n0 cat  /proc/diskstats |egrep -v "ram|loop"'=20
> and it's normally sat down at 0/1 for I/Os in progress (have seen hit=20
> 100 _briefly_ and then drop just as quickly).
>
>> What model SSD is it, by the way?
> It's the built-in Apple MBP 512GB drive - "APPLE SSD SM0512F" which=20
> apparently means Samsung (I've been reading about issues with their=20
> 840EVO drives...
>
> Thanks once again (and for all your immense work over the many, many year=
s!)
>
> Adrian
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCgAGBQJVBZiXAAoJELhyPTmIL6kBvfQH+wfr0Q4c756qEGrbhABDcQtF
jfZ4I76iLgUcjnjR/5byGaufMaylvXHjL/KuWcq62YPvJcekuNyaY3sdOz1YqoXK
QbmGRhVMv2hcpu0eS2pLd2NR9aFrEXYsc3h6aDIyaVtuKocPqYypaPvp9MWQBojW
R+Ge6KQd/dwThPYZVVE/1r6OYUuAROZVFBGZnoeAvDeWrqobLZUV56YV/jdxZ/aa
LKi0dIQfIFABMpfyPo6pWwWGPJMwSYkxNG/LOsb4kIpBgONZfgG7sXQK7SrhBj5M
E6QEOY1cn5q7ScEkSTZej4gn/7T8fOb2POvwmmMpLCctUnw7lWX9PSogwLyHqtU=
=nPpx
-----END PGP SIGNATURE-----
--=-=-=--
