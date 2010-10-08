From: Dmitry <dmonakhov@openvz.org>
Subject: Re: DRAFT Design Spec for 1st Class Quota Support in Ext4
Date: Fri, 08 Oct 2010 08:19:47 +0400
Message-ID: <87k4lts4d8.fsf@dmon-lap.sw.ru>
References: <E1O6I3M-0002Wl-CV@closure.thunk.org> <87y6gad45r.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:20052 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750842Ab0JHET7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 8 Oct 2010 00:19:59 -0400
In-Reply-To: <87y6gad45r.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 26 Apr 2010 12:11:28 +0400, Dmitry Monakhov <dmonakhov@openvz.org> wrote:
> "Theodore Ts'o" <tytso@mit.edu> writes:
> 
> > Please comment!
> >
> > 		    1st Class Quota Support in Ext4
> > 		    DRAFT Design Specification, v0.5
> >
> >
> > This proposal promotes quota to being a first class supported feature in
> > ext4.  To do this, we will do the following:
> >
> > 1)  We define the following two new fields to the superblock.  No new
> > COMPAT features are defined; since unused superblock fields are zero, if
> > the fields are not known.
> >   *) A superblock field containing the inode number for the user quota
> >      file.  This inode number will be 3 if the inode is user quota file
> >      is hidden.  If this field is zero, then user quotas will not be tracked.
> >   *) A superblock field containing the inode number for the group quota
> >      file.  This inode number will be 4 if the inode is group quota file
> >      is hidden.  If this field is zero, then group quotas will not be
> >      tracked.
> >
I hope, that it is no too late for new thoughts.

While working on generic quota code i've realized what we can make
journalled quota accounting almost for free.

Today it is painful because
1) each quota modification result in quota write 
   make_quota_dirty
     ->write_quota
       which means
       1A) i_mutex on quota file
       1B) locks for quota-info and buffer on data copy.
       1C) locking in journal internals.

It is relatively easy to solve (1A) and was already discussed,
just skip it if quota already exist on the disk.

But others issues are also solvable. Here is an idea:
1) dquot should contain per_cpu counters 
   {
      per_cpu_ptr b_reserved;
      per_cpu_ptr b_current;
      per_cpu_ptr i_current;
   };
  This allow us to make charge/claim/free path lock-less if we do not
  care about quota_limits. Even with limits we can avoid synchronization
  (i hope) in most cases if consider per_cpu variables as preallocation
  buckets.
  Off course per_cpu vars comes with the cost of memory, but in most cases
  we have hundreds of dquot objects per sb or even less.

2) Change quota mark_dirty policy like follows
   2A) Remember transaction id inside dquot object
       and if transaction is the same as before just exit.
   2B) If transaction not the same do:
         get_write_access(bh)
         /* do not copy quota data yet */
         hanle_dirty_metadata(bh, &quota_copy_callback)
       quota_copy_callback will be attached to journal_head and will
       be called by jbd2 on transaction commit or on starting new
       transaction. That callback will copy data from quota-info,
       and at this moment we do need synchronization with chargers,
       but only once for each transaction.
   Changes in jbd2 doesn't look so scary. And performance gain seems
   promising.

I'll try to come up with the proof of concept path soon.
BTW what are current ETAs for huge ext4-quota changes?
> I now that it is always not right time for ask about this, but still.
> Don't you mind to reserve 5'th inode number for projectID quota?
> > 2) The quota files will use the v2 format only, and updates to the quota
> > files will be protected with the journal if the journal is present.
> Since we are about to starting huge movements let's use new (v3) quota
> format. The only difference with v2 is extended header wider than old
> magic+version.
> 
> struct v3_disk_dqheader {
>         __le32 dqh_magic;        /* Magic number identifying file */
>         __le32 dqh_version;      /* File version */
>         __le32 dqh_state;        /* quota file  state */
>         __u32  dqh_reserved[125];
>  };
> dqh_state is an equivalent of sb's s_state.
> >
> > 3) If e2fsck needs to do a full file system consistency check, it will
> > keep track of the disk space used by each user and/or groups ids, and
> > update the user and/or group quota files at the end of the e2fsck run.
> >
> > 4) If the filesystem appears consistent, but the user and/or group quota
> > fils are not equal to the last superblock write time, e2fsck will do a
> > partical file system consistency check.  This will consist of e2fsck
> > pass #1, and if no errors were detected, e2fsck will update the user and
> > group quota files and exit.  If any errors were detected during pass #1,
> > then e2fsck will  continue to do pass numbers 2-5, and thus do a full
> > file system consistency check before updating the quota files.
> >
> > 5) Mke2fs will take an extended option (quota=user,group) which if
> > present will force the initialization of the quota inodes.  Using the
> > /etc/mke2fs.conf file, the system administrator can also specify a quota
> > option in the [defaults] and [fs_types] section, so that quota files can
> > be enabled by default.
> >
> > 6) Tune2fs will have a facility for adding and removing user and group
> > quotas inodes while the file system is mounted.  The quota usage will
> > not be correct after the quota inodes are newly added, however, so quota
> > will not be enabled by default,  If the quota inodes are removed, quota
> > will be disabled first.
>   Who is responsible for quota enabling in that scenario?
>   Will it enabled by default on mount time?
> 
> Small note: quotacheck -cug /mnt will result in unlink/create
> so we have options exclusive options:
> if inode is already exist
>   replace unlink/create with truncate
> else
>   call tune2fs from quotacheck after inodes was created.
> >
> > 7) There will be a new interface so that bulk quota information can be
> > fetched from the file system.  This needs to be negotiated with Jan
> > Kara.  It can either be a new system call, or a magic file in /proc that
> > can be opened and the repquota data extracted.
> >
> > 8) Traditional style quota will still be supported; that is the
> > appropriate magic flags will be passed through to /proc/mounts so that
> > the old-style init scripts will still function correctly.  This support
> > will be deprecated over an 18 month period after the new-style kernel
> > code and userspace tools have been released.
>   9) Make ext4_orphan_cleanup() more tolerate to quota, if quota is 
>   enabled for given SB, but cleanup procedure is unable to perform
>   ext4_quota_on_mount() mount should fail as it does in case of wrong
>   options.
> 
> The rest is looking very promising.
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
