From: Dave Edwards <ext2@dpe.lusars.net>
Subject: Newbie ext2 forensics question...
Date: Fri, 29 Sep 2006 04:47:38 +0000 (UTC)
Message-ID: <loom.20060929T063450-383@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:16847 "EHLO ciao.gmane.org")
	by vger.kernel.org with ESMTP id S932538AbWI2EzY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 29 Sep 2006 00:55:24 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1GTAOs-00067n-L6
	for linux-ext4@vger.kernel.org; Fri, 29 Sep 2006 06:55:02 +0200
Received: from c-69-143-110-97.hsd1.va.comcast.net ([69.143.110.97])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Fri, 29 Sep 2006 06:55:02 +0200
Received: from ext2 by c-69-143-110-97.hsd1.va.comcast.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Fri, 29 Sep 2006 06:55:02 +0200
To: linux-ext4@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I'm trying to tune a linux system to spin down its (ext2-formatted) disk when
the system is idle. I've worked down to two problematic applications that
periodically spin up the disk, even though the (tiny) file they're writing is
(allegedly) on a tmpfs partition (/tmp/application/datafile, as it happens).
Enabling the vm debugging gets me output like:

kjournald(303): WRITE block 151824 on hda1
kjournald(303): WRITE block 151832 on hda1
kjournald(303): WRITE block 151840 on hda1
kjournald(303): WRITE block 151848 on hda1
kjournald(303): WRITE block 151856 on hda1
kjournald(303): WRITE block 151864 on hda1
pdflush(135): WRITE block 258211840 on hda1
pdflush(135): WRITE block 258211848 on hda1
pdflush(135): WRITE block 258211856 on hda1
pdflush(135): WRITE block 258310144 on hda1
pdflush(135): WRITE block 0 on hda1
pdflush(135): WRITE block 16 on hda1
pdflush(135): WRITE block 64 on hda1
pdflush(135): WRITE block 56098816 on hda1
pdflush(135): WRITE block 56100968 on hda1
pdflush(135): WRITE block 61079552 on hda1

(hda1 is an ext2-formatted partition, mounted noatime)

Is there any way to work back from block to inode to (hopefully) location in the
directory structure this is happening? For some reason, I don't get app and file
name (like I do with other programes), just some blocks that the disk got spun
up to write.

My appologies if there's a well-known tool for doing this; the furthest down
I've been able to dig is the inode level.

