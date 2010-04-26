From: "Theodore Ts'o" <tytso@mit.edu>
Subject: DRAFT Design Spec for 1st Class Quota Support in Ext4
Date: Mon, 26 Apr 2010 02:44:24 -0400
Message-ID: <E1O6I3M-0002Wl-CV@closure.thunk.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:47110 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586Ab0DZGo3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 Apr 2010 02:44:29 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Please comment!

		    1st Class Quota Support in Ext4
		    DRAFT Design Specification, v0.5


This proposal promotes quota to being a first class supported feature in
ext4.  To do this, we will do the following:

1)  We define the following two new fields to the superblock.  No new
COMPAT features are defined; since unused superblock fields are zero, if
the fields are not known.
  *) A superblock field containing the inode number for the user quota
     file.  This inode number will be 3 if the inode is user quota file
     is hidden.  If this field is zero, then user quotas will not be tracked.
  *) A superblock field containing the inode number for the group quota
     file.  This inode number will be 4 if the inode is group quota file
     is hidden.  If this field is zero, then group quotas will not be
     tracked.

2) The quota files will use the v2 format only, and updates to the quota
files will be protected with the journal if the journal is present.

3) If e2fsck needs to do a full file system consistency check, it will
keep track of the disk space used by each user and/or groups ids, and
update the user and/or group quota files at the end of the e2fsck run.

4) If the filesystem appears consistent, but the user and/or group quota
fils are not equal to the last superblock write time, e2fsck will do a
partical file system consistency check.  This will consist of e2fsck
pass #1, and if no errors were detected, e2fsck will update the user and
group quota files and exit.  If any errors were detected during pass #1,
then e2fsck will  continue to do pass numbers 2-5, and thus do a full
file system consistency check before updating the quota files.

5) Mke2fs will take an extended option (quota=user,group) which if
present will force the initialization of the quota inodes.  Using the
/etc/mke2fs.conf file, the system administrator can also specify a quota
option in the [defaults] and [fs_types] section, so that quota files can
be enabled by default.

6) Tune2fs will have a facility for adding and removing user and group
quotas inodes while the file system is mounted.  The quota usage will
not be correct after the quota inodes are newly added, however, so quota
will not be enabled by default,  If the quota inodes are removed, quota
will be disabled first.

7) There will be a new interface so that bulk quota information can be
fetched from the file system.  This needs to be negotiated with Jan
Kara.  It can either be a new system call, or a magic file in /proc that
can be opened and the repquota data extracted.

8) Traditional style quota will still be supported; that is the
appropriate magic flags will be passed through to /proc/mounts so that
the old-style init scripts will still function correctly.  This support
will be deprecated over an 18 month period after the new-style kernel
code and userspace tools have been released.
