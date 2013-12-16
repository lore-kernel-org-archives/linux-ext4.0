From: Lars Noschinski <lars@public.noschinski.de>
Subject: Recover files from a broken ext3 partition
Date: Mon, 16 Dec 2013 15:46:43 +0100
Message-ID: <52AF1253.1000608@public.noschinski.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtprelay03.ispgateway.de ([80.67.29.28]:60054 "EHLO
	smtprelay03.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762Ab3LPOwy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Dec 2013 09:52:54 -0500
Received: from [131.159.46.89]
	by smtprelay03.ispgateway.de with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.68)
	(envelope-from <lars@public.noschinski.de>)
	id 1VsZRW-00009E-6u
	for linux-ext4@vger.kernel.org; Mon, 16 Dec 2013 15:46:46 +0100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

[Please tell me if this message is not appropriate here, but the
ext3-users ML seems to be dead since a few months]

Hi everyone,

I have got a hard disk which was damaged by a fall and would like to
recover a few files from that. (There is a backup for most of the
data, but a handful of recent files are missing. These are important
enough to spend some time on them, but not for paying a professional
data recovery service).

Using GNU ddrescue I was able to read 99.8% of an ext3(or 4?)
partition, so there's hope the data is still there. Unfortunately,
some key parts of the file system seem to be damaged, so e2fsck fails:

- ------------------------------
% ddrescuelog -l- -b4096 sdd5.ddrescue.log > badblocks.sdd5.4096
% e2fsck -b 20480000 -v -f -L badblocks.sdd5.4096 sdd5
[...]
Pass 1: Checking inodes, blocks, and sizes
Block 1 in the primary group descriptors is on the bad block list

If the block is really bad, the filesystem can not be fixed.
You can remove this block from the bad block list and hope
that the block is really OK.  But there are no guarantees.
- ------------------------------
[at 20480000 there seems to be an intact superblock; got the number
(and the block size) from 'mke2fs -n']


The files I am interested in are located under /home/$USER/Desktop and
/home/$USER/Dokumente; so I tried accessing them with debugfs.
Unfortunately, /home/$USER seems to be corrupted:

- ------------------------------
% LESS=FSRX debugfs -s 20480000 -b 4096 sdd5
debugfs 1.42.8 (20-Jun-2013)
debugfs:  cd /home/$USER
debugfs:  ls

EXT2 directory corrupted
- ------------------------------

So, any hints for me how to proceed? Is there a way to access the
Desktop and Dokumente subdirectories (provided they are themselves
undamaged)?

Also, I interrupted ddrescue for my access attempt (because it takes
really long to get all the still-good sectors from a 200GB partition).
Can debugfs show me where on the disk /home/$USER is located? This
would allow me to instruct ddrescue to concentrate on these parts.

  Best regards, Lars
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iQEcBAEBAgAGBQJSrxJTAAoJEOUX5T7UhMS6WbEIAN1FUBc2U9o9Vrad0jtMbZDM
xD7tkr5+Z/dxefW/kQQk3eh4f+oqIKQgx8nCVOD84/Of7Oc9JHvKmROj4KBcf0C1
APa04JiYfa5RY+6wGAeKS896/C8qABCV6toHJ5ko1ZxgLTFTiiWeIlepsW77cPJ4
5jYLdjI0V4qHbPOxRE3aRABk57fe20YNoiNtdKU7scgz6Vbd8JwL/5D1tH0+5l2r
kRMModB7+kWl2e/Q7vy9721clXRnkyAr03Q+eg/n/h8P39qee1B+fhnwhWWJvZWt
yAdNtLKDc/rJ7Sths0fJqSiNo220j0FSSD/YCBJVe3XehwHRIo0RYHn/RrVqo3M=
=yfSt
-----END PGP SIGNATURE-----
