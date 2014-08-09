From: Li Xi <pkuelelixi@gmail.com>
Subject: Re: [PATCH v2 0/4] quota: add project quota support
Date: Sat, 9 Aug 2014 22:24:59 +0800
Message-ID: <CAPTn0cCwczoaH7va4x3yJZBgtRr8b7_eG9V0YO16YzQcnshdTA@mail.gmail.com>
References: <CAPTn0cAKi64Fh1pAVTDLvSS5-1Kjv7KN2HpGxtm4J8-ym-4nOQ@mail.gmail.com>
	<20140808223335.GQ25145@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-fsdevel@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	viro@zeniv.linux.org.uk, hch@infradead.org,
	Jan Kara <jack@suse.cz>, Andreas Dilger <adilger@dilger.ca>,
	"Niu, Yawei" <yawei.niu@intel.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:37893 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbaHIOZA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 9 Aug 2014 10:25:00 -0400
In-Reply-To: <20140808223335.GQ25145@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Aug 9, 2014 at 6:33 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Sat, Aug 09, 2014 at 12:39:58AM +0800, Li Xi wrote:
>>
>> It is obvious that extended attribute implementation has performance
>> impact when creating files. That is why we choose to push the patches
>> which use internal inode field to save project ID.
>
> Were you using 256-byte inodes or 128-byte inodes when you benchmarked
> using xattr versus an in-inode project quota?
We don't change any option when formating ext4, so the inode size
is always 256 bytes as default when we were running benchmarks.
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
> project quota (or no quota whatsoever).  I suspect the right answer is
> that the quota gets transferred from one project to another, so that
> it is a true directory-tree quota system, but regardless, if we're
> going to go down this path, let's stay consistent with how XFS does
> things.
I agree that compatibility is important. And ofcouse, it would be nice if
XFS and Ext4 could have the same semantics of project quota. However, I am
wondering whether it is more important for prject quota of ext4 to keep
self-consistent instead of keeping consistent with XFS.

Given the fact that project indentifier is naturally like UID/GID, project ID
should be managed in the similar way like UID/GID. And that is what people are
actually doing right now. We already have kuid_t/kgid_t/kprojid_t and a series
of similar functions for both UIG/GID and project ID. I don't think it is
necessary to break this kind of self-consistency when we are trying to add
project quota support. It would be really straightfoward for a new user to
understand what project ID and project quota means, if we are able to explain
that project quota has exactly the same semantics with user/group quota.

User/Group management works well without enforcing unnecessary restrictions.
There seems no obvious reason to enforce such restrictions to project too.
I guess the idea behind the restrictions of XFS project quota is that inodes
belong to different projects should be under different sub-tree. (Sorry if I
am wrong, becasue I am confused by its limits aready. But, in this sense,
yeah, project quota of XFS is actually a directory-tree quota system.)
However, I am wondering whether this limit is really necessary. It is a common
use case that different users have seperate home directories and files of
a users don't scatter in other users' directory. And this use case is enabled
by a little bit of extra system management without enforcing any system-level
limit to file operations across users. Since project ID can only be changed by
a privileged user, usually the system administrator, there is no difficulty in
enforce that projects with different project IDs stay in seperate
directory-trees.

Comparing to real project quota, another problem of directory-tree quota is
the handling of renaming file across directories. Again, it is caused by the
unnecessary restriction. In oder to enforce that restriction, there are two
solution. First, return an error when renaming files, i.e. do not allow to
renaming across projects. Second, do qouta transfer when renaming. Like limit
of disallowing links aross projects, the first solution would cause annoying
failure which confuses users easily. A simple message about the errno just
won't remind users well to realize that it is a project quota limits, let
alone the users who don't know project quota well enough. And in the solution,
quota transfer would cause significant performance degression, given the fact
that rename is a frequently used operation (probably much more frequently than
chmod or chgrp) and is widely considered to be atomic and thus light weighted.

Another advantage of real project quota without any unnecessary limits is that
it is more flexible thus enables more potential use cases. For example, we can
easily combine 'find' or 'grep' command and project quota to calculate the
total number or disk usage of inodes with common attributes or contents. I am
not sure whether it is possible for XFS to so because of its restrictions.

The implementation of XFS project quota is a good example and comparison for
implementing project quota suport for Ext4. But I don't think it is necessary
to take everything of XFS as a standard, because XFS itself doen't implement
everything standardly. For example, XFS does not use standard quota framework
like Ext4 does and it is still struggling to mapping its internal IDs to
standard UID/GID/project ID (https://lkml.org/lkml/2013/2/17/229).

In a word, for the developers, real project quota needs less codes, requires
less exception handling, and provides better self-consistency. And for the
users, it requires less limits, provides cleaner semantics and enables more
uses cases. I'd suggest we choose a straightfowrd way to implement project
quota rather than restrained by an existing but suboptimum design.

Regards,

                 -Li Xi
