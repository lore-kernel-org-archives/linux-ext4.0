From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2 0/4] quota: add project quota support
Date: Fri, 8 Aug 2014 18:33:35 -0400
Message-ID: <20140808223335.GQ25145@thunk.org>
References: <CAPTn0cAKi64Fh1pAVTDLvSS5-1Kjv7KN2HpGxtm4J8-ym-4nOQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	viro@ZenIV.linux.org.uk, hch@infradead.org, Jan Kara <jack@suse.cz>
To: Li Xi <pkuelelixi@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51669 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753121AbaHHWdo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 8 Aug 2014 18:33:44 -0400
Content-Disposition: inline
In-Reply-To: <CAPTn0cAKi64Fh1pAVTDLvSS5-1Kjv7KN2HpGxtm4J8-ym-4nOQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Aug 09, 2014 at 12:39:58AM +0800, Li Xi wrote:
> 
> It is obvious that extended attribute implementation has performance
> impact when creating files. That is why we choose to push the patches
> which use internal inode field to save project ID.

Were you using 256-byte inodes or 128-byte inodes when you benchmarked
using xattr versus an in-inode project quota?

The other major comment I have is that as much as possible, the
semantics should be compatible xfs's project quota.  In particular,
this bit:

       A managed tree must be setup initially  using  the  -s  option  to  the
       project command. The specified project name or identifier is matched to
       one or more trees defined in /etc/projects, and these  trees  are  then
       recursively descended to mark the affected inodes as being part of that
       tree.  This process sets an inode flag and the  project  identifier  on
       every  file  in  the affected tree.  Once this has been done, new files
       created in the tree will automatically be accounted to the  tree  based
       on  their  project  identifier.   An attempt to create a hard link to a
       file in the tree will only succeed if the  project  identifier  matches
       the project identifier for the tree.  The xfs_io utility can be used to
       set the project ID for an arbitrary file, but this can only be done  by
       a privileged user.

Note the hard link restriction.  And we should check with the XFS
folks what happens if you move a file from one directory which belongs
to one project quota to another directory which has a different
project quota (or no quota whatsoever).  I suspect the right answer is
that the quota gets transferred from one project to another, so that
it is a true directory-tree quota system, but regardless, if we're
going to go down this path, let's stay consistent with how XFS does
things.

Cheers,

						- Ted
