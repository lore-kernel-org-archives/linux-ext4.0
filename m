From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [Bugme-new] [Bug 9855] New: ext3 ACL corruption
Date: Thu, 31 Jan 2008 08:58:09 -0600
Message-ID: <47A1E201.7070801@redhat.com>
References: <bug-9855-10286@http.bugzilla.kernel.org/> <20080130144930.e23f78de.akpm@linux-foundation.org> <20080131074916.GN23836@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, Andreas Gruenbacher <agruen@suse.de>,
	bugme-daemon@bugzilla.kernel.org, kmshanah@ucwb.org.au,
	"Theodore Ts'o" <tytso@mit.edu>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:41078 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753566AbYAaO63 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 31 Jan 2008 09:58:29 -0500
In-Reply-To: <20080131074916.GN23836@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> On Jan 30, 2008  14:49 -0800, Andrew Morton wrote:
>>> Problem Description:

>>> Inode size:               256     
> 
> This is a bit interesting, since it isn't very common to use large inodes.
> I suspect this relates to the problem.

I think it is somewhat common on samba servers, though.

And it's the new default in the latest e2fsprogs... maybe something will
shake out in the F9 development cycle.

>>> These are production Samba servers making fairly extensive use of file and
>>> directory ACLs. Thus far, I've only noticed the corruptions when it came time
>>> to upgrade to a new kernel and reboot (and the boot scripts then run fsck).
>>> Note that I've never noticed any issues at runtime because of this - only when
>>> I later realised that ACLs had been removed from random files and/or
>>> directories.
>>>
>>> I think I will implement some scripts to unmount and run fsck nightly from
>>> cron, so I can at least detect the corruption a little earlier. If there is
>>> some more helpful debugging output I can provide, please let me know.
> 
> There is just such a script in the thread "forced fsck (again?)".  Since you
> are using LVs for the filesystem.

Which is on the ext3-users list btw...

> If you are able to reproduce this, could you please dump the inode and EA
> block before fixing the problem.

Do you need instructions on doing that?

-Eric
