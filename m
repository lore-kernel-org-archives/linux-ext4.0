From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Reporting project quota usage?
Date: Wed, 16 Mar 2016 20:48:47 -0400
Message-ID: <20160317004847.GG23593@thunk.org>
References: <20160316052906.GA23610@thunk.org>
 <A21F30FD-8207-473D-860A-F1B2118D35C0@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Li Xi <pkuelelixi@gmail.com>, Jan Kara <jack@suse.cz>,
	Dave Chinner <david@fromorbit.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54372 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751433AbcCQAsw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Mar 2016 20:48:52 -0400
Content-Disposition: inline
In-Reply-To: <A21F30FD-8207-473D-860A-F1B2118D35C0@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 16, 2016 at 03:49:31PM -0600, Andreas Dilger wrote:
> 
> At one time I thought Dave was going to patch xfs_quota to try the quota
> ioctls for "foreign" filesystems like ext4 that supported them, but I'm
> not sure if that patch was landed, nor whether it has been released.
> 
> On the opposite front, Jan was updating the generic quota tools to support
> the XFS ioctls that project quota is using?

It's quite possible I'm missing something, but it doesn't look like
either has landed.  I've hacked xfs_quota (not anything that I would
want to submit for merging) so I can report usage project quota stats,
and to be able to set hard and soft limits.  But I was trying to
figure out what we should be telling users who wanted to use Project
Quota, but I'm pretty sure "pull down xfsprogs sources, and apply this
hacky patch[1], and then when you use the tooll ignore a whole bunch
of spurious warnings" is the right way to go.  :-)

I am also curious how Li Xi was testing the patches he sent me.

     	     	       	   	       - Ted

[1]

diff --git a/libxcmd/paths.c b/libxcmd/paths.c
index 5c65737..6c69a35 100644
--- a/libxcmd/paths.c
+++ b/libxcmd/paths.c
@@ -301,8 +301,8 @@ fs_table_initialise_mounts(
 			return errno;
 
 	while ((mnt = getmntent(mtp)) != NULL) {
-		if (strcmp(mnt->mnt_type, "xfs") != 0)
-			continue;
+//		if (strcmp(mnt->mnt_type, "xfs") != 0)
+//			continue;
 		if (!realpath(mnt->mnt_dir, rmnt_dir))
 			continue;
 		if (!realpath(mnt->mnt_fsname, rmnt_fsname))
