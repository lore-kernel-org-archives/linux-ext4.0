From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25352] resizing ext4 will corrupt filesystem
Date: Thu, 30 Dec 2010 13:47:13 GMT
Message-ID: <201012301347.oBUDlD08013794@demeter2.kernel.org>
References: <bug-25352-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:48944 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247Ab0L3NrO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 30 Dec 2010 08:47:14 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id oBUDlD3E013795
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 30 Dec 2010 13:47:13 GMT
In-Reply-To: <bug-25352-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=3D25352


Martin Steigerwald <Martin@Lichtvoll.de> changed:

           What    |Removed                     |Added
-----------------------------------------------------------------------=
-----
                 CC|                            |Martin@Lichtvoll.de




--- Comment #12 from Martin Steigerwald <Martin@Lichtvoll.de>  2010-12-=
30 13:47:11 ---
I had a corrupted ext4 yesterday after I made a ThinkPad T42 BIOS updat=
e while
I just let the kernel hibernate. The kernel consequently oopsed after r=
esuming
after the BIOS update - well whether it did so consequently, but it did=
 it, I
made a screenshot of it, some ACPI related stuff AFAIR. Now I wonder wh=
ether it
was me wanting to save boot and uptime causing the issue or whether it =
was the
online resize a few days before - and I just didn't notice it cause act=
ually I
did not reboot since then before.

Can you have a short log at the following to see whether that might hav=
e been
the same online resizing issue? I'd just like to know what might have b=
een the
cause for that filesystem issue - cause I doubt that my risk based appr=
oach of
doing the BIOS update could have caused such a corruption. I will use t=
he
shutdown and reboot method on any subsequent BIOS updated anyway - that=
 much I
learned.

I already recovered by rsync'ing changed files to my backup as far as p=
ossible
and then redoing Ext4 from scratch with mkfs.ext4 and then restoring fr=
om
backup. I do not have the old state available anymore as I do not have =
a spare
220 GB to dd the filesystem to.

Thus I just like to know whether the following hints at this online res=
izing
issue or not. I have full output logs available on request. This is wit=
h:

martin@shambhala:~> cat /proc/version=20
Linux version 2.6.37-rc7-tp42-ata-eh-dbg-dirty (martin@shambhala) (gcc =
version
4.4.5 (Debian 4.4.5-8) ) #1 PREEMPT Wed Dec 22 11:41:20 CET 2010

Which is a plain 2.6.37-rc7 + a libata debug patch in order to get to t=
he cause
of bug #25392.

Here is some excerpt of fsck.ext4 output:

sh-4.1# fsck.ext4 -y /dev/shambhala/home=20
e2fsck 1.41.12 (17-May-2010)
home enth=C3=A4lt ein fehlerhaftes Dateisystem, Pr=C3=BCfung erzwungen.
Durchgang 1: Pr=C3=BCfe Inodes, Blocks, und Gr=C3=B6=C3=9Fen
Inode 13107224 hat Imagic-Flag gesetzt.  Bereinige? ja

HTREE Verzeichnis Inode 13107224 hat eine zu gro=C3=9Fe Verzeichnistief=
e von (0)
Repariere? ja

Inode 13107225 ist in Benutzung, aber hat dtime gesetzt.  Repariere? ja

Inode 13107225 hat Imagic-Flag gesetzt.  Bereinige? ja

HTREE Verzeichnis Inode 13107225 hat eine zu gro=C3=9Fe Verzeichnistief=
e von (0)
Repariere? ja

Inode 13107226 ist in Benutzung, aber hat dtime gesetzt.  Repariere? ja

Inode 13107226 hat Imagic-Flag gesetzt.  Bereinige? ja

HTREE Verzeichnis Inode 13107226 hat eine zu gro=C3=9Fe Verzeichnistief=
e von (0)
Repariere? ja

Inode 13107227 ist in Benutzung, aber hat dtime gesetzt.  Repariere? ja

Inode 13107227 hat Imagic-Flag gesetzt.  Bereinige? ja

HTREE Verzeichnis Inode 13107227 hat eine zu gro=C3=9Fe Verzeichnistief=
e von (0)
Repariere? ja

Inode 13107228 ist in Benutzung, aber hat dtime gesetzt.  Repariere? ja

Inode 13107228 hat Imagic-Flag gesetzt.  Bereinige? ja

HTREE Verzeichnis Inode 13107228 hat eine zu gro=C3=9Fe Verzeichnistief=
e von (0)
Repariere? ja

Inode 13107228 should not have EOFBLOCKS_FL set (size 71639278362328648=
23, lblk
-1)
Bereinige? ja

