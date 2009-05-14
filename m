From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13292] ext4 without journal reproductible file corruption
Date: Thu, 14 May 2009 14:14:01 GMT
Message-ID: <200905141414.n4EEE1QQ000441@demeter.kernel.org>
References: <bug-13292-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:43972 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755186AbZENOOA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 May 2009 10:14:00 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n4EEE1da000442
	for <linux-ext4@vger.kernel.org>; Thu, 14 May 2009 14:14:01 GMT
In-Reply-To: <bug-13292-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=3D13292





--- Comment #2 from Thibault Mondary <thibm@free.fr>  2009-05-14 14:14:=
01 ---
(In reply to comment #1)
I'am starting from a locale "fr_FR@euro" on my system.


Output WITHOUT journal :

root@ubuntu ~# mount archlinux_64_minimal_ext4_without_journal.img /mnt=
/loop -o
loop
root@ubuntu ~# chroot /mnt/loop

bash-3.2# locale-gen
Generating locales...
  fr_FR.UTF-8... done
  fr_FR.ISO-8859-1... done
  fr_FR.ISO-8859-15@euro... done
Generation complete.

bash-3.2# locale
LANG=3Dfr_FR@euro
LC_CTYPE=3D"fr_FR@euro"
LC_NUMERIC=3D"fr_FR@euro"
LC_TIME=3D"fr_FR@euro"
LC_COLLATE=3D"fr_FR@euro"
LC_MONETARY=3D"fr_FR@euro"
LC_MESSAGES=3D"fr_FR@euro"
LC_PAPER=3D"fr_FR@euro"
LC_NAME=3D"fr_FR@euro"
LC_ADDRESS=3D"fr_FR@euro"
LC_TELEPHONE=3D"fr_FR@euro"
LC_MEASUREMENT=3D"fr_FR@euro"
LC_IDENTIFICATION=3D"fr_FR@euro"
LC_ALL=3D

bash-3.2# exit
root@ubuntu:~# umount /mnt/loop

root@ubuntu:~# mount archlinux_64_minimal_ext4_without_journal.img /mnt=
/loop -o
loop
root@ubuntu ~# chroot /mnt/loop

********BEGINNING OF THE PROBLEM : locales are normally generated from =
previous
mount**********

bash-3.2# locale
locale: Cannot set LC_CTYPE to default locale: No such file or director=
y
locale: Cannot set LC_MESSAGES to default locale: No such file or direc=
tory
locale: Cannot set LC_ALL to default locale: No such file or directory
LANG=3Dfr_FR@euro
LC_CTYPE=3D"fr_FR@euro"
LC_NUMERIC=3D"fr_FR@euro"
LC_TIME=3D"fr_FR@euro"
LC_COLLATE=3D"fr_FR@euro"
LC_MONETARY=3D"fr_FR@euro"
LC_MESSAGES=3D"fr_FR@euro"
LC_PAPER=3D"fr_FR@euro"
LC_NAME=3D"fr_FR@euro"
LC_ADDRESS=3D"fr_FR@euro"
LC_TELEPHONE=3D"fr_FR@euro"
LC_MEASUREMENT=3D"fr_FR@euro"
LC_IDENTIFICATION=3D"fr_FR@euro"
LC_ALL=3D

bash-3.2# LANG=3Dfr_FR
bash-3.2# locale
locale: Cannot set LC_CTYPE to default locale: No such file or director=
y
locale: Cannot set LC_MESSAGES to default locale: No such file or direc=
tory
locale: Cannot set LC_ALL to default locale: No such file or directory
LANG=3Dfr_FR
LC_CTYPE=3D"fr_FR"
LC_NUMERIC=3D"fr_FR"
LC_TIME=3D"fr_FR"
LC_COLLATE=3D"fr_FR"
LC_MONETARY=3D"fr_FR"
LC_MESSAGES=3D"fr_FR"
LC_PAPER=3D"fr_FR"
LC_NAME=3D"fr_FR"
LC_ADDRESS=3D"fr_FR"
LC_TELEPHONE=3D"fr_FR"
LC_MEASUREMENT=3D"fr_FR"
LC_IDENTIFICATION=3D"fr_FR"
LC_ALL=3D

**********END************


*************VERSION 2 : adding a journal to the image ************

root@ubuntu:~# tune2fs -O has_journal
archlinux_64_minimal_ext4_without_journal.img
tune2fs 1.41.4 (27-Jan-2009)
Cr=C3=A9ation de l'i-noeud du journal=C2=A0: compl=C3=A9t=C3=A9
Le syst=C3=A8me de fichiers sera automatiquement v=C3=A9rifi=C3=A9 tous=
 les 39 montages ou
apr=C3=A8s 180 jours, selon la premi=C3=A8re =C3=A9ventualit=C3=A9. Uti=
liser tune2fs -c ou -i
pour =C3=A9craser la valeur.

root@ubuntu:~# e2fsck -f archlinux_64_minimal_ext4_without_journal.img
e2fsck 1.41.4 (27-Jan-2009)
Passe=C2=A01=C2=A0: v=C3=A9rification des i-noeuds, des blocs et des ta=
illes
Passe 2=C2=A0: v=C3=A9rification de la structure des r=C3=A9pertoires
Passe=C2=A03=C2=A0: v=C3=A9rification de la connectivit=C3=A9 des r=C3=A9=
pertoires
Passe 4=C2=A0: v=C3=A9rification des compteurs de r=C3=A9f=C3=A9rence
Passe 5=C2=A0: v=C3=A9rification de l'information du sommaire de groupe
archlinux_64_minimal_ext4_without_journal.img=C2=A0: 21848/65536 fichie=
rs (0.1%
nontigus), 86608/262144 blocs

root@ubuntu:~# mount archlinux_64_minimal_ext4_without_journal.img /mnt=
/loop -o
loop
root@ubuntu:~# chroot /mnt/loop

bash-3.2# locale
locale: Cannot set LC_CTYPE to default locale: No such file or director=
y
locale: Cannot set LC_MESSAGES to default locale: No such file or direc=
tory
locale: Cannot set LC_ALL to default locale: No such file or directory
LANG=3Dfr_FR@euro
LC_CTYPE=3D"fr_FR@euro"
LC_NUMERIC=3D"fr_FR@euro"
LC_TIME=3D"fr_FR@euro"
LC_COLLATE=3D"fr_FR@euro"
LC_MONETARY=3D"fr_FR@euro"
LC_MESSAGES=3D"fr_FR@euro"
LC_PAPER=3D"fr_FR@euro"
LC_NAME=3D"fr_FR@euro"
LC_ADDRESS=3D"fr_FR@euro"
LC_TELEPHONE=3D"fr_FR@euro"
LC_MEASUREMENT=3D"fr_FR@euro"
LC_IDENTIFICATION=3D"fr_FR@euro"
LC_ALL=3D

bash-3.2# locale-gen
Generating locales...
  fr_FR.UTF-8... done
  fr_FR.ISO-8859-1... done
  fr_FR.ISO-8859-15@euro... done
Generation complete.

bash-3.2# locale
LANG=3Dfr_FR@euro
LC_CTYPE=3D"fr_FR@euro"
LC_NUMERIC=3D"fr_FR@euro"
LC_TIME=3D"fr_FR@euro"
LC_COLLATE=3D"fr_FR@euro"
LC_MONETARY=3D"fr_FR@euro"
LC_MESSAGES=3D"fr_FR@euro"
LC_PAPER=3D"fr_FR@euro"
LC_NAME=3D"fr_FR@euro"
LC_ADDRESS=3D"fr_FR@euro"
LC_TELEPHONE=3D"fr_FR@euro"
LC_MEASUREMENT=3D"fr_FR@euro"
LC_IDENTIFICATION=3D"fr_FR@euro"
LC_ALL=3D

bash-3.2# exit
root@ubuntu:~# umount /mnt/loop=20

root@ubuntu:~# mount archlinux_64_minimal_ext4_without_journal.img /mnt=
/loop -o
loop
root@ubuntu:~# chroot /mnt/loop
*****************HERE, NO PROBLEM, locales are taken from previous
session*******

bash-3.2# locale
LANG=3Dfr_FR@euro
LC_CTYPE=3D"fr_FR@euro"
LC_NUMERIC=3D"fr_FR@euro"
LC_TIME=3D"fr_FR@euro"
LC_COLLATE=3D"fr_FR@euro"
LC_MONETARY=3D"fr_FR@euro"
LC_MESSAGES=3D"fr_FR@euro"
LC_PAPER=3D"fr_FR@euro"
LC_NAME=3D"fr_FR@euro"
LC_ADDRESS=3D"fr_FR@euro"
LC_TELEPHONE=3D"fr_FR@euro"
LC_MEASUREMENT=3D"fr_FR@euro"
LC_IDENTIFICATION=3D"fr_FR@euro"
LC_ALL=3D


exit, umount...






> I would be interested to know what your actual output looks like.  I'=
ve tried
> to reproduce this and don't seem to be able to, at least not in my en=
vironment.
>=20
> My attempts looked like:
> [/root]# mount -t ext4 -o loop
> /foo/archlinux_64_minimal_ext4_without_journal.img /mnt
> [/root]# chroot /mnt
> bash-3.2# locale-gen
> Generating locales...
>   fr_FR.UTF-8... done
>   fr_FR.ISO-8859-1... done
>   fr_FR.ISO-8859-15@euro... done
> Generation complete.
> bash-3.2# locale
> locale: Cannot set LC_CTYPE to default locale: No such file or direct=
ory
> locale: Cannot set LC_MESSAGES to default locale: No such file or dir=
ectory
> locale: Cannot set LC_ALL to default locale: No such file or director=
y
> LANG=3Den_US
> LC_CTYPE=3D"en_US"
> LC_NUMERIC=3D"en_US"
> LC_TIME=3D"en_US"
> LC_COLLATE=3D"en_US"
> LC_MONETARY=3D"en_US"
> LC_MESSAGES=3D"en_US"
> LC_PAPER=3D"en_US"
> LC_NAME=3D"en_US"
> LC_ADDRESS=3D"en_US"
> LC_TELEPHONE=3D"en_US"
> LC_MEASUREMENT=3D"en_US"
> LC_IDENTIFICATION=3D"en_US"
> LC_ALL=3D
> bash-3.2# LANG=3Dfr_FR
> bash-3.2# locale
> LANG=3Dfr_FR
> LC_CTYPE=3D"fr_FR"
> LC_NUMERIC=3D"fr_FR"
> LC_TIME=3D"fr_FR"
> LC_COLLATE=3D"fr_FR"
> LC_MONETARY=3D"fr_FR"
> LC_MESSAGES=3D"fr_FR"
> LC_PAPER=3D"fr_FR"
> LC_NAME=3D"fr_FR"
> LC_ADDRESS=3D"fr_FR"
> LC_TELEPHONE=3D"fr_FR"
> LC_MEASUREMENT=3D"fr_FR"
> LC_IDENTIFICATION=3D"fr_FR"
> LC_ALL=3D
> bash-3.2# exit
> [/root]# umount /mnt
> [/root]# mount -t ext4 -o loop
> /foo/archlinux_64_minimal_ext4_without_journal.img /mnt
> [/root]# chroot /mnt
> bash-3.2# locale
> locale: Cannot set LC_CTYPE to default locale: No such file or direct=
ory
> locale: Cannot set LC_MESSAGES to default locale: No such file or dir=
ectory
> locale: Cannot set LC_ALL to default locale: No such file or director=
y
> LANG=3Den_US
> LC_CTYPE=3D"en_US"
> LC_NUMERIC=3D"en_US"
> LC_TIME=3D"en_US"
> LC_COLLATE=3D"en_US"
> LC_MONETARY=3D"en_US"
> LC_MESSAGES=3D"en_US"
> LC_PAPER=3D"en_US"
> LC_NAME=3D"en_US"
> LC_ADDRESS=3D"en_US"
> LC_TELEPHONE=3D"en_US"
> LC_MEASUREMENT=3D"en_US"
> LC_IDENTIFICATION=3D"en_US"
> LC_ALL=3D
> bash-3.2# LANG=3Dfr_FR
> bash-3.2# locale
> LANG=3Dfr_FR
> LC_CTYPE=3D"fr_FR"
> LC_NUMERIC=3D"fr_FR"
> LC_TIME=3D"fr_FR"
> LC_COLLATE=3D"fr_FR"
> LC_MONETARY=3D"fr_FR"
> LC_MESSAGES=3D"fr_FR"
> LC_PAPER=3D"fr_FR"
> LC_NAME=3D"fr_FR"
> LC_ADDRESS=3D"fr_FR"
> LC_TELEPHONE=3D"fr_FR"
> LC_MEASUREMENT=3D"fr_FR"
> LC_IDENTIFICATION=3D"fr_FR"
> LC_ALL=3D
> bash-3.2#

--=20
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=3Demail
------- You are receiving this mail because: -------
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
