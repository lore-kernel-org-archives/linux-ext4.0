From: Kevin Shanahan <kmshanah@ucwb.org.au>
Subject: Possible ext4 corruption - ACL related?
Date: Tue, 10 Mar 2009 10:13:17 +1030
Message-ID: <1236642197.30280.18.camel@kulgan.wumi.org.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bowden.ucwb.org.au ([203.122.237.119]:45568 "EHLO
	mail.ucwb.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181AbZCJANb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Mar 2009 20:13:31 -0400
Received: from [192.168.1.16] (cubit.disenchant.net [150.101.102.147])
	by mail.ucwb.org.au (Postfix) with ESMTP id 0253C4BD0F
	for <linux-ext4@vger.kernel.org>; Tue, 10 Mar 2009 10:13:17 +1030 (CST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I think we have some minor corruption happening with a new (about two
weeks old) ext4 file system. Our backup script spat out bunch of errors
last night while trying to read the file ACLs:

getfacl: apps/Gestalt.Net/SetupCD/program\040files/Business\040Objects/Common/3.5/bin/Cdo32sv.dll: Input/output error
getfacl: apps/Gestalt.Net/SetupCD/program\040files/Business\040Objects/Common/3.5/bin/U3520chs.dll: Input/output error
getfacl: apps/Gestalt.Net/SetupCD/program\040files/Business\040Objects/Common/3.5/bin/ReportRenderer.dll: Input/output error
getfacl: apps/Gestalt.Net/SetupCD/program\040files/Business\040Objects/Common/3.5/bin/ParameterDesigner.dll: Input/output error
...

And in syslog I see these warnings from the kernel:

Mar 10 00:06:01 hermes /USR/SBIN/CRON[10875]: (root) CMD (   /usr/local/bin/rsync-backup-all.sh)
Mar 10 00:06:24 hermes kernel: init_special_inode: bogus i_mode (53253)
Mar 10 00:06:24 hermes kernel: attempt to access beyond end of device
Mar 10 00:06:24 hermes kernel: dm-0: rw=0, want=1312475392770056, limit=2147483648
Mar 10 00:06:25 hermes kernel: attempt to access beyond end of device
Mar 10 00:06:25 hermes kernel: dm-0: rw=0, want=1312475392770056, limit=2147483648

The filesystem is still in use (and working okay, AFAICT), but I'll need
to fsck this tonight. Is there any useful data I can gather from the fs
before (or while) I do that which might help track down the cause?

This system has been running 2.6.29-rc6 (x86_64) since this filesystem
was created. I did a quick scan of the ext4 commits since then, but none
of them obviously address this unless maybe it's related to 7ce9d5d -
    "ext4: fix ext4_free_inode() vs. ext4_claim_inode() race"

Regards,
Kevin.