Inode 13107228, i_size ist 7163927836232864823, sollte sein 0.  Reparie=
re? ja

Inode 13107228, i_Blocks ist 54105622007074, sollte sein 0.  Repariere?=
 ja

Inode 13107229 ist in Benutzung, aber hat dtime gesetzt.  Repariere? ja



It took to long for me and I thought it the result wouldn't make sense =
anyway -
thus I aborted it:

Inode 13111740, i_size ist 3695299676852405555, sollte sein 0.  Reparie=
re? ja

Inode 13111740, i_Blocks ist 54353923893113, sollte sein 0.  Repariere?=
 ja

Inode 13111683^Ckomprimierenion Flag gesetzt auf Dateisystem ohne
komprimierenion Unterst=C3=BCtzung.  Bereinige? ja

Inode 13111683 hat unzul=C3=A4ssigen Block(s).  Bereinige? ja

Illegal(er) Block #Block Nr.0 (1377831437) in Inode 13111683.  BEREINIG=
T.
Illegal(er) Block #Block Nr.1 (1114388856) in Inode 13111683.  BEREINIG=
T.
Illegal(er) Block #Block Nr.2 (1432639345) in Inode 13111683.  BEREINIG=
T.
Illegal(er) Block #Block Nr.3 (1767001172) in Inode 13111683.  BEREINIG=
T.
Illegal(er) Block #Block Nr.4 (810839411) in Inode 13111683.  BEREINIGT=
=2E
Illegal(er) Block #Block Nr.5 (1869950832) in Inode 13111683.  BEREINIG=
T.
Illegal(er) Block #Block Nr.6 (1917276759) in Inode 13111683.  BEREINIG=
T.
Illegal(er) Block #Block Nr.7 (2051289946) in Inode 13111683.  BEREINIG=
T.
Illegal(er) Block #Block Nr.8 (1516727671) in Inode 13111683.  BEREINIG=
T.
Illegal(er) Block #Block Nr.9 (959854137) in Inode 13111683.  BEREINIGT=
=2E
Illegal(er) Block #Block Nr.10 (1951023915) in Inode 13111683.  BEREINI=
GT.
Zu viele unzul=C3=A4ssige Blocks in Inode 13111683.
Bereinige Inode? ja

home: e2fsck abgebrochhen.

home: ***** DATEISYSTEM WURDE VER=C3=84NDERT *****

home: ********** WARNUNG: Noch Fehler im Dateisystem  **********

This was from within a KNOPPIX 6.4.



Later on I tried my Debian Squeeze/Sid/Experimental installation, / was
unharmed - but also not resized so this might be a hint. This time it a=
borted
with a memory error:

Illegal(er) Block #Block Nr.11 (2155151360) in Inode 13203817.  BEREINI=
GT.
Illegal(er) Block #doppelt indirekte Bl=C3=B6cke (1460142208) in Inode =
13203817.=20
BEREINIGT.
Illegal(er) Block #Block Nr.11546678 (620001054) in Inode 13203817.  BE=
REINIGT.
Illegal(er) Block #Block Nr.11546679 (3841423132) in Inode 13203817.=20
BEREINIGT.
Illegal(er) Block #Block Nr.11546680 (2438523380) in Inode 13203817.=20
BEREINIGT.
Illegal(er) Block #Block Nr.11546681 (3656408572) in Inode 13203817.=20
BEREINIGT.
Zu viele unzul=C3=A4ssige Blocks in Inode 13203817.
Bereinige Inode? ja

Inode 13203847 hat defekten erweiterte Eigenschaft Block 1048576.  Bere=
inige?
ja

Inode 13203847 hat unzul=C3=A4ssigen Block(s).  Bereinige? ja

Illegal(er) Block #Block Nr.0 (184657162) in Inode 13203847.  BEREINIGT=
=2E
Illegal(er) Block #Block Nr.3 (3936944128) in Inode 13203847.  BEREINIG=
T.
Illegal(er) Block #Block Nr.5 (2836004992) in Inode 13203847.  BEREINIG=
T.
Illegal(er) Block #Block Nr.7 (1079508992) in Inode 13203847.  BEREINIG=
T.
Illegal(er) Block #Block Nr.9 (2903113856) in Inode 13203847.  BEREINIG=
T.
Illegal(er) Block #Block Nr.11 (2153250816) in Inode 13203847.  BEREINI=
GT.
Illegal(er) Block #doppelt indirekte Bl=C3=B6cke (2970222720) in Inode =
13203847.=20
BEREINIGT.
Illegal(er) Block #Block Nr.11546682 (1962632602) in Inode 13203847.=20
BEREINIGT.
=46ehler beim Speichern Verzeichnis Block Informationen (Inode=3D132038=
47, Block=3D0,
num=3D11018850): Memory allocation fae2fsck: abgebrochen=20


