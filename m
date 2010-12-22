From: "Bjoern Slotkowski" <bjoern.slotkowski@imc-berlin.de>
Subject: Questions concerning ext2 filesystem:  ext2_statfs
Date: Wed, 22 Dec 2010 13:14:51 +0100
Message-ID: <FPEIIEKCABPOOBGGCOCHIEBLDHAA.bjoern.slotkowski@imc-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.imc-berlin.de ([82.144.33.98]:56752 "EHLO mx1.imc-berlin.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751473Ab0LVMYV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 22 Dec 2010 07:24:21 -0500
Received: from localhost (localhost [127.0.0.1])
	by mx1.imc-berlin.de (Postfix) with ESMTP id 177253B8AE
	for <linux-ext4@vger.kernel.org>; Wed, 22 Dec 2010 13:14:51 +0100 (CET)
Received: from mx1.imc-berlin.de ([127.0.0.1])
	by localhost (mx1.imc-berlin.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vTFm7mbTT47k for <linux-ext4@vger.kernel.org>;
	Wed, 22 Dec 2010 13:14:51 +0100 (CET)
Received: from mailserver.berlin.imc-berlin.de (mailserver.berlin.imc-berlin.de [10.0.0.19])
	by mx1.imc-berlin.de (Postfix) with ESMTP id F2C4E3B5D0
	for <linux-ext4@vger.kernel.org>; Wed, 22 Dec 2010 13:14:50 +0100 (CET)
Received: from bjoerns (bjoerns.berlin.imc-berlin.de [10.0.1.12])
	by mailserver.berlin.imc-berlin.de (Postfix) with SMTP id EFDAB10FA4
	for <linux-ext4@vger.kernel.org>; Wed, 22 Dec 2010 13:14:50 +0100 (CET)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello all,

hope I am right here.

We have some questions concerning the ext2 filesystem:

When looking for free blocks and inodes in function ext2_statfs the
overhead, free inodes and free blocks are newly calculated by iterating
through all
inodes and blocks and look if they are free or not.

On the other hand free inodes and free blocks are held in the
structure-members s_freeinode_count
and s_free_block_count of the superblock info.


Now my questions:

Why is the overhead calculated ?
Isn't it is constant since filling the superblock ?
Wy are free blocks and free inodes are calculated every time,
when they are held in s_freeinode_count and s_free_block_count ?

Isn't it is possible to use these variables directly ?

By the way: s_freeinode_count is not incremented in function
ext2_release_inode.



The background for these questions is as it always is:
We have a problem using 320 GB harddrives instead of 80 GB harddrives w=
ith
ext2.

Before writing to the harddrive our software looks for enough space
to make sure the data can be stored safely.
This leads to heavy performance problems when using larger disks.

We can reduce the check for enough space to every 10th or 100th write
operation,
but at some point our software has to check and this may lead to a los =
of
data
because the system is busy calculating the free inodes and blocks.

Our solution will be to create a patch using the structure members
s_freeinode_count, s_free_block_count
and create a new member s_overhead_count and use them directly.
s_overhead_count is calculated once when filling the superblock.

Is this a good solution or are there circumstances which can lead to a
misbehavior ?


Thanks in advance,


Bj=F6rn Slotkowski

--
imc Messsysteme GmbH
Bereich Entwicklung / Dept. Development
Voltastra=DFe 5
D-13355 Berlin
Germany
Tel:   +49 30 46 70 90 23
=46ax:   +49 30 46 31 57 6
mailto:Bjoern.Slotkowski@imc-berlin.de
Homepage: http://www.imc-berlin.de

Sitz der Gesellschaft : Berlin
Handelsregister       : Berlin-Charlottenburg HRB 28778
Gesch=E4ftsf=FChrer       : Dr.-Ing. Dietmar Sprenger



--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
