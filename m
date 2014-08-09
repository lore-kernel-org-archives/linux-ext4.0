From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 0/4] quota: add project quota support
Date: Sun, 10 Aug 2014 08:14:53 +1000
Message-ID: <20140809221453.GL20518@dastard>
References: <CAPTn0cAKi64Fh1pAVTDLvSS5-1Kjv7KN2HpGxtm4J8-ym-4nOQ@mail.gmail.com>
 <20140808223335.GQ25145@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Li Xi <pkuelelixi@gmail.com>, linux-fsdevel@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	viro@ZenIV.linux.org.uk, hch@infradead.org, Jan Kara <jack@suse.cz>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140808223335.GQ25145@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Aug 08, 2014 at 06:33:35PM -0400, Theodore Ts'o wrote:
> On Sat, Aug 09, 2014 at 12:39:58AM +0800, Li Xi wrote:
> > 
> > It is obvious that extended attribute implementation has performance
> > impact when creating files. That is why we choose to push the patches
> > which use internal inode field to save project ID.
> 
> Were you using 256-byte inodes or 128-byte inodes when you benchmarked
> using xattr versus an in-inode project quota?
> 
> The other major comment I have is that as much as possible, the
> semantics should be compatible xfs's project quota.  In particular,
> this bit:
> 
>        A managed tree must be setup initially  using  the  -s  option  to  the
>        project command. The specified project name or identifier is matched to
>        one or more trees defined in /etc/projects, and these  trees  are  then
>        recursively descended to mark the affected inodes as being part of that
>        tree.  This process sets an inode flag and the  project  identifier  on
>        every  file  in  the affected tree.  Once this has been done, new files
>        created in the tree will automatically be accounted to the  tree  based
>        on  their  project  identifier.   An attempt to create a hard link to a
>        file in the tree will only succeed if the  project  identifier  matches
>        the project identifier for the tree.  The xfs_io utility can be used to
>        set the project ID for an arbitrary file, but this can only be done  by
>        a privileged user.
> 
> Note the hard link restriction.  And we should check with the XFS
> folks what happens if you move a file from one directory which belongs
> to one project quota to another directory which has a different
> project quota (or no quota whatsoever).

Rename to a destination with a different project quota gives EXDEV,
same as if you were trying to rename across different filesystems.
See xfs_rename().

> I suspect the right answer is
> that the quota gets transferred from one project to another, so that
> it is a true directory-tree quota system,

XFS doesn't transfer the quota from projid to projid because it's
borderline impossible to correctly track all the metadata
allocation/free operations that can happen in a rename operation and
account them to the correct quota. Hence all those corner cases are
avoided by treating it as EXDEV and forcing userspace to cp/unlink
the files rather than rename.

That's really an implementation detail.

> but regardless, if we're
> going to go down this path, let's stay consistent with how XFS does
> things.

Agreed. I also think they shoul duse the same userspace quota
interface, so you can use xfs_quota to manage project quotas on both
ext4 and XFS. That way all the xfstests that test project quota
behaviour will work on ext4 without modification, and tests written
for ext4 should also work on XFS.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
