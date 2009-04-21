From: Thierry Vignaud <tvignaud@mandriva.com>
Subject: Re: fsck.ext4: Group descriptors look bad... trying backup blocks...
Date: Tue, 21 Apr 2009 17:14:40 +0200
Message-ID: <m2eivm599b.fsf@vador.mandriva.com>
References: <gs9nm5$8m1$1@ger.gmane.org> <49E8B5AD.6030907@redhat.com>
	<gshfgl$o6m$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jeremy Sanders <jss@ast.cam.ac.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.moondrake.net ([212.85.150.166]:58001 "EHLO
	mx1.mandriva.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750966AbZDUPoK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Apr 2009 11:44:10 -0400
In-Reply-To: <gshfgl$o6m$1@ger.gmane.org> (Jeremy Sanders's message of "Mon\, 20 Apr 2009 10\:33\:09 +0100")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jeremy Sanders <jss@ast.cam.ac.uk> writes:

> However, the system seems to mostly work, so I recreated the ext4 device, 
> I've just run my backup script again and fsck'd the device. It seems the 
> problem is reproducible with the new kernel:
> 
> [root@xback2 ~]# fsck /dev/md0
> fsck 1.41.4 (27-Jan-2009)
> e2fsck 1.41.4 (27-Jan-2009)
> fsck.ext4: Group descriptors look bad... trying backup blocks...
> Group descriptor 0 checksum is invalid.  Fix<y>?
> 
> Looks like there's a real problem in ext4 causing this under certain 
> circumstances (unless an obscure hardware error is somehow giving the same 
> problem).
> 
> To cause this, all I did was rsync a set of directories to the disk. No hard 
> link trees were created.

For the record, I reproduced this bug with 2.6.30-rc2-git6 on a new
1.5Tb disk. Formated as ext4, using relatime, copied 20Gb.
On reboot, I got such errors.
The hd was partitionned (all ext4) as:
/ (5Gb)  |  /usr (20Gb)  |  /pub (1.5Tb)

The smaller system fses didn't saw those errors.
