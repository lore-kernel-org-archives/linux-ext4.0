From: Killian De Volder <killian.de.volder@scarlet.be>
Subject: Recovery after mkfs.ext4 on a ext4
Date: Sun, 15 Jun 2014 10:12:14 +0200
Message-ID: <539D555E.3050707@scarlet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:39482 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbaFOIMT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 15 Jun 2014 04:12:19 -0400
Received: from mfilter12-d.gandi.net (mfilter12-d.gandi.net [217.70.178.129])
	by relay4-d.mail.gandi.net (Postfix) with ESMTP id 3061B172077
	for <linux-ext4@vger.kernel.org>; Sun, 15 Jun 2014 10:12:17 +0200 (CEST)
Received: from relay4-d.mail.gandi.net ([217.70.183.196])
	by mfilter12-d.gandi.net (mfilter12-d.gandi.net [10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id G5RkA73avv-X for <linux-ext4@vger.kernel.org>;
	Sun, 15 Jun 2014 10:12:15 +0200 (CEST)
Received: from [172.17.0.70] (78-20-89-21.access.telenet.be [78.20.89.21])
	(Authenticated sender: killian.de.volder@megasoft.be)
	by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 763AD172067
	for <linux-ext4@vger.kernel.org>; Sun, 15 Jun 2014 10:12:15 +0200 (CEST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Excuse me for requesting this information,
but I could not find any good leads on how to deal with this issue.
Any help would be appreciated.

This is what happened:
I accidentally exported the wrong block-device to a virtual machine.
I ran mkfs.ext4 on this, already mounted ext4, block-device.
As soon as I noticed the error,I stopped it.
It got to "Writing superblocks and file system accounting information".
(After Writing inode tables, and creating journal).

I remounted the filesytem RO on the original mount as soon as possible
and set vfs_cache_pressure to 0 to prevent any cache to move out.
> Jun 11 17:42:15 [kernel] EXT4-fs (xvda8): re-mounted. Opts: errors=remount-ro,barrier=0
> Jun 11 18:06:30 [kernel] EXT4-fs error (device xvda8): htree_dirblock_to_tree:892: inode #2: block 1313: comm ls: bad entry in directory: inode out of bounds - offset=0(0), inode=2751463424, rec_len=16, name_len=0
> Jun 11 18:06:44 [kernel] EXT4-fs error (device xvda8): htree_dirblock_to_tree:892: inode #2: block 1313: comm ls: bad entry in directory: inode out of bounds - offset=0(0), inode=2751463424, rec_len=16, name_len=0
> Jun 11 18:07:58 [kernel] EXT4-fs error (device xvda8): ext4_lookup:1416: inode #6492161: comm ls: deleted inode referenced: 11
This is the kernel log, I don't know if the orginal mount has been writing out new inode-tables or not ?

I was able to copy a good portion of data out,
however due to another issue the server locked up (bug in bcache),
and I had to reset the server.
(I did however not do a dumpe2fs from the vm, I only later learned I could do this.)

Now I'm performing a fsck -nf using scratch files (392k for dirinfo and 20k for icount so far).
However the memory usage is 19.3GiB(I have 16GiB) as a result the process is painstaking slow.

Regardless it got trough the first part of pass1.
Now it's spitting out the following a lot:
> Block #XXXX (XXXX) causes file to be too big.  IGNORED.
> Too many illegal blocks in inode 426.
> Clear inode? no
Debug2fs has the following information:
- volume name -> is still the orginal
- Don't know if UUID changed or not.
- Some group blocks have there there checksum set to 0x0000 (unused inodes 0)
  others have a checksum (unused inodes 2048).
- None of the groups have a valid checksum.

A few questions:
Would it be better if I ran mkfs.ext4 -S ?
Can e2fsck recover the directory structure and/or files in this scenario?
Can I use debugfs to start at a directory inode and then use rdump ?
Should I just revert to file recovery tools like photorec ?
Is there a way to reduce the memory usage during e2fsck in this scenario ?
Other suggestions ?
(Ps don't have room for a full DD, but I could use lvm snapshots, atm the blockdevice is also marked read-only.)

I can live without this data, but it would be better if I could get it back.
(No backup is available, warned several times about it that total data loss was possible at any point.)

Kind regards,
Killian De Volder
(I should also put the reply of this email on the wiki.)
