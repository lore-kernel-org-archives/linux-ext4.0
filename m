From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 50021] New: ext4 discard option not working on journal
 dissabled filesystem
Date: Sat,  3 Nov 2012 23:22:13 +0000 (UTC)
Message-ID: <bug-50021-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:37222 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751184Ab2KCXWS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 3 Nov 2012 19:22:18 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 6D36A20208
	for <linux-ext4@vger.kernel.org>; Sat,  3 Nov 2012 23:22:15 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 0E866201EF
	for <linux-ext4@vger.kernel.org>; Sat,  3 Nov 2012 23:22:14 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=3D50021

           Summary: ext4 discard option not working on journal dissable=
d
                    filesystem
           Product: File System
           Version: 2.5
    Kernel Version: 3.6.5
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: ninex@o2.pl
        Regression: No


naranek / # cat /proc/mounts|grep root
/dev/root / ext4 rw,noatime,nodiratime,discard,errors=3Dremount-ro 0 0

naranek / # dd if=3D/dev/urandom of=3D/testfile bs=3D1023k count=3D64
64+0 przeczytanych record=C3=B3w
64+0 zapisanych record=C3=B3w
skopiowane 67043328 bajt=C3=B3w (67 MB), 6,96422 s, 9,6 MB/s
naranek / # sync
naranek / # hdparm --fibmap /testfile

/testfile:
 filesystem blocksize 4096, begins at LBA 411648; assuming 512 byte sec=
tors.
 byte_offset  begin_LBA    end_LBA    sectors
           0  118917120  119048063     130944
naranek / # hdparm --read-sector 118917120 /dev/sda

/dev/sda:
reading sector 118917120: succeeded
021e 5507 7684 f2b7 c425 dbb7 3703 054c
c348 a9d5 f811 0269 9ec0 b620 9d9a 39ee
00ee 00ca 9012 2e2b 922e 555b da3e 4324
c5cf 0979 dc1e 9450 ca2d a5bf ae61 9dbf
6216 bd2e 18fc 4043 7cb8 5c47 1f0b a3e7
e177 ae3e 81cb 6499 c073 5a99 1f83 cd54
c34b e7fc 54bb 2ce7 7263 632d 9410 3f09
6ff4 9c1f 9650 d83b 33ac e237 f4db 600f
5950 356b 69c6 a4ca c696 9935 3f4f 469e
282e 6c5b edc9 416c 846a de55 8f1d 7d62
3403 00a9 8d3c 53f7 1e0f 1b0a 8ca9 c242
8da8 e383 81a8 d29a 8b33 e094 5cda 34d2
b1fc 28b7 d247 41b3 4048 46c1 fd00 5674
e6b5 5a4e d5ab d742 8639 630e d7db 9a02
efa3 b448 eb12 582e a815 65b5 8568 5eb1
d304 b097 4025 837a 2e02 9deb 4a65 c623
e308 4d31 8765 7a36 7d17 942e 612b 05a0
61f8 68d3 ff63 c66f d9a9 f699 bce3 334a
eb59 f003 06b5 3e6b 877c 9758 446d bed8
b2a1 9d02 5bf8 c38f 24c5 712f 37d8 2a3c
388c 27e1 ab0a 0a4b 4fc4 9ba7 7086 1d7e
add4 af87 8d6e 2269 73b7 7647 06ff b05b
75ea d82b 9763 cee5 4cb2 1211 8be7 10d5
3c1f af52 c90d fe9b 3a51 a1f5 7bbe 4617
4dfb 6c50 03d6 b373 5c39 7e91 6202 d610
1e42 7cd9 8899 33e4 f0fa ab8f 7143 5d4f
f5ee 40cf 1366 0bfc 853c 0c6e 7c84 05f7
f436 1da1 04b6 538f cca4 cb39 ce4e f70a
2e5d 2be1 7098 8118 5985 fb79 9125 f928
9f8d a0d8 ae2d 7af6 5eb8 4e1d c24f 4701
cfc7 e80c d052 3030 973e b4a7 7fa1 f2a7
479e 48b1 4fd4 4853 ef04 4c54 790a 2165
naranek / # rm testfile=20
naranek / # sync
naranek / # hdparm --read-sector 118917120 /dev/sda

