From: Angelo Dureghello <angelo70@gmail.com>
Subject: ext4 errors on kernel 3.17.0
Date: Fri, 14 Nov 2014 17:52:37 +0100
Message-ID: <54663355.2080903@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:42267 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161278AbaKNQwj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 14 Nov 2014 11:52:39 -0500
Received: by mail-wi0-f170.google.com with SMTP id r20so31260wiv.5
        for <linux-ext4@vger.kernel.org>; Fri, 14 Nov 2014 08:52:38 -0800 (PST)
Received: from [192.168.0.2] (host223-233-dynamic.50-79-r.retail.telecomitalia.it. [79.50.233.223])
        by mx.google.com with ESMTPSA id q10sm40288872wjq.35.2014.11.14.08.52.37
        for <linux-ext4@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Fri, 14 Nov 2014 08:52:37 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dear all,

i am running kernel 3.17.0 (migrating from 3.5.1) on an am1808 (arm)
based custom board, with a microsd card formatted ext4.

Strangely, starting from a new formatted ext4 partition (mkfs.ext4)
after some files are written from a running application, i getseveral
errors trying fsck.ext4 or trying to remove the files manually (rm):


[root@barix media]# fsck.ext4 /dev/mmcblk0p1
e2fsck 1.42.4 (12-June-2012)
ext2fs_check_desc: Corrupt group descriptor: bad block for block bitmap
fsck.ext4: Group descriptors look bad... trying backup blocks...
/dev/mmcblk0p1 was not cleanly unmounted, check forced.
Resize inode not valid.  Recreate<y>? Automount: /dev/mmcblk0p1 inserted
Automount: DEVICE LOCK found quiting...

[root@barix mmcsd0p1]# rm -r soundscape/
EXT4-fs error (device mmcblk0p1): ext4_lookup:1441: inode #260611: comm 
rm: 'streams' linked to parent dir
rm: can't stat 'EXT4-fs warning (device mmcblk0p1): empty_dir:2520: bad 
directory (dir #260611) - no `.' or `..'
soundscape/set_1/configuration/streams/streams': Input/output error
EXT4-fs warning (device mmcblk0p1): empty_dir:2520: bad directory (dir 
#260618) - no `.' or `..'
EXT4-fs warning (device mmcblk0p1): empty_dir:2520: bad directory (dir 
#260615) - no `.' or `..'
EXT4-fs warning (device mmcblk0p1): empty_dir:2520: bad directory (dir 
#260616) - no `.' or `..'
EXT4-fs error (device mmcblk0p1): ext4_lookup:1448: inode #260617: comm 
rm: deleted inode referenced: 260611
rm: can't stat 'EXT4-fs warning (device mmcblk0p1): empty_dir:2520: bad 
directory (dir #260617) - no `.' or `..'
soundscape/set_1/firmware/streams': Input/output error
EXT4-fs error (device mmcblk0p1): ext4_lookup:1448: inode #260619: comm 
rm: deleted inode referenced: 260611
rm: can't stat 'EXT4-fs warning (device mmcblk0p1): empty_dir:2520: bad 
directory (dir #260619) - no `.' or `..'
soundscape/set_1/schedule/streams': Input/output error
EXT4-fs error (device mmcblk0p1): ext4_lookup:1448: inode #260610: comm 
rm: deleted inode referenced: 260611
rm: can't stat 'soundscape/downloads/streams': Input/output error
rm: can't remove 'soundscape/downloads': Directory not empty
rm: can't remove 'soundscape': Directory not empty
[root@barix mmcsd0p1]#

I cannot reproduce these errors on kernel 3.5.1.

Every help is very appreciated.
Angelo
