From: Andreas Friedrich Berendsen <afberendsen@gmail.com>
Subject: Re: May I suggested an update for ext4.txt file?
Date: Wed, 25 Feb 2009 06:14:21 +1300
Message-ID: <1235495661.11758.40.camel@localhost.localdomain>
References: <1235494800.11758.28.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:29184 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586AbZBXROb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Feb 2009 12:14:31 -0500
Received: by yw-out-2324.google.com with SMTP id 5so1096971ywh.1
        for <linux-ext4@vger.kernel.org>; Tue, 24 Feb 2009 09:14:28 -0800 (PST)
In-Reply-To: <1235494800.11758.28.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>From http://kernelnewbies.org/Ext4 "3.2. Migrate existing Ext3
filesystems to Ext4", instructions to migrate are different from the
ext4.txt file:

/* ----------------------- */

You need to use the tune2fs and fsck tools in the filesystem, and that
filesystem needs to be unmounted. Run: 


      * tune2fs -O extents,uninit_bg,dir_index /dev/yourfilesystem 
        

After running this command you MUST run fsck. If you don't do it, Ext4
WILL NOT MOUNT your filesystem. 

/* -------------------------- *

-- Berendsen

----Original Message-----
From: Andreas Friedrich Berendsen <afberendsen@gmail.com>
To: linux-ext4@vger.kernel.org
Subject: May I suggested an update for ext4.txt file?
Date: Wed, 25 Feb 2009 06:00:07 +1300

kernel 2.6.28.7
efs2prog: 1.41.4

File Documentation/filesystems/ext4.txt states:

...
    Or to configure an existing ext3 filesystem to support extents:

        # tune2fs -O extents /dev/hda1
....


To convert from ext2 (a very old filesystem :) ) to ext4, it's necessary
to add more options. I'm not sure which one made the trick.

tune2fs -O
has_journal,dir_index,filetype,extent,flex_bg,sparse_super,large_file,huge_file,uninit_bg,dir_nlink,extra_isize 

Also, /etc/filesystems does not contain an entry for
ext4. /etc/efs2prog.conf is ok.

-- Berendsen

-- 
__________________________________________
Andreas Friedrich Berendsen
SCA OCP MSCA A+ Linux+ Network+ HpMASE

