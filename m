From: "Marcel Partap" <mpartap@gmx.net>
Subject: Re: Fwd: fsck ate my ext4 home partition, help!?
Date: Sun, 10 May 2009 17:25:20 +0200
Message-ID: <20090510152520.262850@gmx.net>
References: <20090510145130.262830@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, tytso@thunk.org
To: "Marcel Partap" <mpartap@gmx.net>, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:56777 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754172AbZEJPZW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 10 May 2009 11:25:22 -0400
In-Reply-To: <20090510145130.262830@gmx.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> I know some of the filenames that were in that directory. Is there an=
y
> more usable method to find these inodes? for example, i know there wa=
s a
> symlink drive_c in there, and a file 'snippetz'. Can't i use this to =
somehow
> locate some of the dangling meta information? For sure it can't be al=
l
> overwritten... If i grep the partition image for that filename and lo=
ok up any
> resulting blocks with debugfs, is that getting me anywhere nearer the=
 list of
> files in that directory?
Soo opening the image with hexedit and doing an ascii search for 'snipp=
etz' right at the beginning gave me several locations which look an awf=
ul lot like lists of filenames in that directory. Converted the locatio=
ns to decimal with echo $((16#hexnumber)) those are=20
0x28E450/0x438A2C0600 (Byte 2679888/290080949760)
0x1125450/0x438A2C0600 (Byte 17978448/290080949760)
0x114F450/0x438A2C0600 (Byte 18150480/290080949760)
0x1219450/0x438A2C0600 (Byte 18977872/290080949760)
Now what potential approaches could i take with debugfs now that it see=
ms there are residual pieces of the directory? How to determine the cor=
responding inodes from the block number (position in bytes / 512, right=
?) - not clear to me from the man page...
regards marcel (slightly more optimistic now).=20
--=20
Neu: GMX FreeDSL Komplettanschluss mit DSL 6.000 Flatrate + Telefonansc=
hluss f=FCr nur 17,95 Euro/mtl.!* http://dslspecial.gmx.de/freedsl-surf=
flat/?ac=3DOM.AD.PD003K11308T4569a
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
