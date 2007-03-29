From: Jan Kara <jack@suse.cz>
Subject: Re: Ext3 behavior on power failure
Date: Thu, 29 Mar 2007 10:00:59 +0200
Message-ID: <20070329080059.GA7698@duck.suse.cz>
References: <A74E8B4A356D8143B79BBEB839421F3004023496@CORPUSMX20B.corp.emc.com>
	<4603B03E.7080302@emc.com>
	<20070328124015.GG14935@atrey.karlin.mff.cuni.cz>
	<460AF3A6.403@emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: csar@stanford.edu, linux-ext4@vger.kernel.org,
	ext3-users@redhat.com
To: Ric Wheeler <ric@emc.com>
Return-path: <ext3-users-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <460AF3A6.403@emc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/ext3-users>,
	<mailto:ext3-users-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/ext3-users>
List-Post: <mailto:ext3-users@redhat.com>
List-Help: <mailto:ext3-users-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/ext3-users>,
	<mailto:ext3-users-request@redhat.com?subject=subscribe>
Sender: ext3-users-bounces@redhat.com
Errors-To: ext3-users-bounces@redhat.com
List-Id: linux-ext4.vger.kernel.org

On Wed 28-03-07 19:00:54, Ric Wheeler wrote:
> Jan Kara wrote:
> >>armangau_philippe@emc.com wrote:
> >>>Hi all,
> >>>
> >>>We are building a new system which is going to use ext3 FS. We would 
> >>>like to know more about the behavior of ext3 in the case of failure.  
> >>>But before I procede, I would like to share more information about our 
> >>>future system. 
> >>>*	Our application always does an fsync on files
> >>>*	When symbolic links (more specifically fast symlink) are created, 
> >>>the host directory is also fsync'ed. *	Our application is also 
> >>>going to front an EMC disk array configured using RAID5 or RAID6.
> >>>*	We will be using multipathing  so that we can assume that no disk 
> >>>errors will be reported. 
> >>>In this context , we would like to know the following for recovery after 
> >>>a power outage:
> >>>
> >>>1.	When will an fsck have to be run (not counting  the scheduled fsck 
> >>>every N-mounts)?
> >>>2.	In the case of a crash, are the fsync-ed file contents and symbolic 
> >>>links safe no matter what?
> >>>
> >>>Thanks,
> >>This is an interesting twist on some of the discussion that we have had 
> >>at the recent workshop and in other forums on hardening  file system in 
> >>order to prevent the need to fsck.
> >>
> >>The twist is that we have a disk that will not lose power without being 
> >>able to write to platter all of the data that has been sent - this is 
> >>the case for most mid-range or higher disk arrays.
> >>
> >>If the application can precisely use fsync() on files, directories and 
> >>symlinks, it wants to know that all objects are safe on disk that have 
> >>completed a successful fsync. It also wants to know that the file system 
> >>will not need any recovery beyond replaying transactions after a power 
> >>outage/reboot - simply mount, let the transactions get replayed and you 
> >>should be good to go without the fsck.
> >>
> >>The hard part of the question is to understand when and how often we 
> >>will fail to deliver this easy case. Also, does any of the hardening in 
> >>ext4 help here.
> >  I'm probably misunderstanding something because the answer seems to be
> >too obvious to me :) But anyway I'll write it so that you can correct
> >me:
> >  Due to journalling guarantees you should get consistent FS whenever
> >you replay the log (unless there are some software bugs or hardware
> >problems which is why fsck is run once per several mounts anyway).
> >  If you fsync() your data, you are guaranteed that also your data are
> >safely on disk when fsync returns. So what is the question here?
> >
> >								Honza
> 
> I think that the real question here is in practice, how often does this 
> really hold to be true? When it fails, how long does it take to recover the 
> file system?
  I see, thanks for explanation :).

> There are a lot of odd errors that can happen when you monitor a large 
> enough number of file systems. In my experience, I would guess that disk 
> errors are clearly the leading cause of issues, followed by software bugs 
> (file system, firmware, etc) and then a group of errors caused by various 
> occasional things (bad DRAM in the server/HBA/disk, bad cables/etc). Note 
> that using a high end array does not eliminate errors, it just reduces the 
> rate (hopefully by a large amount).
> 
> What is really hard to predict is the rate of the failures that require 
> fsck with our current file system (say for a specific hardware setup) and 
> how changes like the checksumming in ext4 can help us ride through these 
> errors without needing a full fsck.
  OK. All the features I've seen so far were more aiming to detecting that
such an unexpected problem happened rather than trying to fix it or make
fixing it faster. So currently it seems to me that any such unexpected
failure requires fsck...

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
