From: Andreas Dilger <adilger@sun.com>
Subject: Re: [Bugme-new] [Bug 9855] New: ext3 ACL corruption
Date: Thu, 31 Jan 2008 00:49:16 -0700
Message-ID: <20080131074916.GN23836@webber.adilger.int>
References: <bug-9855-10286@http.bugzilla.kernel.org/>
 <20080130144930.e23f78de.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org, Andreas Gruenbacher <agruen@suse.de>,
	bugme-daemon@bugzilla.kernel.org, kmshanah@ucwb.org.au,
	"Theodore Ts'o" <tytso@mit.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:45093 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758808AbYAaHtT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 31 Jan 2008 02:49:19 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m0V7nIhj014156
	for <linux-ext4@vger.kernel.org>; Wed, 30 Jan 2008 23:49:18 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JVI00D010ANO700@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Wed, 30 Jan 2008 23:49:18 -0800 (PST)
In-reply-to: <20080130144930.e23f78de.akpm@linux-foundation.org>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jan 30, 2008  14:49 -0800, Andrew Morton wrote:
> > Problem Description:
> > On several occasions now I have had e2fsck prune away ACLs on my file systems
> > during a file system check after rebooting a number of (reasonably) long
> > running Samba servers. This morning I decided to manually run fsck before
> > rebooting one of these:
> > 
> > # e2fsck -pfv /dev/mapper/vg_main-lv_samba
> > (entry->e_value_offs + entry->e_value_size: 116, offs: 120)
> > /dev/mapper/vg_main-lv_samba: Extended attribute in inode 163841 has a value
> > offset (56) which is invalid
> > CLEARED.
> > (entry->e_value_offs + entry->e_value_size: 116, offs: 120)
> > /dev/mapper/vg_main-lv_samba: Extended attribute in inode 262146 has a value
> > offset (56) which is invalid
> > CLEARED.

While these error messages still exist in e2fsck, this code appears to
have been changed somewhat because these same error messages no longer
get printed in e2fsprogs 1.40.5.

> > Inode size:               256     

This is a bit interesting, since it isn't very common to use large inodes.
I suspect this relates to the problem.

> > These are production Samba servers making fairly extensive use of file and
> > directory ACLs. Thus far, I've only noticed the corruptions when it came time
> > to upgrade to a new kernel and reboot (and the boot scripts then run fsck).
> > Note that I've never noticed any issues at runtime because of this - only when
> > I later realised that ACLs had been removed from random files and/or
> > directories.
> > 
> > I think I will implement some scripts to unmount and run fsck nightly from
> > cron, so I can at least detect the corruption a little earlier. If there is
> > some more helpful debugging output I can provide, please let me know.

There is just such a script in the thread "forced fsck (again?)".  Since you
are using LVs for the filesystem.

If you are able to reproduce this, could you please dump the inode and EA
block before fixing the problem.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
