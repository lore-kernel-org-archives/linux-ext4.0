From: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: defrag deployment status (was Re: [PATCH] ext4: allow defrag (EXT4_IOC_MOVE_EXT) in 32bit compat mode)
Date: Mon, 8 Mar 2010 17:00:57 +0100
Message-ID: <201003081700.57245.borntraeger@de.ibm.com>
References: <201003072132.10579.borntraeger@de.ibm.com> <201003080853.42978.borntraeger@de.ibm.com> <4B9518DA.8010201@davidnewall.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Garzik <jeff@garzik.org>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Akira Fujita <a-fujita@rs.jp.nec.com>
To: David Newall <davidn@davidnewall.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mtagate6.de.ibm.com ([195.212.17.166]:55050 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183Ab0CHQBA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Mar 2010 11:01:00 -0500
In-Reply-To: <4B9518DA.8010201@davidnewall.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Am Montag 08 M=E4rz 2010 16:33:46 schrieb David Newall:
> Christian Borntraeger wrote:
> > Some bigger things are missing in the e4defrag tool:
> > ...
> > - overall layout considerations (e.g. putting files close to its di=
rectory or
> >   use the atime to move often used files to the beginning of a disk=
 etc.)
>=20
> Shouldn't oft-used files be placed closer to the middle?  If you plac=
e=20
> them at the beginning of the file, it's only possible for the head-st=
ack=20
> to be close to the file from the inner direction.  Place them in the=20
> middle and it's possible for the head-stack to be close from the oute=
r=20
> direction, too, which sounds like a doubling of probability.  It seem=
s=20
> that it's the least frequently used files that should be placed at on=
e=20
> end of the disk or the other.
>=20

Maybe. This was just an example of things that you can come
up with and which are not yet possible up in e4defrag.=20

Christian
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
