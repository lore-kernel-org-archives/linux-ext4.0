Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50CA0327C0D
	for <linux-ext4@vger.kernel.org>; Mon,  8 Jun 2026 09:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780912199; cv=none; b=Jc4RLsJVeyy4DWWIukOnpO/Ujf5A56DyNh5/DFtminR3At0kGpFp8aZAHTKgv3R4SCqd2+bVXMIQH4v5LurUt6r3jIFNXRj2aQx7EjPdcGTeay4RSzneMU4eRhIEw2EdDeh6MWl/bpv9NGzYA0qoo81akNFfM0geSZ3KuDh6l1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780912199; c=relaxed/simple;
	bh=x5UtNrP4CVL8+nvqN9ZEMCMu6PTLn+s69FAGMqhh1QE=;
	h=From:Message-Id:Content-Type:Mime-Version:Subject:Date:
	 In-Reply-To:Cc:To:References; b=AdqezzPe4qgeIbZ6VDrIwGVjEASQcmAu2pgvFMN/WIe+VYkVxK6f+zVWcrIChq1DMM1vxajPDo7x1gmLzIySoK4/fG1mFJSPSmLV5BIIijsfTFeB+5OJHCxGgAcaqgQtBCpWlQsmZJAr1l4uqxx3O8yZMESfpecwQlSDVoPvZ2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca; spf=pass smtp.mailfrom=dilger.ca; dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b=n6nQFd1N; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dilger.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b="n6nQFd1N"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-c85893bce34so1552728a12.1
        for <linux-ext4@vger.kernel.org>; Mon, 08 Jun 2026 02:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20251104.gappssmtp.com; s=20251104; t=1780912196; x=1781516996; darn=vger.kernel.org;
        h=references:to:cc:in-reply-to:date:subject:mime-version:message-id
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=BSSYBL6pygMRnuM8zKQPdEAFqJRiIj/TrOyZ1tE8iLM=;
        b=n6nQFd1NV0kKBH4+3MlGJpv7u1ZRBBK0R5v775wLf+HpuQJBCJ6jYxsr6ChHjlX6Mn
         2KlY2wVg92AeF2ARDvH5Q/hclnIL143qTsOn5k7KAWRv7DhfST47D8mdcXXBIN2kEONr
         pUkSz5ZZWYL06SfYqG4OjVN5lpBK6sP72/5+nsNn7WjlP2KWa82opkKztTvqacEWeSTO
         i5zraq1lThUIM5fP5bHt6d1R63sfeC6Fo5DuDCdBmVjAH/h/mJB0LxQqoQZaZV3HY2is
         Cd9QXrR4CX0AGmJIEprS9t+/KtZwzIoOhimSfaQC+++gRZuaTxMH9H6uqSPWb50Lh+IZ
         +DRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780912196; x=1781516996;
        h=references:to:cc:in-reply-to:date:subject:mime-version:message-id
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BSSYBL6pygMRnuM8zKQPdEAFqJRiIj/TrOyZ1tE8iLM=;
        b=DxCY7tu7bUA2LoeNrWiyYy5hFFCMPJPHG0ANmFcg9ddsjdMEuAmNAztw+uob50Qmhz
         NcsvfJThDgWIA35BbJDQbrxoyUNy+d1zswv99e942Pz4gaY8ebAGrO9JCXEc3X2Q+6P0
         JVzoV/kFwHvObWBsaH15lirAtuR/eMQbedfgsMkqz7DLLgOsIzFOwuwx0qF9qKiVOtWg
         oAWAyU8iHulAzFNxg75xJTX/CmFj0WOJtdPEJsARFwKNwkLtxFRD4DKHIEof3hyXF/VW
         Zcv2DTHbI3m+bmzOrBcycfdlzIG65GovoGs79DO43zbczZUy1n8I6M7nNFlKG7kjLwR2
         X9eQ==
X-Forwarded-Encrypted: i=1; AFNElJ978BgegEy5Ml0jW8/sAGpDb/JkmRwHY4mpDLMr6rw/BD4CTAsuoNSbwbB97IUnG6RC2kkD7qbIZkJd@vger.kernel.org
X-Gm-Message-State: AOJu0YwPwF5M/brGsOmO5XrsjoYdyz3Nht8ISKTXIn7WItP8FfAbSkMc
	zNUJRS+W7M/0LR9WNPybQlz2uEocjFJA5S3VBSFwYD4dMrI3PWAXZAvZ5qorxflndGE=
