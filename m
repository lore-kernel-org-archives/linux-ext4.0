From: Christoph Anton Mitterer <calestyo@scientia.net>
Subject: errors in =?UTF-8?Q?ext=34=5Fmb=5Fgenerate=5Fbuddy=20and=20ext=34=5Fremou?=
 =?UTF-8?Q?nt?=
Date: Sun, 08 May 2011 00:56:19 +0000
Message-ID: <f93bc5d54d25e080b5438bcdc3af8f84@imap.dd24.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailgw02.dd24.net ([193.46.215.43]:35517 "EHLO
	mailgw02.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669Ab1EHA4t (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 7 May 2011 20:56:49 -0400
Received: from localhost (amavis01.dd24.net [192.168.1.111])
	by mailgw02.dd24.net (Postfix) with ESMTP id E67C0354231
	for <linux-ext4@vger.kernel.org>; Sun,  8 May 2011 00:56:47 +0000 (GMT)
Received: from mailgw02.dd24.net ([192.168.1.197])
	by localhost (amavis01.dd24.net [192.168.1.105]) (amavisd-new, port 10197)
	with ESMTP id HDvVj2GsnTrH for <linux-ext4@vger.kernel.org>;
	Sun,  8 May 2011 00:56:43 +0000 (GMT)
Received: from webmail.dd24.net (webmail01.dd24.net [193.46.215.65])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mailgw02.dd24.net (Postfix) with ESMTPSA id D983D35422C
	for <linux-ext4@vger.kernel.org>; Sun,  8 May 2011 00:56:43 +0000 (GMT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi.

I've had several crashes recently, which lead to things like these:
May  6 00:23:53 heisenberg kernel: [   31.941036] EXT4-fs (dm-2):
ext4_orphan_cleanup: deleting unreferenced inode 2016253
May  6 00:23:53 heisenberg kernel: [   31.941049] EXT4-fs (dm-2):
ext4_orphan_cleanup: deleting unreferenced inode 2016250
May  6 00:23:53 heisenberg kernel: [   31.941073] EXT4-fs (dm-2):
ext4_orphan_cleanup: deleting unreferenced inode 2016249
May  6 00:23:53 heisenberg kernel: [   31.941106] EXT4-fs (dm-2):
ext4_orphan_cleanup: deleting unreferenced inode 2016248
May  6 00:23:53 heisenberg kernel: [   31.941120] EXT4-fs (dm-2):
ext4_orphan_cleanup: deleting unreferenced inode 2016247
May  6 00:23:53 heisenberg kernel: [   31.941135] EXT4-fs (dm-2):
ext4_orphan_cleanup: deleting unreferenced inode 2016240
May  6 00:23:53 heisenberg kernel: [   31.941158] EXT4-fs (dm-2):
ext4_orphan_cleanup: deleting unreferenced inode 2016239
May  6 00:23:53 heisenberg kernel: [   31.941168] EXT4-fs (dm-2):
ext4_orphan_cleanup: deleting unreferenced inode 2016238
May  6 00:23:53 heisenberg kernel: [   31.941174] EXT4-fs (dm-2):
ext4_orphan_cleanup: deleting unreferenced inode 2016237
May  6 00:23:53 heisenberg kernel: [   31.941180] EXT4-fs (dm-2):
ext4_orphan_cleanup: deleting unreferenced inode 2016236
May  6 00:23:53 heisenberg kernel: [   31.941190] EXT4-fs (dm-2):
ext4_orphan_cleanup: deleting unreferenced inode 2016235
May  6 00:23:53 heisenberg kernel: [   31.941200] EXT4-fs (dm-2):
ext4_orphan_cleanup: deleting unreferenced inode 2016234
May  6 00:23:53 heisenberg kernel: [   31.941212] EXT4-fs (dm-2):
ext4_orphan_cleanup: deleting unreferenced inode 2016233
May  6 00:23:53 heisenberg kernel: [   31.941217] EXT4-fs (dm-2):
ext4_orphan_cleanup: deleting unreferenced inode 2016232
May  6 00:23:53 heisenberg kernel: [   31.941228] EXT4-fs (dm-2):
ext4_orphan_cleanup: deleting unreferenced inode 2016231

... and some (at least to me) worrying questions during fsck.

However, I constantly get these errors:
[  331.744025] EXT4-fs (dm-2): error count: 10
[  331.744030] EXT4-fs (dm-2): initial error at 1304673122:
ext4_mb_generate_buddy:731
[  331.744034] EXT4-fs (dm-2): last error at 1304673124: ext4_remount:4250
... (probably) when reading some files. I guess it's reading files, at
least it happens during a debsums run (checks the package sums of more or
less all Debian packages installed).
Also the numbers in the errors above, are (at least until know, and as far
as I looked after it) the same.

It also happens (as far as I can see) only once, i.e. if the error has
already occurred, and I do e.g. my debsums again, it's not printed again.

fsck runs through fine (but quite quick; yes - of course - I've used -f)

Any ideas? (Please CC me as I'm off list).


Cheers,
Chris.


btw:
This (occuring in the host's kernel log and not the VM's)
[  325.655192] EXT4-fs (dm-2): Unaligned AIO/DIO on inode 1060986 by
VirtualBox; performance will be poor.
means that the blocks of the the guest are not aligned to the blocks of
the host, right?
But why is it only printed once?