/dev/sda:
reading sector 118917120: succeeded
021e 5507 7684 f2b7 c425 dbb7 3703 054c
c348 a9d5 f811 0269 9ec0 b620 9d9a 39ee
00ee 00ca 9012 2e2b 922e 555b da3e 4324
c5cf 0979 dc1e 9450 ca2d a5bf ae61 9dbf
6216 bd2e 18fc 4043 7cb8 5c47 1f0b a3e7
e177 ae3e 81cb 6499 c073 5a99 1f83 cd54
c34b e7fc 54bb 2ce7 7263 632d 9410 3f09
6ff4 9c1f 9650 d83b 33ac e237 f4db 600f
5950 356b 69c6 a4ca c696 9935 3f4f 469e
282e 6c5b edc9 416c 846a de55 8f1d 7d62
3403 00a9 8d3c 53f7 1e0f 1b0a 8ca9 c242
8da8 e383 81a8 d29a 8b33 e094 5cda 34d2
b1fc 28b7 d247 41b3 4048 46c1 fd00 5674
e6b5 5a4e d5ab d742 8639 630e d7db 9a02
efa3 b448 eb12 582e a815 65b5 8568 5eb1
d304 b097 4025 837a 2e02 9deb 4a65 c623
e308 4d31 8765 7a36 7d17 942e 612b 05a0
61f8 68d3 ff63 c66f d9a9 f699 bce3 334a
eb59 f003 06b5 3e6b 877c 9758 446d bed8
b2a1 9d02 5bf8 c38f 24c5 712f 37d8 2a3c
388c 27e1 ab0a 0a4b 4fc4 9ba7 7086 1d7e
add4 af87 8d6e 2269 73b7 7647 06ff b05b
75ea d82b 9763 cee5 4cb2 1211 8be7 10d5
3c1f af52 c90d fe9b 3a51 a1f5 7bbe 4617
4dfb 6c50 03d6 b373 5c39 7e91 6202 d610
1e42 7cd9 8899 33e4 f0fa ab8f 7143 5d4f
f5ee 40cf 1366 0bfc 853c 0c6e 7c84 05f7
f436 1da1 04b6 538f cca4 cb39 ce4e f70a
2e5d 2be1 7098 8118 5985 fb79 9125 f928
9f8d a0d8 ae2d 7af6 5eb8 4e1d c24f 4701
cfc7 e80c d052 3030 973e b4a7 7fa1 f2a7
479e 48b1 4fd4 4853 ef04 4c54 790a 2165



# now same test with journal
naranek / # tune2fs -O has_journal /dev/sda2
tune2fs 1.42.6 (21-Sep-2012)
Tworzenie i-w=C4=99z=C5=82a kroniki: wykonano
# reboot



naranek ~ # dd if=3D/dev/urandom of=3D/testfile bs=3D1023k count=3D64
64+0 przeczytanych record=C3=B3w                                       =
             =20
64+0 zapisanych record=C3=B3w                                          =
             =20
skopiowane 67043328 bajt=C3=B3w (67 MB), 6,94757 s, 9,6 MB/s           =
             =20
naranek ~ # sync
naranek ~ #  hdparm --fibmap /testfile=20

/testfile:                                                             =
        =20
 filesystem blocksize 4096, begins at LBA 411648; assuming 512 byte sec=
tors.   =20
 byte_offset  begin_LBA    end_LBA    sectors                          =
        =20
           0    4982784    4999167      16384                          =
        =20
     8388608    5064704    5130239      65536                          =
        =20
    41943040    9127936    9160703      32768                          =
        =20
    58720256    9062400    9078655      16256                          =
        =20
naranek ~ # hdparm --read-sector 4982784 /dev/sda

/dev/sda:                                                              =
        =20
reading sector 4982784: succeeded                                      =
        =20
fa73 1465 e2b0 87d0 eb96 3545 303a 1c49                                =
        =20
f43c 5994 d35b 3a72 c601 94da 4190 359a                                =
        =20
f3a8 746d e7ec 1749 6801 9263 0896 6e0a                                =
        =20
172d b430 e364 689f 594a 27d3 8983 687b                                =
        =20
c99b a447 b9c0 62c2 60c3 ddf5 727b 3f9e                                =
        =20
6b7a 480f 8480 bc90 a537 379c 5cf7 6baa                                =
        =20
9e7f f670 d8da 23e0 5027 508c d24a 2299                                =
        =20
9a0a d9c1 a64a 4986 01e6 18d0 b9df 8479                                =
        =20
