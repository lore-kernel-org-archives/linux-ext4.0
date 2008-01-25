From: Matthias Koenig <mkoenig@suse.de>
Subject: Re: Integrating patches in SLES10 e2fsprogs
Date: Fri, 25 Jan 2008 16:22:56 +0100
Message-ID: <n7xir1iq69b.fsf@sor.suse.de>
References: <20080124211728.GA24900@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, hvogel@suse.de,
	Girish Shilamkar <Girish.Shilamkar@Sun.COM>,
	Eric Sandeen <esandeen@redhat.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47174 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755850AbYAYPW5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Jan 2008 10:22:57 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger <adilger@sun.com> writes:

> I was looking through the SLES10 e2fsprogs patch set, and I wonder if some
> of them could be integrated upstream, and if any effort had been made in
> that direction in the past?  In particular, the addition of et_list_lock()
> and et_list_unlock() to libcom_err cause failures if e2fsprogs is updated
> to a non-SLES10 derived RPM.
>
>
> A list of patches and (my) descriptions are below:
> libcom_err-no-static-buffer.patch - avoids static buffer returned to caller
> 				    by error_message() function
> libcom_err-no-init_error_table.patch - removes init_error_table() function
> 				       (maybe because it isn't thread safe?),
> 				       but I think this could be made thread
> 				       safe by adding locking around use of
> 				       _et_dynamic_list, or maybe it is
> 				       obsoleted by add_error_table()?
> libcom_err-no-e2fsck.static.patch - can't build e2fsck.static because of
> 				    -lpthread in libcom_err-mutex.patch, but
> 				    nothing uses e2fsck.static anymore?
> libcom_err-mutex.patch - add et_list_{un,}lock() via pthread mutex

This adresses
https://bugzilla.novell.com/show_bug.cgi?id=66534

> e2fsprogs-blkid.diff - Adds documentation of BLKID_FILE environment variable.
>                        This is actually implemented directly in libblkid in
> 		       e2fsprogs-1.40.2 but no mention of it in the man pages.

https://bugzilla.novell.com/show_bug.cgi?id=50156

> e2fsprogs-mdraid.patch - allows skip of mdraid probing, not sure why?

https://bugzilla.novell.com/show_bug.cgi?id=100530

> e2fsprogs-probe_reiserfs-fpe.patch - fixes a legitimate bug in probe_reiserfs,
> 				     though it might be better to just return
> 				     an error if the blocksize is bad?

https://bugzilla.novell.com/show_bug.cgi?id=115827

> In addition to this, the SLES10 .spec file is completely different than that
> shipped with upstream e2fsprogs, and I'd like to reconcile that if possible.
> In particular it has libcom_err and libss in a separate RPM (libcom_err).
> I understand that FC8 (not sure about RHEl5) has also split out some of the
> libraries, but in a different way (e2fsprogs-libs) and that is a bit of a
> headache.  It might be possible to reconcile with suitable rpm-fu, but it
> would be desirable that SLES pick up these changes in the future...

We have now at SuSE a clear policy about packaging shared libraries:
http://en.opensuse.org/Packaging/Shared_Library_Packaging_Policy
This is pretty much similar to what debian does since ages.
It might be possible to do this in one spec, so that it works for
FC and SuSE, but I don't see this being worth the effort.

> I don't want to spam the list with all of the patches yet, but if there is
> interest in merging these upstream then I can provide versions of these
> patches against the current e2fsprogs instead of 1.38 that is in SLES10.

Since the SLES10 patches are against e2fsprogs 1.38 a better base for
upstream work is Opensuse Factory, which just has been updated to 1.40.4.
Yes, there are still patches in there which I need to check for upstream
inclusion, and this is something I wanted to do since some time. I just
didn't get the time recently. But your mail is a good oppertunity to
start working on this.

Matthias
