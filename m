From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: Segfaults--they're back!
Date: Wed, 09 Jul 2008 17:16:17 -0700
Message-ID: <1215648977.6978.7.camel@mingming-laptop>
References: <3.0.6.32.20080709150004.01bd9858@pop.west.cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Theodore Tso <tytso@mit.edu>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Gary Hawco <ghawco@cox.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:39953 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488AbYGJAQT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Jul 2008 20:16:19 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e33.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m6A0GI7K012737
	for <linux-ext4@vger.kernel.org>; Wed, 9 Jul 2008 20:16:18 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6A0GIcX101844
	for <linux-ext4@vger.kernel.org>; Wed, 9 Jul 2008 18:16:18 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6A0GHsd011020
	for <linux-ext4@vger.kernel.org>; Wed, 9 Jul 2008 18:16:18 -0600
In-Reply-To: <3.0.6.32.20080709150004.01bd9858@pop.west.cox.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-07-09=E4=B8=89=E7=9A=84 15:00 +0000=EF=BC=8CGary Hawco=E5=
=86=99=E9=81=93=EF=BC=9A
> Segfaults have returned with snapshots compiled after 070908--0010hrs=
 GMT.
>=20
> That one worked fine.
>=20
> The next one I tried (070908/0025hrs GMT) caused segfaults in both Ge=
ntoo &
> Slackware (a first for Slackware) when trying to untar
> linux-2.6.26-rc9.tar.bz2 tarball)
>=20
> I then rolled back two snapshots to 070908/0012hrs GMT) and it segfau=
lted
> in both operating systems doing same untarring function.
>=20
> So, apparently, since 0010snapshot
> (ext4-patch-queue-bfb23cf4cd345552c774142cb10ac1225caf35f5.tar.gz) wo=
rks fine
>=20
> and 0012snapshot
> (ext4-patch-queue-be66b0c5c3f4293176301c0ddcb8db95b0576cb4.tar.gz)
> segfaults, the=20
> Add ext4-fix-mb_find_next_bit-return.patch must be the culprit.
>=20

Thanks for reporting this,=20
commit be66b0c5c3f4293176301c0ddcb8db95b0576cb4 added
ext4-fix-mb_find_next_bit-return.patch

I have dropped  this patch from patch queue, could you please check if
the segment fault goes away?


Mingming
> Thanks,
> Gary
>=20
> P.S. The latest snapshot from today @ 0303hrs GMT segfaults as well.
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