ea40 3b94 3fe2 f6e8 846c 78ff cbc8 1bf5                                =
        =20
cda1 1176 ff74 7e21 3e9f f4ee c072 8389                                =
        =20
80f7 1e81 f64d 0553 e30f 7a91 5e0b e961                                =
        =20
23c4 147b e23d 89e9 a504 2d0d 6f7b d86a                                =
        =20
10db fb99 c951 bfd0 e88b bd4c 6d86 ac4a                                =
        =20
c90c ba2c 73de d6e1 d826 4d08 83a8 06b7                                =
        =20
f716 c7ab 02f7 c641 07c5 ad9a b3d7 fa59                                =
        =20
a844 ac2e a42b fd45 8bb5 af69 7d0e 03ce                                =
        =20
09ad 8ba9 b824 76a7 2f07 fd60 69b5 edd7                                =
        =20
2c52 cc12 db13 63b0 d120 1155 e63d 090d                                =
        =20
45fe 43ca 80a0 9569 f759 d029 57f1 f363                                =
        =20
984b 6d00 0fda ff93 05ac 8537 e01e 3aef                                =
        =20
e1db 42fe 69a8 9c8d 2142 d687 17b1 5808
ad21 e6af 3e94 f204 e283 7528 1bec 1260
723c fee6 35c5 09c4 c79b 7d14 c571 723a
4117 3496 3c60 7624 ca53 63fd d5f6 d545
cd56 c347 4905 380d ca13 2387 0ab9 1e23
4dc5 b0ef e9c5 ab40 ad78 876c 66cd 15ae
311e 8a1e 54b9 3bb3 7b2c 10a5 545b 8932
196e a160 bce6 353a 3324 0b21 9ac2 e588
0a76 3b3c 5f53 d0b4 0699 3edb 3de7 e1b4
21a2 26b1 5d17 53a5 4155 a376 ac4f b909
0f74 8e99 0480 508d 6f6c 49e7 b5f2 063f
425b f138 95dc 5d9f 4ab5 0888 cd0f 20d4
naranek ~ # rm /testfile=20
naranek ~ # sync
naranek ~ # hdparm --read-sector 4982784 /dev/sda

/dev/sda:
reading sector 4982784: succeeded
ffff ffff ffff ffff ffff ffff ffff ffff
ffff ffff ffff ffff ffff ffff ffff ffff
ffff ffff ffff ffff ffff ffff ffff ffff
ffff ffff ffff ffff ffff ffff ffff ffff
ffff ffff ffff ffff ffff ffff ffff ffff
ffff ffff ffff ffff ffff ffff ffff ffff
ffff ffff ffff ffff ffff ffff ffff ffff
ffff ffff ffff ffff ffff ffff ffff ffff
ffff ffff ffff ffff ffff ffff ffff ffff
ffff ffff ffff ffff ffff ffff ffff ffff
ffff ffff ffff ffff ffff ffff ffff ffff
ffff ffff ffff ffff ffff ffff ffff ffff
ffff ffff ffff ffff ffff ffff ffff ffff
ffff ffff ffff ffff ffff ffff ffff ffff
ffff ffff ffff ffff ffff ffff ffff ffff
ffff ffff ffff ffff ffff ffff ffff ffff
ffff ffff ffff ffff ffff ffff ffff ffff
ffff ffff ffff ffff ffff ffff ffff ffff
ffff ffff ffff ffff ffff ffff ffff ffff
ffff ffff ffff ffff ffff ffff ffff ffff
ffff ffff ffff ffff ffff ffff ffff ffff
ffff ffff ffff ffff ffff ffff ffff ffff
ffff ffff ffff ffff ffff ffff ffff ffff
ffff ffff ffff ffff ffff ffff ffff ffff
ffff ffff ffff ffff ffff ffff ffff ffff
ffff ffff ffff ffff ffff ffff ffff ffff
ffff ffff ffff ffff ffff ffff ffff ffff
ffff ffff ffff ffff ffff ffff ffff ffff
ffff ffff ffff ffff ffff ffff ffff ffff
ffff ffff ffff ffff ffff ffff ffff ffff
ffff ffff ffff ffff ffff ffff ffff ffff
ffff ffff ffff ffff ffff ffff ffff ffff
naranek ~ #

--=20
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=3Demai=
l
------- You are receiving this mail because: -------
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
