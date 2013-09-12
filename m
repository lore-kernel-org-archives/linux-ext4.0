From: Julian Andres Klode <jak@jak-linux.org>
Subject: Please help: Is ext4 counting trims as writes, or is something
 killing my SSD?
Date: Thu, 12 Sep 2013 16:18:56 +0200
Message-ID: <20130912141856.GA17640@jak-x230>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZGiS0Q5IWpPtfppv"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bk0-f42.google.com ([209.85.214.42]:47074 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab3ILOTB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Sep 2013 10:19:01 -0400
Received: by mail-bk0-f42.google.com with SMTP id my10so4311839bkb.1
        for <linux-ext4@vger.kernel.org>; Thu, 12 Sep 2013 07:19:00 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

I installed my new laptop on Saturday and setup an ext4 filesystem
on my / and /home partitions. Without me doing much file transfers,
I noticed today:

jak@jak-x230:~$ cat /sys/fs/ext4/sdb3/lifetime_write_kbytes=20
342614039

This is on a 100GB partition. I used fstrim multiple times. I analysed
the increase over some time today and issued an fstrim in between:

2013-09-12 15:53 341.582.779
2013-09-12 15:54 341.582.971
2013-09-12 15:58 341.583.103
2013-09-12 16:01 341.584.095
2013-09-12 16:04 341.584.475
2013-09-12 16:05 341.584.623	=09
	<fstrim -v /home =3D> /home/: 1052205056 bytes were trimmed>
2013-09-12 16:07 342.612.167
2013-09-12 16:08 342.612.323
2013-09-12 16:10 342.613.995
2013-09-12 16:11 342.614.039
2013-09-12 16:15 342.614.291
2013-09-12 16:16 342.614.475

So it seems that ext4 counts the trims as writes? I don't know how I could
get 300GB of writes on a 100GB partition -- of which only 8 GB are occupied
-- otherwise.

My smart values for my SSD are:

SMART Attributes Data Structure revision number: 1
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  =
WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x0003   100   100   070    Pre-fail  Always   =
    -       0
  5 Reallocated_Sector_Ct   0x0003   100   100   000    Pre-fail  Always   =
    -       0
  9 Power_On_Hours          0x0002   100   100   000    Old_age   Always   =
    -       23
 12 Power_Cycle_Count       0x0002   100   100   000    Old_age   Always   =
    -       37
177 Wear_Leveling_Count     0x0003   100   100   000    Pre-fail  Always   =
    -       465
178 Used_Rsvd_Blk_Cnt_Chip  0x0003   100   100   000    Pre-fail  Always   =
    -       0
181 Program_Fail_Cnt_Total  0x0003   100   100   000    Pre-fail  Always   =
    -       0
182 Erase_Fail_Count_Total  0x0003   100   100   000    Pre-fail  Always   =
    -       0
187 Reported_Uncorrect      0x0002   100   100   000    Old_age   Always   =
    -       0
192 Power-Off_Retract_Count 0x0003   100   100   000    Pre-fail  Always   =
    -       7
196 Reallocated_Event_Count 0x0003   100   100   000    Pre-fail  Always   =
    -       0
198 Offline_Uncorrectable   0x0003   100   100   000    Pre-fail  Always   =
    -       0
199 UDMA_CRC_Error_Count    0x0003   100   100   000    Pre-fail  Always   =
    -       0
232 Available_Reservd_Space 0x0003   100   100   010    Pre-fail  Always   =
    -       0
241 Total_LBAs_Written      0x0003   100   100   000    Pre-fail  Always   =
    -       1494
242 Total_LBAs_Read         0x0003   100   100   000    Pre-fail  Always   =
    -       1308

Do those still look OK?

Please help,

I don't know what happens here.
--=20
Julian Andres Klode  - Debian Developer, Ubuntu Member

See http://wiki.debian.org/JulianAndresKlode and http://jak-linux.org/.

--ZGiS0Q5IWpPtfppv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iEYEABECAAYFAlIxzVAACgkQrCpf/gCCPsLEtwCdFUwjY9rFzEv3wxjo/S8cjKpT
1l4Anjp8q+/sEHGASXUv9xiERVAJZNJ4
=KCe7
-----END PGP SIGNATURE-----

--ZGiS0Q5IWpPtfppv--
