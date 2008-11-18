From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Boh=E9?= <frederic.bohe@bull.net>
Subject: Re: Errors with 1024 block size
Date: Tue, 18 Nov 2008 16:40:38 +0100
Message-ID: <1227022838.3510.12.camel@frecb007923.frec.bull.fr>
References: <20081118112420.GB9345@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:47427 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302AbYKRPjF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 18 Nov 2008 10:39:05 -0500
In-Reply-To: <20081118112420.GB9345@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Le mardi 18 novembre 2008 =C3=A0 16:54 +0530, Aneesh Kumar K.V a =C3=A9=
crit :
> Hi,
>=20
> With block size 1024 on x86 i am getting different errors listed belo=
w
> I can't reproduce them always.
>=20
>=20
>=20
> [root@llm19 tmp]# ls -al /mnt/tmp/f/p369/d3/d6/d39/db2/dee/d10f/d3f/l=
71
> ls: /mnt/tmp/f/p369/d3/d6/d39/db2/dee/d10f/d3f/l71: Stale NFS file ha=
ndle
> [root@llm19 tmp]# ls -al /mnt/tmp/f/p369/d3/d6/d39/db2/dee/d10f/d3f/
> total 411
> drwxrwxrwx 3 689933 root    1024 Nov 18 05:59 .
> drwxrwxrwx 3   8391 root    1024 Nov 18 05:59 ..
> drwxrwxrwx 2 root   root    1024 Nov 18 05:33 d83
> -rw-rw-rw- 1 root   root       0 Nov 18 05:06 fb4
> -rw-rw-rw- 1 root   root 3350138 Nov 18 05:33 fb9
> ?--------- ? ?      ?          ?            ? l71
> lrwxrwxrwx 1 root   root     509 Nov 18 05:23 ld9 -> xxxxxxxxxx/xxxxx=
xxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxx=
xxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxx=
xx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxx=
x/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx=
/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/=
xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/x=
xxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxx
> [root@llm19 tmp]#=20
>=20
> dmesg gives:
>=20
> EXT4-fs error (device sdb1): ext4_free_inode: bit already cleared for=
 inode 168449

I had reproduced this one easily while deleting files on a file system
with several concurrent threads. I have noticed that the inode reported
in the error message is always the first inode of a group ( X *
inode_per_group + 1 ). I have not investigated further since I am
working on another error which happens during the online resize :

EXT4-fs error (device md0): ext4_mb_mark_diskspace_used: Allocating
block in system zone - block =3D 6873089

This one happens only with 1024 bytes blocks too, but I am not sure if
it is really related to the block size yet.

=46red


>=20
>=20
> Some other message i got before. But i didn't capture the info fully=20
>=20
> a) "Deleting nonexistent file ..." warning in ext4_unlink
>=20
> b) "Empty directory has too many links..." in ext4_rmdir
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
