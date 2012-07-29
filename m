From: =?iso-8859-1?Q?Arne_H=FCggenberg?= <hueggenberg@sportsandbytes.de>
Subject: Re: resize2fs > 16TB questions
Date: Sun, 29 Jul 2012 18:48:58 +0200
Message-ID: <B6188C52-F783-4B9F-ABC9-9A24F72FA597@sportsandbytes.de>
References: <2019C80F-7D05-44FD-89AE-829E3A97053A@sportsandbytes.de> <2AD4EE0D-16C3-4D01-9A34-544E5D5FE8ED@whamcloud.com>
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail2.sportsandbytes.de ([87.193.191.13]:56192 "EHLO
	mail2.sportsandbytes.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233Ab2G2QtA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 29 Jul 2012 12:49:00 -0400
In-Reply-To: <2AD4EE0D-16C3-4D01-9A34-544E5D5FE8ED@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Jul 29, 2012, at 6:11 PM, Andreas Dilger wrote:
>> ~ # tune2fs -l /dev/vg0/lvol1
>> tune2fs 1.42.4 (12-June-2012)
>> Filesystem volume name:   <none>
>> Last mounted on:          /home/filestore_extern_1
>> Filesystem UUID:          8fba4f1b-5311-4c9b-b8bf-def4957dc1bd
>> Filesystem magic number:  0xEF53
>> Filesystem revision #:    1 (dynamic)
>> Filesystem features:      has_journal ext_attr resize_inode dir_inde=
x filetype needs_recovery extent 64bit flex_bg sparse_super large_file =
huge_file uninit_bg dir_nlink extra_isize
>=20
> Was the filesystem formatted with the 64bit option, or was this enabl=
ed after formatting time?  This puts my earlier comment in doubt.=20

Can it even be changed after format time? I tried to do that to save a =
backup/restore cycle, but tune2fs would not let me?

--=20
Arne H=FCggenberg
System Administrator
_______________________
Sports & Bytes GmbH
Rheinlanddamm 207-209
D-44137 Dortmund
Tel: + 49-231-9020-655
=46ax: + 49-231-9020-989

Gesch=E4ftsf=FChrer: Thomas Tre=DF

Sitz und Handelsregister: Dortmund, HRB 14983
=46inanzamt Dortmund - West
Steuer-Nr.: 314/5700/1299
USt-Id. Nr.: DE 208084540

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