After this Ext4 was not mountable at all:

shambhala:~#8> mount /home
mount: wrong fs type, bad option, bad superblock on /dev/mapper/shambha=
la-home,
       missing codepage or helper program, or other error
       Manchmal liefert das Syslog wertvolle Informationen =E2=80=93 ve=
rsuchen
       Sie  dmesg | tail  oder so

#=20

I think it was this:

Dec 29 21:58:37 shambhala kernel: EXT4-fs (dm-1): ext4_check_descriptor=
s:
Checksum for group 0 failed (16277!=3D0)
Dec 29 21:58:37 shambhala kernel: EXT4-fs (dm-1): group descriptors cor=
rupted!
Dec 29 21:59:50 shambhala kernel: EXT4-fs (dm-1): warning: mounting unc=
hecked
fs, running e2fsck is recommended
Dec 29 21:59:50 shambhala kernel: EXT4-fs (dm-1): mounted filesystem wi=
th
ordered data mode. Opts: (null)

But in my case it actually didn't mount it - at least I thought so, cau=
se I saw
the error on the console.

I used fsck.ext4 again and canceled it right after it repaired those ch=
ecksums
it complained about in dmesg:

shambhala:~#32> fsck.ext4 -y /dev/shambhala/home

Pr=C3=BCfsumme von Gruppe -Deskriptor 1 ist ung=C3=BCltig.  REPARIERT.
Pr=C3=BCfsumme von Gruppe -Deskriptor 2 ist ung=C3=BCltig.  REPARIERT.
Pr=C3=BCfsumme von Gruppe -Deskriptor 3 ist ung=C3=BCltig.  REPARIERT.
Pr=C3=BCfsumme von Gruppe -Deskriptor 4 ist ung=C3=BCltig.  REPARIERT.
Pr=C3=BCfsumme von Gruppe -Deskriptor 5 ist ung=C3=BCltig.  REPARIERT.
Pr=C3=BCfsumme von Gruppe -Deskriptor 6 ist ung=C3=BCltig.  REPARIERT.
Pr=C3=BCfsumme von Gruppe -Deskriptor 7 ist ung=C3=BCltig.  REPARIERT.
Pr=C3=BCfsumme von Gruppe -Deskriptor 8 ist ung=C3=BCltig.  REPARIERT.
Pr=C3=BCfsumme von Gruppe -Deskriptor 9 ist ung=C3=BCltig.  REPARIERT.
Pr=C3=BCfsumme von Gruppe -Deskriptor 10 ist ung=C3=BCltig.  REPARIERT.
Pr=C3=BCfsumme von Gruppe -Deskriptor 11 ist ung=C3=BCltig.  REPARIERT.
Pr=C3=BCfsumme von Gruppe -Deskriptor 12 ist ung=C3=BCltig.  REPARIERT.
Pr=C3=BCfsumme von Gruppe -Deskriptor 13 ist ung=C3=BCltig.  REPARIERT.
Pr=C3=BCfsumme von Gruppe -Deskriptor 14 ist ung=C3=BCltig.  REPARIERT.
Pr=C3=BCfsumme von Gruppe -Deskriptor 15 ist ung=C3=BCltig.  REPARIERT.
Pr=C3=BCfsumme von Gruppe -Deskriptor 16 ist ung=C3=BCltig.  REPARIERT.
Pr=C3=BCfsumme von Gruppe -Deskriptor 17 ist ung=C3=BCltig.  REPARIERT.
Pr=C3=BCfsumme von Gruppe -Deskriptor 18 ist ung=C3=BCltig.  REPARIERT.
Pr=C3=BCfsumme von Gruppe -Deskriptor 19 ist ung=C3=BCltig.  REPARIERT.
Pr=C3=BCfsumme von Gruppe -Deskriptor 20 ist ung=C3=BCltig.  REPARIERT.
Pr=C3=BCfsumme von Gruppe -Deskriptor 21 ist ung=C3=BCltig.  REPARIERT.
Pr=C3=BCfsumme von Gruppe -Deskriptor 22 ist ung=C3=BCltig.  REPARIERT.
Pr=C3=BCfsumme von Gruppe -Deskriptor 23 ist ung=C3=BCltig.  REPARIERT.
Pr=C3=BCfsumme von Gruppe -Deskriptor 24 ist ung=C3=BCltig.  REPARIERT.
Pr=C3=BCfsumme von Gruppe -Deskriptor 25 ist ung=C3=BCltig.  REPARIERT.
Pr=C3=BCfsumme von Gruppe -Deskriptor 26 ist ung=C3=BCltig.  REPARIERT.
Pr=C3=BCfsumme von Gruppe -Deskriptor 27 ist ung=C3=BCltig.  REPARIERT.
Pr=C3=BCfsumme von Gruppe -Deskriptor 28 ist ung=C3=BCltig.  REPARIERT.
Pr=C3=BCfsumme von Gruppe -Deskriptor 29 ist ung=C3=BCltig.  REPARIERT.
Pr=C3=BCfsumme von Gruppe -Deskriptor 30 ist ung=C3=BCltig.  REPARIERT.
Pr=C3=BCfsumme von Gruppe -Deskriptor 31 ist ung=C3=BCltig.  REPARIERT.
Pr=C3=BCfsumme von Gruppe -Deskriptor 36 ist ung=C3=BCltig.  REPARIERT.
Pr=C3=BCfsumme von Gruppe -Deskriptor 37 ist ung=C3=BCltig.  REPARIERT.
Pr=C3=BCfsumme von Gruppe -Deskriptor 38 ist ung=C3=BCltig.  REPARIERT.
Pr=C3=BCfsumme von Gruppe -Deskriptor 39 ist ung=C3=BCltig.  REPARIERT.
Pr=C3=BCfsumme von Gruppe -Deskriptor 40 ist ung=C3=BCltig.  REPARIERT.
Pr=C3=BCfsumme von Gruppe -Deskriptor 256 ist ung=C3=BCltig.  REPARIERT=
=2E
Pr=C3=BCfsumme von Gruppe -Deskriptor 257 ist ung=C3=BCltig.  REPARIERT=
=2E
Pr=C3=BCfsumme von Gruppe -Deskriptor 258 ist ung=C3=BCltig.  REPARIERT=
=2E
Pr=C3=BCfsumme von Gruppe -Deskriptor 259 ist ung=C3=BCltig.  REPARIERT=
=2E
Pr=C3=BCfsumme von Gruppe -Deskriptor 260 ist ung=C3=BCltig.  REPARIERT=
=2E
Pr=C3=BCfsumme von Gruppe -Deskriptor 261 ist ung=C3=BCltig.  REPARIERT=
=2E
Pr=C3=BCfsumme von Gruppe -Deskriptor 262 ist ung=C3=BCltig.  REPARIERT=
=2E
Pr=C3=BCfsumme von Gruppe -Deskriptor 896 ist ung=C3=BCltig.  REPARIERT=
=2E
Pr=C3=BCfsumme von Gruppe -Deskriptor 897 ist ung=C3=BCltig.  REPARIERT=
=2E
Pr=C3=BCfsumme von Gruppe -Deskriptor 898 ist ung=C3=BCltig.  REPARIERT=
=2E
Pr=C3=BCfsumme von Gruppe -Deskriptor 262 ist ung=C3=BCltig.  REPARIERT=
=2E
Pr=C3=BCfsumme von Gruppe -Deskriptor 896 ist ung=C3=BCltig.  REPARIERT=
=2E
Pr=C3=BCfsumme von Gruppe -Deskriptor 897 ist ung=C3=BCltig.  REPARIERT=
=2E
Pr=C3=BCfsumme von Gruppe -Deskriptor 898 ist ung=C3=BCltig.  REPARIERT=
=2E
Pr=C3=BCfsumme von Gruppe -Deskriptor 899 ist ung=C3=BCltig.  REPARIERT=
=2E
home enth=C3=A4lt ein fehlerhaftes Dateisystem, Pr=C3=BCfung erzwungen.
Root Inode ist kein Verzeichnis.  Zur=C3=BCcksetzen? ja
Durchgang 1: Pr=C3=BCfe Inodes, Blocks, und Gr=C3=B6=C3=9Fen
^Chome: e2fsck abgebrochhen.

