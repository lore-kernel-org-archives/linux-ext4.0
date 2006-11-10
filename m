From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: hiding an partition and preventing to get automounted
Date: Fri, 10 Nov 2006 17:11:57 -0600
Message-ID: <1163200318.28537.2.camel@kleikamp.austin.ibm.com>
References: <4554E1B4.3050508@openpma.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:58049 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S1424420AbWKJXMB
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 10 Nov 2006 18:12:01 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e33.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id kAANC1C9005637
	for <linux-ext4@vger.kernel.org>; Fri, 10 Nov 2006 18:12:01 -0500
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by westrelay02.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id kAANC14s522398
	for <linux-ext4@vger.kernel.org>; Fri, 10 Nov 2006 16:12:01 -0700
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id kAANC0cb002806
	for <linux-ext4@vger.kernel.org>; Fri, 10 Nov 2006 16:12:00 -0700
To: "\"Thomas B." =?ISO-8859-1?Q?R=FCcker=22?= <dm8tbr@openpma.org>
In-Reply-To: <4554E1B4.3050508@openpma.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 2006-11-10 at 21:31 +0100, "Thomas B. R=FCcker" wrote:
> Short description of the situation:
> - embedded linux device running 2.4.19 montavista (Archos PMA430)
> - redesigning the firmware to as open source as possible
> - moved system partition from an loop mounted ext3 image on a fat32
> partition to a real partition.
> - device supports usb-mass-storage mode (complete hdd gets handed ove=
r
> to a usb-bridge)
>=20
> Now we're trying to avoid unmounting that ext3 partition because we u=
se
> it with unionfs to have a writeable root filesystem.
> The problem is that when the hdd is accessed via usb the operating
> system of that desktop PC might mount that ext3 partition and change =
it.
> What would be a clean way to hide the partition from systems accessin=
g
> it? What would be a clean way of making it ReadOnly to those systems?
>=20
> We had some ideas like using a different magic for the filesystem or =
a
> high and unique revision number we could patch our kernel for, but I'=
m
> not sure if there would be bad side effects to that. Marking the
> partition as e.g. hidden FAT16 (0x16) won't keep a linux system from
> recognizing and automounting it.
>=20
> Any ideas or pointers?

Using a unique superblock magic sounds simple and is probably as
foolproof as anything.

Shaggy
--=20
David Kleikamp
IBM Linux Technology Center
