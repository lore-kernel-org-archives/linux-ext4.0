From: Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH v1 00/30] Ext4 snapshots
Date: Fri, 10 Jun 2011 18:51:28 -0400
Message-ID: <52699.1307746288@turing-police.cc.vt.edu>
References: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net> <alpine.LFD.2.00.1106071735100.11385@dhcp-27-109.brq.redhat.com> <BANLkTikAB-RDDS8PMMrFK-OuY6PuavBixA@mail.gmail.com> <alpine.LFD.2.00.1106081114240.5026@dhcp-27-109.brq.redhat.com> <BANLkTi=T1OtyRSWNTA6xhkTy5uaHWqA_XA@mail.gmail.com> <alpine.LFD.2.00.1106081716200.6609@dhcp-27-109.brq.redhat.com> <BANLkTikUXdvMQROYEdxnyfcPuB0e9ozMOg@mail.gmail.com> <BANLkTinU9Hegr3iA5it2vNjE_RYbB+8+RQ@mail.gmail.com> <BANLkTik9Mnq5yqK795pxyr8SK-3EOzzNhA@mail.gmail.com> <alpine.LFD.2.00.1106090834270.4138@dhcp-27-109.brq.redhat.com> <BANLkTi=fugrRE0P5m8nMPrH_kZqPZB7ajA@mail.gmail.com> <alpine.LFD.2.00.1106091012030.4138@dhcp-27-109.brq.redhat.com>
            <BANLkTin0RKZbDmB1movombH9o4HDpTnvFw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1307746288_4421P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Cc: Lukas Czerner <lczerner@redhat.com>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	linux-ext4@vger.kernel.org, tytso@mit.edu,
	linux-kernel@vger.kernel.org, sandeen@redhat.com
To: "Amir G." <amir73il@users.sourceforge.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lennier.cc.vt.edu ([198.82.162.213]:47122 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758193Ab1FJWwS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Jun 2011 18:52:18 -0400
In-Reply-To: Your message of "Thu, 09 Jun 2011 13:54:13 +0300."
             <BANLkTin0RKZbDmB1movombH9o4HDpTnvFw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--==_Exmh_1307746288_4421P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Thu, 09 Jun 2011 13:54:13 +0300, =22Amir G.=22 said:

> Why do you keep saying 'backup only'?
> There is a huge difference between having long lived snapshots,
> like CTERA products have, and temporary snapshot for backup
> purpose (for which LVM is adequate).

I must have blinked somewhere - I'm not convinced LVM is even =22adequate=
=22 for
backup purposes.  In particular, how does an LVM-level snapshot deal with=
 the
=22metadata in memory=22 problem (basically the exact same problem as run=
ning fsck
on a disk partition that is already mounted)?


--==_Exmh_1307746288_4421P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFN8p/wcC3lWbTT17ARAkG1AJ4tvLevzsXjKQ6ZoiEUYl8Xldy92gCeOS2V
H2/Q0E6QhOIiWDjHRD2y14o=
=ry9L
-----END PGP SIGNATURE-----

--==_Exmh_1307746288_4421P--

