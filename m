From: Matthias Erll <merll@web.de>
Subject: Re: [Bug 42859] New: kernel BUG at fs/ext4/extents.c:1953
Date: Sun, 04 Mar 2012 23:11:00 +0100
Message-ID: <4F53E874.5050201@web.de>
References: <bug-42859-13602@https.bugzilla.kernel.org/> <20120304202708.GA9087@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, bugzilla-daemon@bugzilla.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fmmailgate04.web.de ([217.72.192.242]:59361 "EHLO
	fmmailgate04.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755727Ab2CDWLD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 4 Mar 2012 17:11:03 -0500
Received: from moweb001.kundenserver.de (moweb001.kundenserver.de [172.19.20.114])
	by fmmailgate04.web.de (Postfix) with ESMTP id 34A4D7322459
	for <linux-ext4@vger.kernel.org>; Sun,  4 Mar 2012 23:11:02 +0100 (CET)
In-Reply-To: <20120304202708.GA9087@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

Am 04.03.12 21:27, schrieb Ted Ts'o:
> On Sun, Mar 04, 2012 at 02:39:09PM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
>> Messages "kernel BUG at fs/ext4/extents.c:1953" occur, which seem to be
>> triggered when running certain processes (reproducible with init and gdm). The
>> volume can be mounted without any apparent problems and e2fsck does not report
>> any errors. Nevertheless, the file system may have been corrupted during an
>> earlier system crash.
> Would you be willing to apply the following patch, and then see which
> inode number gets reported (and whether it is always the same inode
> number or one that varies) and then report back the results of running
> the following debugfs commands?
>
> (assuming the inode number is 12345)
>
> debugfs /dev/sdX
>
> debugfs: stat <12345>
> degbufs: ex <12345>

In the three cases I can reproduce, the inode number has been identical.
Please find the debugfs output below.

Kind regards,
Matthias




debugfs /dev/sda2
debugfs 1.42.1 (17-Feb-2012)

debugfs: stat <1312385>
Inode: 1312385   Type: regular    Mode:  0664   Flags: 0x80000
Generation: 1339335381    Version: 0x00000000:00000001
User:     0   Group:   406   Size: 0
File ACL: 0    Directory ACL: 0
Links: 1   Blockcount: 0
Fragment:  Address: 0    Number: 0    Size: 0
 ctime: 0x4f53e0ab:3c51ed20 -- Sun Mar  4 22:37:47 2012
 atime: 0x4eda803c:da6fb35c -- Sat Dec  3 21:02:04 2011
 mtime: 0x4f53e0ab:3bd7da30 -- Sun Mar  4 22:37:47 2012
crtime: 0x4eda803c:da6fb35c -- Sat Dec  3 21:02:04 2011
Size of extra inode fields: 28
EXTENTS:

debugfs: ex <1312385>
Level Entries       Logical          Physical Length Flags
 0/ 0   1/  1     0 - 4294967295 5276276 - 4300243571      0


