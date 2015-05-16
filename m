From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Re: Lazytime undone by/not working with remount?
Date: Sat, 16 May 2015 14:26:22 +0000 (UTC)
Message-ID: <pan.2015.05.16.14.26.22@googlemail.com>
References: <pan.2015.05.16.11.05.04@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37910 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156AbbEPO03 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 16 May 2015 10:26:29 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1Ytd2p-0005OB-NZ
	for linux-ext4@vger.kernel.org; Sat, 16 May 2015 16:26:27 +0200
Received: from pd953e5c7.dip0.t-ipconnect.de ([217.83.229.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Sat, 16 May 2015 16:26:27 +0200
Received: from holger.hoffstaette by pd953e5c7.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Sat, 16 May 2015 16:26:27 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


(cc: kzak)

On Sat, 16 May 2015 11:05:04 +0000, Holger Hoffst=C3=A4tte wrote:

> Hi,
>=20
> playing with lazytime on 4.0.4-rc1 + yesterday's fencepost patch) I n=
oticed
> something odd. Mounting secondary (non-root) partitions with lazytime=
 works
> fine, but / does not seem to retain the value from fstab - apparently=
 because
> it is remounted rw during boot, and lazytime gets swallowed/undone.
>=20
> Same effect when trying to remount manually with lazytime:
>=20
> tux>findmnt /
> TARGET SOURCE    FSTYPE OPTIONS
> /      /dev/sda1 ext4   rw,noatime
>=20
> tux>mount -o lazytime,remount /=20
>=20
> tux>dmesg=20
> [ 5208.482505] EXT4-fs (sda1): re-mounted. Opts: (null)
>=20
> tux>findmnt /                 =20
> TARGET SOURCE    FSTYPE OPTIONS
> /      /dev/sda1 ext4   rw,noatime
>=20
> tux>mount --version
> mount from util-linux 2.26.2 (libmount 2.26.0: assert, debug)
>=20
> Newly mounting unmounted partitions works fine.
>=20
> Any ideas?

This turned out to be a regression in util-linux 2.26.x. :-(
I downgraded to 2.25.2 and behold:

tux>findmnt /  =20
TARGET SOURCE    FSTYPE OPTIONS
/      /dev/sda1 ext4   rw,noatime

tux>mount -o remount,lazytime /

root>findmnt /                 =20
TARGET SOURCE    FSTYPE OPTIONS
/      /dev/sda1 ext4   rw,noatime,lazytime

Sorry for the noise.

Holger

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
