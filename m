From: =?ISO-8859-1?Q?=22Thomas_B=2E_R=FCcker=22?= <dm8tbr@openpma.org>
Subject: hiding an partition and preventing to get automounted
Date: Fri, 10 Nov 2006 21:31:48 +0100
Message-ID: <4554E1B4.3050508@openpma.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from dk0td.afthd.tu-darmstadt.de ([130.83.179.98]:61154 "EHLO
	dk0td.afthd.tu-darmstadt.de") by vger.kernel.org with ESMTP
	id S966108AbWKJUbv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 10 Nov 2006 15:31:51 -0500
Received: from [10.42.0.25] (p54B002E2.dip0.t-ipconnect.de [84.176.2.226])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by dk0td.afthd.tu-darmstadt.de (Postfix) with ESMTP id 5B6F01F5AEB
	for <linux-ext4@vger.kernel.org>; Fri, 10 Nov 2006 21:31:50 +0100 (CET)
To: linux-ext4@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Short description of the situation:
- embedded linux device running 2.4.19 montavista (Archos PMA430)
- redesigning the firmware to as open source as possible
- moved system partition from an loop mounted ext3 image on a fat32
partition to a real partition.
- device supports usb-mass-storage mode (complete hdd gets handed over
to a usb-bridge)

Now we're trying to avoid unmounting that ext3 partition because we use
it with unionfs to have a writeable root filesystem.
The problem is that when the hdd is accessed via usb the operating
system of that desktop PC might mount that ext3 partition and change it=
=2E
What would be a clean way to hide the partition from systems accessing
it? What would be a clean way of making it ReadOnly to those systems?

We had some ideas like using a different magic for the filesystem or a
high and unique revision number we could patch our kernel for, but I'm
not sure if there would be bad side effects to that. Marking the
partition as e.g. hidden FAT16 (0x16) won't keep a linux system from
recognizing and automounting it.

Any ideas or pointers?

TIA & Cheers

Thomas B. R=FCcker

www.openpma.org