home: ***** DATEISYSTEM WURDE VER=C3=84NDERT *****

home: ********** WARNUNG: Noch Fehler im Dateisystem  **********

After this I was able to mount it. Then I did the rsync thing as I want=
ed to
save as much of my new data since the last backup as possible. Despite =
the long
fsck.ext4 outputs I think almost all of the new files are accessible.

Hmmm, it seems I had Ext4 issue prior to that BIOS update yesterday:

martin@shambhala:~> grep -i ext4 /var/log/syslog
Dec 27 11:45:27 shambhala kernel: EXT4-fs error (device dm-1):
ext4_mb_generate_buddy:726: group 160032766 blocks in bitmap, 32254 in =
gd
Dec 27 11:57:24 shambhala kernel: EXT4-fs error (device dm-1):
ext4_mb_generate_buddy:726: group 160132766 blocks in bitmap, 32254 in =
gd
Dec 29 13:59:36 shambhala kernel: EXT4-fs error (device dm-1):
ext4_mb_generate_buddy:726: group 160232766 blocks in bitmap, 32254 in =
gd
Dec 29 13:59:43 shambhala kernel: EXT4-fs error (device dm-1):
ext4_mb_generate_buddy:726: group 160332766 blocks in bitmap, 32254 in =
gd
Dec 29 13:59:54 shambhala kernel: EXT4-fs error (device dm-1):
ext4_mb_generate_buddy:726: group 160432766 blocks in bitmap, 32254 in =
gd
Dec 29 14:00:00 shambhala kernel: EXT4-fs error (device dm-1):
ext4_mb_generate_buddy:726: group 160532766 blocks in bitmap, 32254 in =
gd
Dec 29 14:00:09 shambhala kernel: EXT4-fs error (device dm-1):
ext4_mb_generate_buddy:726: group 160632766 blocks in bitmap, 32254 in =
gd
Dec 29 14:00:18 shambhala kernel: EXT4-fs error (device dm-1):
ext4_mb_generate_buddy:726: group 160732766 blocks in bitmap, 32254 in =
gd
Dec 29 14:00:40 shambhala kernel: EXT4-fs error (device dm-1):
ext4_mb_generate_buddy:726: group 160832766 blocks in bitmap, 32254 in =
gd
Dec 29 14:00:49 shambhala kernel: EXT4-fs error (device dm-1):
ext4_mb_generate_buddy:726: group 160932766 blocks in bitmap, 32254 in =
gd
Dec 29 14:00:55 shambhala kernel: EXT4-fs error (device dm-1):
ext4_mb_generate_buddy:726: group 161032766 blocks in bitmap, 32254 in =
gd
Dec 29 14:01:17 shambhala kernel: EXT4-fs error (device dm-1):
ext4_mb_generate_buddy:726: group 161132766 blocks in bitmap, 32254 in =
gd
Dec 29 14:01:26 shambhala kernel: EXT4-fs error (device dm-1):
ext4_mb_generate_buddy:726: group 161232766 blocks in bitmap, 32254 in =
gd
Dec 29 14:02:39 shambhala kernel: EXT4-fs error (device dm-1):
ext4_mb_generate_buddy:726: group 161332766 blocks in bitmap, 32254 in =
gd
Dec 29 14:05:48 shambhala kernel: EXT4-fs error (device dm-1):
ext4_mb_generate_buddy:726: group 161432766 blocks in bitmap, 32254 in =
gd
Dec 29 14:05:58 shambhala kernel: EXT4-fs error (device dm-1):
ext4_mb_generate_buddy:726: group 161532766 blocks in bitmap, 32254 in =
gd
Dec 29 21:51:57 shambhala kernel: EXT4-fs (dm-0): mounted filesystem wi=
th
ordered data mode. Opts: (null)
Dec 29 21:51:57 shambhala kernel: EXT4-fs (dm-0): re-mounted. Opts: (nu=
ll)
Dec 29 21:51:57 shambhala kernel: EXT4-fs (dm-0): re-mounted. Opts: (nu=
ll)
Dec 29 21:51:57 shambhala kernel: EXT4-fs (sda1): mounted filesystem wi=
th
ordered data mode. Opts: (null)
Dec 29 21:51:57 shambhala kernel: EXT4-fs (dm-1): warning: mounting fs =
with
errors, running e2fsck is recommended
Dec 29 21:51:57 shambhala kernel: EXT4-fs (dm-1): mounted filesystem wi=
th
ordered data mode. Opts: (null)
Dec 29 21:58:37 shambhala kernel: EXT4-fs (dm-1): ext4_check_descriptor=
s:
Checksum for group 0 failed (16277!=3D0)
Dec 29 21:58:37 shambhala kernel: EXT4-fs (dm-1): group descriptors cor=
rupted!
Dec 29 21:59:50 shambhala kernel: EXT4-fs (dm-1): warning: mounting unc=
hecked
fs, running e2fsck is recommended
Dec 29 21:59:50 shambhala kernel: EXT4-fs (dm-1): mounted filesystem wi=
th
ordered data mode. Opts: (null)
Dec 29 22:03:46 shambhala kernel: EXT4-fs (dm-2): warning: maximal moun=
t count
reached, running e2fsck is recommended
Dec 29 22:03:46 shambhala kernel: EXT4-fs (dm-2): mounted filesystem wi=
th
ordered data mode. Opts: (null)
Dec 29 22:04:50 shambhala kernel: EXT4-fs (dm-1): error count: 16
Dec 29 22:04:50 shambhala kernel: EXT4-fs (dm-1): initial error at 1293=
446727:
ext4_mb_generate_buddy:726
Dec 29 22:04:50 shambhala kernel: EXT4-fs (dm-1): last error at 1293627=
958:
ext4_mb_generate_buddy:726
Dec 29 22:06:20 shambhala kernel: EXT4-fs error (device dm-1): ext4_ige=
t:5011:
inode #8413041: comm rsync: bogus i_mode (0)
Dec 29 22:06:20 shambhala kernel: EXT4-fs error (device dm-1): ext4_ige=
t:5011:
inode #8413441: comm rsync: bogus i_mode (0)
Dec 29 22:06:20 shambhala kernel: EXT4-fs error (device dm-1): ext4_ige=
t:5011:
inode #8413457: comm rsync: bogus i_mode (0)
Dec 29 22:06:20 shambhala kernel: EXT4-fs error (device dm-1): ext4_ige=
t:5011:
inode #8414273: comm rsync: bogus i_mode (0)
Dec 29 22:06:21 shambhala kernel: EXT4-fs error (device dm-1): ext4_ige=
t:5011:
inode #8415857: comm rsync: bogus i_mode (0)
Dec 29 22:06:21 shambhala kernel: EXT4-fs error (device dm-1): ext4_ige=
t:5011:
inode #8415873: comm rsync: bogus i_mode (0)
Dec 29 22:06:21 shambhala kernel: EXT4-fs error (device dm-1): ext4_ige=
t:5011:
inode #8415969: comm rsync: bogus i_mode (0)
Dec 29 22:06:21 shambhala kernel: EXT4-fs error (device dm-1): ext4_ige=
t:5011:
inode #8416609: comm rsync: bogus i_mode (0)
Dec 29 22:06:21 shambhala kernel: EXT4-fs error (device dm-1): ext4_ige=
t:5011:
inode #8416817: comm rsync: bogus i_mode (0)
Dec 29 22:06:21 shambhala kernel: EXT4-fs error (device dm-1): ext4_ige=
t:5011:
inode #8417601: comm rsync: bogus i_mode (0)
Dec 29 22:06:22 shambhala kernel: EXT4-fs error (device dm-1): ext4_ige=
t:5011:
inode #8419809: comm rsync: bogus i_mode (0)
Dec 29 22:06:22 shambhala kernel: EXT4-fs error (device dm-1): ext4_ige=
t:5011:
inode #8420097: comm rsync: bogus i_mode (0)
Dec 29 22:06:22 shambhala kernel: EXT4-fs error (device dm-1): ext4_ige=
t:5011:
inode #8421009: comm rsync: bogus i_mode (0)
Dec 29 22:07:14 shambhala kernel: EXT4-fs error (device dm-1): ext4_ige=
t:5011:
inode #8413041: comm rsync: bogus i_mode (0)
Dec 29 22:07:14 shambhala kernel: EXT4-fs error (device dm-1): ext4_ige=
t:5011:
inode #8413441: comm rsync: bogus i_mode (0)
Dec 29 22:07:14 shambhala kernel: EXT4-fs error (device dm-1): ext4_ige=
t:5011:
inode #8413457: comm rsync: bogus i_mode (0)
Dec 29 22:07:14 shambhala kernel: EXT4-fs error (device dm-1): ext4_ige=
t:5011:
inode #8414273: comm rsync: bogus i_mode (0)
Dec 29 22:07:15 shambhala kernel: EXT4-fs error (device dm-1): ext4_ige=
t:5011:
inode #8415857: comm rsync: bogus i_mode (0)
Dec 29 22:07:15 shambhala kernel: EXT4-fs error (device dm-1): ext4_ige=
t:5011:
inode #8415873: comm rsync: bogus i_mode (0)
Dec 29 22:07:15 shambhala kernel: EXT4-fs error (device dm-1): ext4_ige=
t:5011:
inode #8415969: comm rsync: bogus i_mode (0)
Dec 29 22:07:15 shambhala kernel: EXT4-fs error (device dm-1): ext4_ige=
t:5011:
inode #8416609: comm rsync: bogus i_mode (0)
Dec 29 22:07:15 shambhala kernel: EXT4-fs error (device dm-1): ext4_ige=
t:5011:
inode #8416817: comm rsync: bogus i_mode (0)
Dec 29 22:07:15 shambhala kernel: EXT4-fs error (device dm-1): ext4_ige=
t:5011:
inode #8417601: comm rsync: bogus i_mode (0)
Dec 29 22:07:15 shambhala kernel: EXT4-fs error (device dm-1): ext4_ige=
t:5011:
inode #8419809: comm rsync: bogus i_mode (0)
Dec 29 22:07:15 shambhala kernel: EXT4-fs error (device dm-1): ext4_ige=
t:5011:
inode #8420097: comm rsync: bogus i_mode (0)
Dec 29 22:07:15 shambhala kernel: EXT4-fs error (device dm-1): ext4_ige=
t:5011:
inode #8421009: comm rsync: bogus i_mode (0)
Dec 29 22:07:42 shambhala kernel: EXT4-fs error (device dm-1): ext4_ige=
t:5011:
inode #1049089: comm rsync: bogus i_mode (0)
Dec 29 22:08:09 shambhala kernel: EXT4-fs error (device dm-1): ext4_ige=
t:5011:
inode #8408817: comm rsync: bogus i_mode (0)
Dec 29 22:08:09 shambhala kernel: EXT4-fs error (device dm-1): ext4_ige=
t:5011:
inode #8408881: comm rsync: bogus i_mode (0)
Dec 29 22:08:10 shambhala kernel: EXT4-fs error (device dm-1): ext4_ige=
t:5011:
inode #8409441: comm rsync: bogus i_mode (0)
Dec 29 22:08:10 shambhala kernel: EXT4-fs error (device dm-1): ext4_ige=
t:5011:
inode #8409505: comm rsync: bogus i_mode (0)
Dec 29 22:08:10 shambhala kernel: EXT4-fs error (device dm-1): ext4_ige=
t:5011:
inode #8411265: comm rsync: bogus i_mode (0)
Dec 29 22:08:46 shambhala kernel: EXT4-fs error (device dm-1): ext4_ige=
t:5011:
inode #2633361: comm rsync: bogus i_mode (0)
Dec 29 22:09:27 shambhala kernel: EXT4-fs error (device dm-1): ext4_ige=
t:5011:
inode #8433233: comm rsync: bogus i_mode (0)
Dec 29 22:23:12 shambhala kernel: EXT4-fs error (device dm-1): ext4_ige=
t:5011:
inode #8413041: comm rsync: bogus i_mode (0)
Dec 29 22:23:12 shambhala kernel: EXT4-fs error (device dm-1): ext4_ige=
t:5011:
inode #8413441: comm rsync: bogus i_mode (0)
Dec 29 22:23:12 shambhala kernel: EXT4-fs error (device dm-1): ext4_ige=
t:5011:
inode #8413457: comm rsync: bogus i_mode (0)
Dec 29 22:23:13 shambhala kernel: EXT4-fs error (device dm-1): ext4_ige=
t:5011:
inode #8414273: comm rsync: bogus i_mode (0)
Dec 29 22:23:13 shambhala kernel: EXT4-fs error (device dm-1): ext4_ige=
t:5011:
inode #8415857: comm rsync: bogus i_mode (0)
Dec 29 22:23:13 shambhala kernel: EXT4-fs error (device dm-1): ext4_ige=
t:5011:
inode #8415873: comm rsync: bogus i_mode (0)
Dec 29 22:23:13 shambhala kernel: EXT4-fs error (device dm-1): ext4_ige=
t:5011:
inode #8415969: comm rsync: bogus i_mode (0)
Dec 29 22:23:13 shambhala kernel: EXT4-fs error (device dm-1): ext4_ige=
t:5011:
inode #8416609: comm rsync: bogus i_mode (0)
Dec 29 22:23:13 shambhala kernel: EXT4-fs error (device dm-1): ext4_ige=
t:5011:
inode #8416817: comm rsync: bogus i_mode (0)
Dec 29 22:23:14 shambhala kernel: EXT4-fs error (device dm-1): ext4_ige=
t:5011:
inode #8417601: comm rsync: bogus i_mode (0)
Dec 29 22:23:15 shambhala kernel: EXT4-fs error (device dm-1): ext4_ige=
t:5011:
inode #8419809: comm rsync: bogus i_mode (0)
Dec 29 22:23:15 shambhala kernel: EXT4-fs error (device dm-1): ext4_ige=
t:5011:
inode #8420097: comm rsync: bogus i_mode (0)
Dec 29 22:23:15 shambhala kernel: EXT4-fs error (device dm-1): ext4_ige=
t:5011:
inode #8421009: comm rsync: bogus i_mode (0)
Dec 29 22:29:52 shambhala kernel: EXT4-fs error (device dm-1): ext4_ige=
t:5011:
inode #1049089: comm rsync: bogus i_mode (0)
Dec 29 22:32:37 shambhala kernel: EXT4-fs error (device dm-1): ext4_ige=
t:5011:
inode #8408817: comm rsync: bogus i_mode (0)
Dec 29 22:32:40 shambhala kernel: EXT4-fs error (device dm-1): ext4_ige=
t:5011:
inode #8408881: comm rsync: bogus i_mode (0)
Dec 29 22:33:29 shambhala kernel: EXT4-fs error (device dm-1): ext4_ige=
t:5011:
inode #8409441: comm rsync: bogus i_mode (0)
Dec 29 22:33:32 shambhala kernel: EXT4-fs error (device dm-1): ext4_ige=
t:5011:
inode #8409505: comm rsync: bogus i_mode (0)
Dec 29 22:33:43 shambhala kernel: EXT4-fs error (device dm-1): ext4_ige=
t:5011:
inode #8411265: comm rsync: bogus i_mode (0)
Dec 29 22:38:10 shambhala kernel: EXT4-fs error (device dm-1): ext4_ige=
t:5011:
inode #2633361: comm rsync: bogus i_mode (0)
Dec 29 22:41:30 shambhala kernel: EXT4-fs error (device dm-1): ext4_ige=
t:5011:
inode #8433233: comm rsync: bogus i_mode (0)
Dec 29 22:49:38 shambhala kernel: EXT4-fs (dm-1): mounted filesystem wi=
th
ordered data mode. Opts: (null)
Dec 29 23:00:22 shambhala kernel: EXT4-fs (dm-4): mounted filesystem wi=
th
ordered data mode. Opts: (null)
Dec 29 23:00:22 shambhala 50mounted-tests: debug: mounted as ext4 files=
ystem
Dec 29 23:00:22 shambhala kernel: EXT4-fs (dm-3): mounted filesystem wi=
th
ordered data mode. Opts: (null)
Dec 29 23:00:22 shambhala 50mounted-tests: debug: mounted as ext4 files=
ystem
Dec 30 10:20:14 shambhala kernel: EXT4-fs (dm-1): mounted filesystem wi=
th
ordered data mode. Opts: (null)
Dec 30 10:22:23 shambhala kernel: EXT4-fs (dm-0): mounted filesystem wi=
th
ordered data mode. Opts: (null)
Dec 30 10:22:23 shambhala kernel: EXT4-fs (dm-0): re-mounted. Opts: (nu=
ll)
Dec 30 10:22:23 shambhala kernel: EXT4-fs (dm-0): re-mounted. Opts: (nu=
ll)
Dec 30 10:22:23 shambhala kernel: EXT4-fs (sda1): mounted filesystem wi=
th
ordered data mode. Opts: (null)
Dec 30 10:22:23 shambhala kernel: EXT4-fs (dm-1): mounted filesystem wi=
th
ordered data mode. Opts: (null)
Dec 30 12:11:57 shambhala kernel: EXT4-fs (dm-0): mounted filesystem wi=
th
ordered data mode. Opts: (null)
Dec 30 12:11:57 shambhala kernel: EXT4-fs (dm-0): re-mounted. Opts: (nu=
ll)
Dec 30 12:11:57 shambhala kernel: EXT4-fs (dm-0): re-mounted. Opts: (nu=
ll)
Dec 30 12:11:57 shambhala kernel: EXT4-fs (sda1): mounted filesystem wi=
th
ordered data mode. Opts: (null)
Dec 30 12:11:57 shambhala kernel: EXT4-fs (dm-1): mounted filesystem wi=
th
ordered data mode. Opts: (null)
Dec 30 12:16:05 shambhala kernel: EXT4-fs (dm-2): warning: maximal moun=
t count
reached, running e2fsck is recommended
Dec 30 12:16:05 shambhala kernel: EXT4-fs (dm-2): mounted filesystem wi=
th
ordered data mode. Opts: (null)

Jup, 27th of December. Thats exactly when I enlarged /home by 20 GB.

I found some other issues on the way: Recovery mode of my Debian instal=
lation
did not work: On each keypress to enter my password it showed the passw=
ort
prompt again.

All in all this didn't raise my confidence in the stability of Ext4 esp=
ecially
as fsck.ext4 did not even complete due to a failed memory allocation. T=
hus is
seems 2 GB of RAM and 4 GB of RAM does not seem to be enough to fsck my=
 220GB
/home in some occasions at least.

I used Ext4 again nonetheless, as I do not yet want to use btrfs for /h=
ome on
my main notebook.

--=20
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=3Demai=
l
------- You are receiving this mail because: -------
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
