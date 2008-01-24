From: Andreas Dilger <adilger@sun.com>
Subject: Integrating patches in SLES10 e2fsprogs
Date: Thu, 24 Jan 2008 14:17:28 -0700
Message-ID: <20080124211728.GA24900@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Girish Shilamkar <Girish.Shilamkar@Sun.COM>,
	Eric Sandeen <esandeen@redhat.com>
To: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	mkoenig@suse.de, hvogel@suse.de
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:63683 "EHLO
	pd4mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753766AbYAXVSk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Jan 2008 16:18:40 -0500
Received: from pd3mr5so.prod.shaw.ca (pd3mr5so-qfe3.prod.shaw.ca [10.0.141.12])
 by l-daemon (Sun ONE Messaging Server 6.0 HotFix 1.01 (built Mar 15 2004))
 with ESMTP id <0JV600KLU359EQDW@l-daemon> for linux-ext4@vger.kernel.org; Thu,
 24 Jan 2008 14:17:33 -0700 (MST)
Received: from pn2ml1so.prod.shaw.ca ([10.0.121.145])
 by pd3mr5so.prod.shaw.ca (Sun Java System Messaging Server 6.2-7.05 (built Sep
 5 2006)) with ESMTP id <0JV600IZ53576810@pd3mr5so.prod.shaw.ca> for
 linux-ext4@vger.kernel.org; Thu, 24 Jan 2008 14:17:33 -0700 (MST)
Received: from webber.adilger.int ([68.147.251.212])
 by l-daemon (Sun Java System Messaging Server 6.2-7.05 (built Sep  5 2006))
 with SMTP id <0JV6000B6354H900@l-daemon> for linux-ext4@vger.kernel.org; Thu,
 24 Jan 2008 14:17:31 -0700 (MST)
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I was looking through the SLES10 e2fsprogs patch set, and I wonder if some
of them could be integrated upstream, and if any effort had been made in
that direction in the past?  In particular, the addition of et_list_lock()
and et_list_unlock() to libcom_err cause failures if e2fsprogs is updated
to a non-SLES10 derived RPM.


A list of patches and (my) descriptions are below:
libcom_err-no-static-buffer.patch - avoids static buffer returned to caller
				    by error_message() function
libcom_err-no-init_error_table.patch - removes init_error_table() function
				       (maybe because it isn't thread safe?),
				       but I think this could be made thread
				       safe by adding locking around use of
				       _et_dynamic_list, or maybe it is
				       obsoleted by add_error_table()?
libcom_err-no-e2fsck.static.patch - can't build e2fsck.static because of
				    -lpthread in libcom_err-mutex.patch, but
				    nothing uses e2fsck.static anymore?
libcom_err-mutex.patch - add et_list_{un,}lock() via pthread mutex


e2fsprogs-blkid.diff - Adds documentation of BLKID_FILE environment variable.
                       This is actually implemented directly in libblkid in
		       e2fsprogs-1.40.2 but no mention of it in the man pages.
e2fsprogs-mdraid.patch - allows skip of mdraid probing, not sure why?
e2fsprogs-probe_reiserfs-fpe.patch - fixes a legitimate bug in probe_reiserfs,
				     though it might be better to just return
				     an error if the blocksize is bad?


In addition to this, the SLES10 .spec file is completely different than that
shipped with upstream e2fsprogs, and I'd like to reconcile that if possible.
In particular it has libcom_err and libss in a separate RPM (libcom_err).
I understand that FC8 (not sure about RHEl5) has also split out some of the
libraries, but in a different way (e2fsprogs-libs) and that is a bit of a
headache.  It might be possible to reconcile with suitable rpm-fu, but it
would be desirable that SLES pick up these changes in the future...

I don't want to spam the list with all of the patches yet, but if there is
interest in merging these upstream then I can provide versions of these
patches against the current e2fsprogs instead of 1.38 that is in SLES10.

Eric, I haven't looked at the FC8/9 e2fsprogs yet, but do they also have
a ton of patches (possibly in the -pu branch), or do they track upstream
more closely?

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