X-Gm-Gg: Acq92OF1TpefhhD2B36GRVdXEIBMLKos3LqdICY36OesmtDTGuf/YdhnpDPHNPEEi8c
	PPxDSLzdqg4D5HqAT8JpvwsM/nK1f6AZzEVEkGvtaLN/yxm8Fhy/2q8Kr/tdHhAZPvIwDrWRK3p
	KNgwde6AbGexji3Q9Y5xTcD3CN4EcUlKzxakDmYNEYJc7PUCIOrhE/nVdk9zeC2stixf/P1+sue
	fNyXC9cqpG2Eh/FNFKiVk8jru0L5+tr7lNW8XMyurNfmaDzzH6T6YreRo4cWNwPXk0vupquklSF
	niRTTuh/3C4IqKSmAGXsHljq9SGlofUekHtY3vF28KWlKOVQpqOqN5kwUxAwg2HcNZ5XIXp/BZz
	tP9AooDBWThSjB/QT3yrkT/UAs4ABA+mtaUwgJlnpniUxbwDoMxbJKD/6VTcLiu/AwKQcjrlF/w
	5KRj5jRdNjKqSZuKurfXIXAmro2XtvLSL7hVynnbAvx6FJGRTeEz6qk9ebkkH8tGnZ41YNRhYJM
	4cY8IiMx/Q48p39
X-Received: by 2002:a05:6a00:b911:b0:841:71fd:60c4 with SMTP id d2e1a72fcca58-842b0e13003mr14403963b3a.4.1780912196489;
        Mon, 08 Jun 2026 02:49:56 -0700 (PDT)
Received: from smtpclient.apple (S01068c763f81ca4b.cg.shawcable.net. [70.77.200.158])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-842828821d0sm17361985b3a.28.2026.06.08.02.49.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jun 2026 02:49:55 -0700 (PDT)
From: Andreas Dilger <adilger@dilger.ca>
Message-Id: <9237265C-CB9C-48BD-A77E-25AE61DA8550@dilger.ca>
Content-Type: multipart/mixed;
	boundary="Apple-Mail=_91631063-8ECE-42D5-A143-2C96AD196BDB"
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.100.1.1.5\))
Subject: Re: security bug reporting: e2fsprogs: Path Traversal and heap
 overflow
Date: Mon, 8 Jun 2026 03:49:44 -0600
In-Reply-To: <SY0P300MB0070F750CCF6F2C3A2A91FDE901F2@SY0P300MB0070.AUSP300.PROD.OUTLOOK.COM>
Cc: "tytso@mit.edu" <tytso@mit.edu>,
 "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Feng Xue <feng.xue@outlook.com>
References: <SY0P300MB0070F750CCF6F2C3A2A91FDE901F2@SY0P300MB0070.AUSP300.PROD.OUTLOOK.COM>
X-Mailer: Apple Mail (2.3864.100.1.1.5)


--Apple-Mail=_91631063-8ECE-42D5-A143-2C96AD196BDB
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

Hello Feng Xue,
thank you for your report.  The inode blocks overflow looks legitimate, =
and trivial to fix.  The reproducer is a bit strange, since it is a =
python script that generates a synthetic ext4 image directly rather than =
writing an e2fsck test case like "f_64kblock" using mke2fs to create the =
filesystem with mostly appropriate parameters, and debugfs to overwrite =
the values.

Then e2fsck can be run on the filesystem to fix the superblock =
s_blocks_per_group value.

A patch is attached with the trivial code fix for review and includes a =
test case.


The debugfs issue seems less important, since this requires the =
administrator to run the specific debugfs command on the specific file. =20=


> On Jun 7, 2026, at 07:34, Feng Xue <feng.xue@outlook.com> wrote:
>=20
> Hi there,
>=20
> I'd like to report two potential security bugs for your review.
> detailed report and pocs attached.
>=20
> Best,
> Feng


Cheers, Andreas


--Apple-Mail=_91631063-8ECE-42D5-A143-2C96AD196BDB
Content-Disposition: attachment;
	filename=0001-libext2fs-fix-inode_blocks-overflow-in-ext2fs_open.patch
Content-Type: application/octet-stream;
	x-unix-mode=0644;
	name="0001-libext2fs-fix-inode_blocks-overflow-in-ext2fs_open.patch"
