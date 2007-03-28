From: Jan Kara <jack@suse.cz>
Subject: Re: Ext3 behavior on power failure
Date: Wed, 28 Mar 2007 14:40:16 +0200
Message-ID: <20070328124015.GG14935@atrey.karlin.mff.cuni.cz>
References: <A74E8B4A356D8143B79BBEB839421F3004023496@CORPUSMX20B.corp.emc.com> <4603B03E.7080302@emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: armangau_philippe@emc.com, ext3-users@redhat.com,
	linux-ext4@vger.kernel.org, csar@stanford.edu
To: Ric Wheeler <ric@emc.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:38060 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbXC1MkS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 28 Mar 2007 08:40:18 -0400
Content-Disposition: inline
In-Reply-To: <4603B03E.7080302@emc.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> armangau_philippe@emc.com wrote:
> >Hi all,
> >
> >We are building a new system which is going to use ext3 FS. We would like 
> >to know more about the behavior of ext3 in the case of failure.  But 
> >before I procede, I would like to share more information about our future 
> >system. 
> >*	Our application always does an fsync on files
> >*	When symbolic links (more specifically fast symlink) are created, 
> >the host directory is also fsync'ed. *	Our application is also 
> >going to front an EMC disk array configured using RAID5 or RAID6.
> >*	We will be using multipathing  so that we can assume that no disk 
> >errors will be reported. 
> >In this context , we would like to know the following for recovery after a 
> >power outage:
> >
> >1.	When will an fsck have to be run (not counting  the scheduled fsck 
> >every N-mounts)?
> >2.	In the case of a crash, are the fsync-ed file contents and symbolic 
> >links safe no matter what?
> >
> >Thanks,
> 
> This is an interesting twist on some of the discussion that we have had 
> at the recent workshop and in other forums on hardening  file system in 
> order to prevent the need to fsck.
> 
> The twist is that we have a disk that will not lose power without being 
> able to write to platter all of the data that has been sent - this is 
> the case for most mid-range or higher disk arrays.
> 
> If the application can precisely use fsync() on files, directories and 
> symlinks, it wants to know that all objects are safe on disk that have 
> completed a successful fsync. It also wants to know that the file system 
> will not need any recovery beyond replaying transactions after a power 
> outage/reboot - simply mount, let the transactions get replayed and you 
> should be good to go without the fsck.
> 
> The hard part of the question is to understand when and how often we 
> will fail to deliver this easy case. Also, does any of the hardening in 
> ext4 help here.
  I'm probably misunderstanding something because the answer seems to be
too obvious to me :) But anyway I'll write it so that you can correct
me:
  Due to journalling guarantees you should get consistent FS whenever
you replay the log (unless there are some software bugs or hardware
problems which is why fsck is run once per several mounts anyway).
  If you fsync() your data, you are guaranteed that also your data are
safely on disk when fsync returns. So what is the question here?

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
