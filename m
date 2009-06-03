From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH-e2fsprogs] filefrag: fix fm_start in filefrag_fiemap	loop
Date: Wed, 03 Jun 2009 15:37:24 -0600
Message-ID: <20090603213724.GU9002@webber.adilger.int>
References: <1243965783-31950-1-git-send-email-bergwolf@gmail.com>
 <20090602183513.GK3218@webber.adilger.int>
 <6149e97b0906021821s315005a7lb1c93b74b7f35489@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Peng Tao <bergwolf@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:47309 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082AbZFCVhe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Jun 2009 17:37:34 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n53LbarI006344
	for <linux-ext4@vger.kernel.org>; Wed, 3 Jun 2009 14:37:36 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 id <0KKO00400MGGYX00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Wed,
 03 Jun 2009 14:37:36 -0700 (PDT)
In-reply-to: <6149e97b0906021821s315005a7lb1c93b74b7f35489@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jun 03, 2009  09:21 +0800, Peng Tao wrote:
> When used with -v and the targeted file has more than 144
> extents(double of the length of fm_extents array provided by buf),
> filefrag_fiemap loops and calls fiemap ioctl() multiple times to
> calculate the actual number of extents in a file. Each call to fiemap
> ioctl() uses  fm_start as the starting logical offset. The patch fixe=
s
> fm_start in each loop( except for the first one) and makes the extent
> calculation correct for files with more that 144 extents.
>=20
> To produce the problem, first run filefrag -v on a highly fragmented
> file. Then change the buf size in filefrag_fiemap to make it large
> enough to have all the extent mapped in a single loop and run filefra=
g
> -v after recompiling. The former will produce a much smaller extent
> count because of the false fm_start used in the loop. And the two wil=
l
> produce different extent output since the 145th extent.
>=20
> BTW, should I resend the patch to include the above explanation?

Yes, please do.  I verified that the code as modified (just '=3D') is a=
lso
present in the Lustre fiemap patch, so I'm not sure how it got +=3D the=
re.
Possibly from an older version of the patch.

> > On Jun 03, 2009 =A002:03 +0800, Peng Tao wrote:
> >> Signed-off-by: Peng Tao <bergwolf@gmail.com>
> >> ---
> >> =A0misc/filefrag.c | =A0 =A02 +-
> >> =A01 files changed, 1 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/misc/filefrag.c b/misc/filefrag.c
> >> index 6bea2cd..7786646 100644
> >> --- a/misc/filefrag.c
> >> +++ b/misc/filefrag.c
> >> @@ -239,7 +239,7 @@ int filefrag_fiemap(int fd, int blk_shift, int=
 *num_extents)
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 n++;
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> >>
> >> - =A0 =A0 =A0 =A0 =A0 =A0 fiemap->fm_start +=3D fm_ext[i-1].fe_log=
ical +
> >> + =A0 =A0 =A0 =A0 =A0 =A0 fiemap->fm_start =3D fm_ext[i-1].fe_logi=
cal +
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fm_ext[i-1].fe_length;
> >> =A0 =A0 =A0 } while (last =3D=3D 0);
> >>
> >> --
> >> 1.6.2.GIT

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