Content-Transfer-Encoding: quoted-printable

=46rom=20bd5490e494dc3638b2f1e3a737f54b7eb67721ef=20Mon=20Sep=2017=20=
00:00:00=202001=0AFrom:=20Andreas=20Dilger=20<adilger@dilger.ca>=0ADate:=20=
Mon,=208=20Jun=202026=2003:06:14=20-0600=0ASubject:=20[PATCH]=20=
libext2fs:=20fix=20inode_blocks=20overflow=20in=20ext2fs_open()=0A=0AFix=20=
an=20overflow=20when=20calculating=20inode_blocks_per_group=20with=20an=0A=
intermediate=2032-bit=20variable=20for=20an=20invalid=20=
s_inodes_per_group=20value.=0AWith=20blocksize=3D65536,=20=
inodes_per_group=3D262145=20*=20inodesize=3D16384=0Aintermediate=20=
product=20overflows=202^32=20temporarily=20before=20being=20reduced=0A=
again=20by=20the=20blocksize.=0A=0ACheck=20inodes_per_group=20validity=20=
before=20using=20it=20in=20the=20calculation,=0Ato=20avoid=20=
intermediate=20overflow,=20but=20also=20use=20a=2064-bit=20variable=20in=0A=
the=20inode_blocks_per_group=20calculation=20in=20case=20of=20future=20=
expansion=0Ain=20the=20number=20of=20inodes=20per=20group=20or=20the=20=
blocksize.=0A=0ASigned-off-by:=20Andreas=20Dilger=20<adilger@dilger.ca>=0A=
Change-Id:=20I30472e69dafed4dc1791fad2dde6fc7c43aed0ef=0A---=0A=20=
lib/ext2fs/openfs.c=20=20=20=20=20|=2011=20+++++---=0A=20=
tests/f_64kblock/expect=20|=2035=20+++++++++++++++++++++++++=0A=20=
tests/f_64kblock/name=20=20=20|=20=201=20+=0A=20tests/f_64kblock/script=20=
|=2058=20+++++++++++++++++++++++++++++++++++++++++=0A=204=20files=20=
changed,=20101=20insertions(+),=204=20deletions(-)=0A=20create=20mode=20=
100644=20tests/f_64kblock/expect=0A=20create=20mode=20100644=20=
tests/f_64kblock/name=0A=20create=20mode=20100755=20=
tests/f_64kblock/script=0A=0Adiff=20--git=20a/lib/ext2fs/openfs.c=20=
b/lib/ext2fs/openfs.c=0Aindex=202b8e0e753c..da4b3d9cec=20100644=0A---=20=
a/lib/ext2fs/openfs.c=0A+++=20b/lib/ext2fs/openfs.c=0A@@=20-356,10=20=
+356,14=20@@=20retry:=0A=20=09=09retval=20=3D=20=
EXT2_ET_CORRUPT_SUPERBLOCK;=0A=20=09=09goto=20cleanup;=0A=20=09}=0A-=09=
fs->inode_blocks_per_group=20=3D=20((EXT2_INODES_PER_GROUP(fs->super)=20=
*=0A+=09if=20(EXT2_INODES_PER_GROUP(fs->super)=20>=0A+=09=20=20=20=20=
EXT2_MAX_INODES_PER_GROUP(fs->super))=20{=0A+=09=09retval=20=3D=20=
EXT2_ET_CORRUPT_SUPERBLOCK;=0A+=09=09goto=20cleanup;=0A+=09}=0A+=09=
fs->inode_blocks_per_group=20=3D=20=
(((__u64)EXT2_INODES_PER_GROUP(fs->super)=20*=0A=20=09=09=09=09=20=20=20=20=
=20=20=20EXT2_INODE_SIZE(fs->super)=20+=0A-=09=09=09=09=20=20=20=20=20=20=
=20EXT2_BLOCK_SIZE(fs->super)=20-=201)=20/=0A-=09=09=09=09=20=20=20=20=20=
=20EXT2_BLOCK_SIZE(fs->super));=0A+=09=09=09=09=20=20=20=20=20=20=20=
fs->blocksize=20-=201)=20/=20fs->blocksize);=0A=20=09if=20(block_size)=20=
{=0A=20=09=09if=20(block_size=20!=3D=20fs->blocksize)=20{=0A=20=09=09=09=
retval=20=3D=20EXT2_ET_UNEXPECTED_BLOCK_SIZE;=0A@@=20-394,7=20+398,6=20=
@@=20retry:=0A=20=09blocks_per_group=20=3D=20=
EXT2_BLOCKS_PER_GROUP(fs->super);=0A=20=09if=20(blocks_per_group=20<=208=20=
||=0A=20=09=20=20=20=20blocks_per_group=20>=20=
EXT2_MAX_BLOCKS_PER_GROUP(fs->super)=20||=0A-=09=20=20=20=20=
fs->inode_blocks_per_group=20>=20EXT2_MAX_INODES_PER_GROUP(fs->super)=20=
||=0A=20=20=20=20=20=20=20=20=20=20=20=20EXT2_DESC_PER_BLOCK(fs->super)=20=
=3D=3D=200=20||=0A=20=20=20=20=20=20=20=20=20=20=20=20=
fs->super->s_first_data_block=20>=3D=20ext2fs_blocks_count(fs->super))=20=
{=0A=20=09=09retval=20=3D=20EXT2_ET_CORRUPT_SUPERBLOCK;=0Adiff=20--git=20=
a/tests/f_64kblock/expect=20b/tests/f_64kblock/expect=0Anew=20file=20=
mode=20100644=0Aindex=200000000000..abbe524121=0A---=20/dev/null=0A+++=20=
b/tests/f_64kblock/expect=0A@@=20-0,0=20+1,35=20@@=0A+mke2fs=20-F=20-o=20=
Linux=20-b=2065536=20-g=20262144=20-I=2016384=20-N=2024=20test.img=20=
131072=0A+Warning:=20blocksize=2065536=20not=20usable=20on=20most=20=
systems.=0A+Warning:=2065536-byte=20blocks=20too=20big=20for=20system=20=
(max=204096),=20forced=20to=20continue=0A+Creating=20filesystem=20with=20=
131056=2064k=20blocks=20and=2016=20inodes=0A+Superblock=20backups=20=
stored=20on=20blocks:=20=0A+=0965528=0A+=0A+Allocating=20group=20tables:=20=
=20=20=20=08=08=08done=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=0A+Writing=20inode=20tables:=20=20=20=20=
=08=08=08done=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=0A+Writing=20superblocks=20and=20filesystem=20=
accounting=20information:=20=20=20=20=08=08=08done=0A+=0A+Pass=201:=20=
Checking=20inodes,=20blocks,=20and=20sizes=0A+Pass=202:=20Checking=20=
directory=20structure=0A+Pass=203:=20Checking=20directory=20connectivity=0A=
+Pass=204:=20Checking=20reference=20counts=0A+Pass=205:=20Checking=20=
group=20summary=20information=0A+test_filesys:=2011/16=20files=20(0.0%=20=
non-contiguous),=2016/131056=20blocks=0A+Exit=20status=20is=200=0A=
+-----------------------------------------------=0A+=20=0A+debugfs=20-R=20=
'set_super_value=20inodes_per_group=20262145'=20-w=20test.img=0A+Exit=20=
status=20is=200=0A+debugfs=20-R=20'lsdel'=20test.img=0A+debugfs:=20The=20=
ext2=20superblock=20is=20corrupt=20while=20trying=20to=20open=20test.img=0A=
+lsdel:=20Filesystem=20not=20open=0A+Exit=20status=20is=200=0A+Pass=201:=20=
Checking=20inodes,=20blocks,=20and=20sizes=0A+Pass=202:=20Checking=20=
directory=20structure=0A+Pass=203:=20Checking=20directory=20connectivity=0A=
+Pass=204:=20Checking=20reference=20counts=0A+Pass=205:=20Checking=20=
group=20summary=20information=0A+=0A+test_filesys:=20*****=20FILE=20=
SYSTEM=20WAS=20MODIFIED=20*****=0A+test_filesys:=2011/16=20files=20(0.0%=20=
non-contiguous),=2016/131056=20blocks=0A+Exit=20status=20is=201=0Adiff=20=
--git=20a/tests/f_64kblock/name=20b/tests/f_64kblock/name=0Anew=20file=20=
mode=20100644=0Aindex=200000000000..f737e26fd7=0A---=20/dev/null=0A+++=20=
b/tests/f_64kblock/name=0A@@=20-0,0=20+1=20@@=0A+calculate=20=
inode_blocks_per_group=20for=20large-block=20fs=0Adiff=20--git=20=
a/tests/f_64kblock/script=20b/tests/f_64kblock/script=0Anew=20file=20=
mode=20100755=0Aindex=200000000000..9ae0c0d55c=0A---=20/dev/null=0A+++=20=
b/tests/f_64kblock/script=0A@@=20-0,0=20+1,58=20@@=0A=
+test_description=3D"debugfs=20inode_overflow=20check"=0A+if=20!=20test=20=
-x=20$DEBUGFS_EXE;=20then=0A+=09echo=20"$test_name:=20$test_description:=20=
skipped=20(no=20debugfs)"=0A+=09return=200=0A+fi=0A+=0A+FSCK_OPT=3D-yf=0A=
+OUT=3D$test_name.log=0A+if=20[=20-f=20$test_dir/expect.gz=20];=20then=0A=
+=09EXP=3D$test_name.tmp=0A+=09gunzip=20<=20$test_dir/expect.gz=20>=20=
$EXP=0A+else=0A+=09EXP=3D$test_dir/expect=0A+fi=0A+=0A=
+TMPFILE=3D$test_dir/test_img=0A+dd=20if=3D/dev/zero=20of=3D$TMPFILE=20=
bs=3D1k=20count=3D512=20>=20/dev/null=202>&1=0A+=0A+echo=20mke2fs=20-F=20=
-o=20Linux=20-b=2065536=20-g=20262144=20-I=2016384=20-N=2024=20test.img=20=
131072=20>=20$OUT.new=0A+$MKE2FS=20-F=20-o=20Linux=20-b=2065536=20-g=20=
262144=20-I=2016384=20-N=2024=20$TMPFILE=20131072=20>>=20$OUT.new=202>&1=0A=
+=0A+$FSCK=20$FSCK_OPT=20=20-N=20test_filesys=20$TMPFILE=20>>=20$OUT.new=20=
2>&1=0A+status=3D$?=0A+echo=20Exit=20status=20is=20$status=20>>=20=
$OUT.new=0A+=0A+echo=20-----------------------------------------------=20=
>>=20$OUT.new=0A+=0A+echo=20"=20"=20>>=20$OUT.new=0A+echo=20"debugfs=20=
-R=20'set_super_value=20inodes_per_group=20262145'=20-w=20test.img"=20>>=20=
$OUT.new=0A+$DEBUGFS=20-R=20"set_super_value=20inodes_per_group=20=
262145"=20-w=20$TMPFILE=20>>=20$OUT.new=202>&1=0A+status=3D$?=0A+echo=20=
Exit=20status=20is=20$status=20>>=20$OUT.new=0A+=0A+echo=20"debugfs=20-R=20=
'lsdel'=20test.img"=20>>=20$OUT.new=0A+$DEBUGFS=20=20-R=20"lsdel"=20=
$TMPFILE=20>>=20$OUT.new=202>&1=0A+status=3D$?=0A+echo=20Exit=20status=20=
is=20$status=20>>=20$OUT.new=0A+=0A+$FSCK=20$FSCK_OPT=20-b=2065528=20-B=20=
65536=20-N=20test_filesys=20$TMPFILE=20>>=20$OUT.new=202>&1=0A+status=3D$?=
=0A+echo=20Exit=20status=20is=20$status=20>>=20$OUT.new=0A+=0A+sed=20-f=20=
$cmd_dir/filter.sed=20$OUT.new=20>=20$OUT=0A+rm=20-f=20$OUT.new=0A+=0A=
+cmp=20-s=20$OUT=20$EXP=0A+status=3D$?=0A+=0A+if=20[=20"$status"=20=3D=20=
0=20]=20;=20then=0A+=09echo=20"$test_name:=20$test_description:=20ok"=0A=
+=09touch=20$test_name.ok=0A+else=0A+=09echo=20"$test_name:=20=
$test_description:=20failed"=0A+=09diff=20$DIFF_OPTS=20$EXP=20$OUT=20>=20=
$test_name.failed=0A+=09rm=20-f=20tmp_expect=0A+fi=0A+=0A+unset=20IMAGE=20=
FSCK_OPT=20OUT=20EXP=0A--=20=0A2.43.0=0A=0A=

--Apple-Mail=_91631063-8ECE-42D5-A143-2C96AD196BDB--
