From: "Amit Agarwal" <amit.a@pathpartnertech.com>
Subject: mount issue for ext4 filesystem with hibernation support.
Date: Thu, 18 Jan 2018 12:38:08 +0530
Message-ID: <014f01d3902b$19a3e040$4ceba0c0$@pathpartnertech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f48.google.com ([74.125.83.48]:38224 "EHLO
        mail-pg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750931AbeARHIN (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Jan 2018 02:08:13 -0500
Received: by mail-pg0-f48.google.com with SMTP id y27so7330299pgc.5
        for <linux-ext4@vger.kernel.org>; Wed, 17 Jan 2018 23:08:13 -0800 (PST)
Received: from AmitLaptop ([182.72.168.238])
        by smtp.gmail.com with ESMTPSA id n24sm11984541pfi.33.2018.01.17.23.08.10
        for <linux-ext4@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 17 Jan 2018 23:08:11 -0800 (PST)
Content-Language: en-in
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello

When we added the hibernation support for android M, we are able to
hibernate and resume properly.but I=A0want to resume every time from single
snapshot image which have been taken at first-boot. But I am having problem
with that image after 2nd boot onwards.

I am getting ext4 error, seems like block number mismatch and that
file-system on that partition is being remounted as read-only mode.

Below errors i am getting every time after 2nd boot onwards:
---------------------------------------------------------------------------=
-
----
[=A0 =A064.250735] EXT4-fs error (device mmcblk0p24):
ext4_mb_generate_buddy:758: group 9, block bitmap and bg descriptor
inconsistent: 31166 vs 31165 free clusters
[=A0 =A064.252813] <3> (3)[1507:PackageManager]Aborting journal on device
mmcblk0p24-8.
[=A0 =A064.267680] <3> (3)[1507:PackageManager]EXT4-fs (mmcblk0p24): Remoun=
ting
filesystem read-only
[=A0 =A064.268667] <3> (1)[1:init]init: Starting service 'media'...
[=A0 =A064.269479] <3> (3)[1507:PackageManager]EXT4-fs error (device mmcblk=
0p24)
in ext4_free_blocks:4881: Journal has aborted
[=A0 =A064.272235] <3> (3)[1507:PackageManager]EXT4-fs error (device mmcblk=
0p24)
in ext4_reserve_inode_write:4999: Journal has aborted
[=A0 =A064.278537] <3> (3)[1507:PackageManager]EXT4-fs error (device mmcblk=
0p24)
in ext4_reserve_inode_write:4999: Journal has aborted
[=A0 =A064.283132] <3> (3)[1507:PackageManager]EXT4-fs error (device mmcblk=
0p24)
in ext4_ext_remove_space:3035: Journal has aborted
[=A0 =A064.286970] <3> (3)[1507:PackageManager]EXT4-fs error (device mmcblk=
0p24)
in ext4_ext_truncate:4669: Journal has aborted
[=A0 =A064.291775] <3> (3)[1507:PackageManager]EXT4-fs error (device mmcblk=
0p24)
in ext4_reserve_inode_write:4999: Journal has aborted
[=A0 =A064.294465] <3> (3)[1507:PackageManager]EXT4-fs error (device mmcblk=
0p24)
in ext4_truncate:3894: Journal has aborted
[=A0 =A064.297764] <3> (3)[1507:PackageManager]EXT4-fs error (device mmcblk=
0p24)
in ext4_reserve_inode_write:4999: Journal has aborted
[=A0 =A064.300437] <3> (3)[1507:PackageManager]EXT4-fs error (device mmcblk=
0p24)
in ext4_orphan_del:2888: Journal has aborted

---------------------------------------------------------------------------=
-
-------------------------

This is happening because mounted partition meta-data in RAM(old snapshot
image) is not matched with actual data in disk.

Please suggest me some way to overcome this problem.

Also is it possible to update file-system's meta-data to RAM from
partition(mounted and used by some apps)?

Regards,
Amit Agarwal



--=20
=20

This message contains confidential information and is intended only for the=
=20
individual(s) named. If you are not the intended recipient, you are=20
notified that disclosing, copying, distributing or taking any action in=20
reliance on the contents of this mail and attached file/s is strictly=20
prohibited. Please notify the sender immediately and delete this e-mail=20
from your system. E-mail transmission cannot be guaranteed to be secured or=
=20
error-free as information could be intercepted, corrupted, lost, destroyed,=
=20
arrive late or incomplete, or contain viruses. The sender therefore does=20
not accept liability for any errors or omissions in the contents of this=20
message, which arise as a result of e-mail transmission.
