From: "Dr. Tilmann Bubeck" <t.bubeck@reinform.de>
Subject: Use EXT4_BOOT_LOADER_INO for boot loader GRUB?
Date: Fri, 25 Jan 2013 09:18:50 +0100
Message-ID: <51023FEA.7000802@reinform.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gw1.reinform.de ([82.141.45.9]:47640 "EHLO
	mail-out.dmz.loef.reinform.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751431Ab3AYI3M (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Jan 2013 03:29:12 -0500
Received: from postfix.loef.reinform.de (postfix.loef.reinform.de [10.1.1.39])
	by mail-out.dmz.loef.reinform.de (Postfix) with ESMTP id 93B64A83C3
	for <linux-ext4@vger.kernel.org>; Fri, 25 Jan 2013 09:18:52 +0100 (CET)
Received: from mail.reinform.de (mail.reinform.de [82.141.45.14])
	by postfix.loef.reinform.de (Postfix) with ESMTP id 4E32A1BD84
	for <linux-ext4@vger.kernel.org>; Fri, 25 Jan 2013 08:50:57 +0100 (CET)
Received: from [10.1.1.108] (stick.loef.reinform.de [10.1.1.108])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.reinform.de (Postfix) with ESMTPSA id E614CBB4E4
	for <linux-ext4@vger.kernel.org>; Fri, 25 Jan 2013 09:18:51 +0100 (CET)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

There is a long discussion about booting GRUB2 from a partition 
containing ext2/3/4 (e.g. 
https://bugzilla.redhat.com/show_bug.cgi?id=872826 and many more on the 
net). This is typically a multiboot scenario with a primary boot loader 
in the MBR loading a second bootloader (here "GRUB2") from a partition.

Currently GRUB2 prints an error message when trying to install to a 
ext2/3/4 filesystem with:

"Attempting to install GRUB to a partition instead of the MBR.  This is 
a BAD idea. Embedding is not possible. GRUB can only be installed in 
this setup by using blocklists. However, blocklists are UNRELIABLE and 
their use is discouraged."

The basic problem is, that GRUB needs a safe place to store (currently 
32k) for its boot loader "core.img". That place should be simple to find 
from the primary boot code ("stage1") and the place should be safe for 
user intervention.

QUESTION:

You have reserved a special inode #5 called "EXT4_BOOT_LOADER_INO". Is 
this inode currently used or supported by kernel or user land? What is 
the idea of this inode?

PROPOSAL:

I can think of using that inode to store the file "core.img" of GRUB. 
That file is used by GRUB to boot and the block list of that file is 
stored in GRUB when using "--force" to override the above error.

ext2/3/4 must make sure, that the block list of that file never changes. 
I propose an additional EXT4 ioctl to tell ext4, which file to store in 
EXT4_BOOT_LOADER_INO.

Probably there must be more changes to e2fsck and friends.

Any ideas?

Till

-- 
+-------+-------------------------------------------------------------+
|       | dr. tilmann bubeck               reinform medien- und       |
|       |                                  informationstechnologie AG |
| rein  | fon  : +49 (711) 7 82 76-52      loeffelstr. 40             |
| form  | fax  : +49 (711) 7 82 76-46      70597 stuttgart / germany  |
|    AG | cell.: +49 (172) 8 84 29 72      fon: +49 (711) 75 86 56-10 |
|       | email: t.bubeck@reinform.de      http://www.reinform.de     |
|       +-------------------------------------------------------------+
|       | pflichtangaben nach paragraph 80, AktG:                     |
|       | reinform medien- und informationstechnologie AG, stuttgart  |
|       | handelsregister stuttgart, HRB 23001                        |
|       | vorstand:     dr. tilmann bubeck (vorsitz)                  |
|       | aufsichtsrat: frank stege (vorsitz)                         |
+-------+-------------------------------------------------------------+

