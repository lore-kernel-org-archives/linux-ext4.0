From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: fsck ate my ext4 home partition, help!?
Date: Mon, 4 May 2009 22:33:05 -0700 (PDT)
Message-ID: <alpine.DEB.2.01.0905042222260.6162@bogon.housecafe.de>
References: <20090504131128.135100@gmx.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org
To: Marcel Partap <mpartap@gmx.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.177]:53061 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697AbZEEFdI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 May 2009 01:33:08 -0400
In-Reply-To: <20090504131128.135100@gmx.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 4 May 2009, Marcel Partap wrote:
> check over it. Unmounting went successful, however fsck complained about 
> /dev/sdd4 still being mounted. After confirming (lsof, mtab, empty mount 

Have you checked /proc/mounts? mtab could be stale, lsof not seeing 
everything and the "empty mountpoint" could be some other mount on top of 
/home.

> previous run of e2fsck with the -n was showing a bunch of stuff to fix, 

Do you still have that e2fsck output?

> revealed the havoc that was done: ls -laR showed abundant I/O errors, 

Again: error messages would be helpful.

> If someone can actually help me to get it back in the state it was
> before invoking e2fsk,

You did not take the dd image before the first e2fsck, hm? Now that you 
have a backup: a few days ago a tool called "extundelete"[0] has been 
annunced on ext3-users, maybe that can be of help recovering your fs.

> For the record, i am running kernel 2.6.30 RC3 with gentoo's 
> e2fsprogs-1.41.3.. and i have not rebooted the system since the incident 

e2fsprogs-1.41.5 has been released recently, you might want to give it a 
shot.

Christian.

[0] http://extundelete.sf.net/
-- 
Perfect Forward Secrecy is when Bruce Schneier whispers something in your ear.
