From: Eric Sandeen <sandeen@redhat.com>
Subject: call for brave ext4 testers in F9 Alpha, with caveats
Date: Fri, 08 Feb 2008 15:32:36 -0600
Message-ID: <47ACCA74.50809@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36941 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754048AbYBHVci (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 8 Feb 2008 16:32:38 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m18LWb9C010255
	for <linux-ext4@vger.kernel.org>; Fri, 8 Feb 2008 16:32:37 -0500
Received: from lacrosse.corp.redhat.com (lacrosse.corp.redhat.com [172.16.52.154])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m18LWbUF000598
	for <linux-ext4@vger.kernel.org>; Fri, 8 Feb 2008 16:32:37 -0500
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by lacrosse.corp.redhat.com (8.12.11.20060308/8.11.6) with ESMTP id m18LWaOK002998
	for <linux-ext4@vger.kernel.org>; Fri, 8 Feb 2008 16:32:36 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

(I sent this to fedora-devel, but of course anyone here who would like
to give it a whirl should also do so!  So far there haven't been any bad
reports.  :)  See the wiki link at the bottom for a couple of updates,
caveats & gotchas.)

......

Hi Gang -

The ext4 filesystem is a feature slated for F9, and we (rh, ibm, bull,
clusterfs, and others) are working feverishly to get it ready for a
prime-time F9 fs option.

I'd like to get a bit more exposure if possible, so if you're feeling
like living on the cutting edge of filesystems, read on:

Rawhide and the F9 alpha can install onto an ext4dev filesystem root;
first you need to tell (a.k.a. lie to) the installer with
"iamanext4developer" on the boot commandline.  This is akin to the "jfs"
or "reiserfs" options for those filesystems, but a higher hurdle (more
characters to type!).

Then you can do custom partitioning, and select ext4dev for any
filesystem (except /boot - no grub support (yet)).

The install should proceed Just Fine(tm).  If not, let me know.

And now for the (known) caveats:

1) Due to bug 429857: Root inode of ext4dev root filesystem does not get
selinux label - booting with selinux enabled & enforcing will probably
fail.  Boot with enforcing=0, and use restorecon or chcon on / to
(hopefully) properly update the root inode's selinux attrs.  I have a
fix for this bug, so soon, kernel updates will resolve this and allow it
to be properly set (and retained).  Please do test w/ selinux enabled
though, as the new larger inodes and in-inode xattrs could use airtime.

2) There is no readily-available e2fsprogs which can repair your shiny
new ext4dev filesystem.  If something goes badly I'll help out because
we need to know what went wrong, but so far there is no released
upstream e2fsprogs which can handle the new ext4 features.  So please
consider anything you put on ext4dev for now to be disposable, just to
be on the safe side.  extents-capable e2fsprogs should be available Real
Soon Now.

3) misc stuff - I've not yet tested ext4 over an encrypted block device,
or even over an lvm volume.  There may be some stack issues on x86 boxes
still, I'm working on slimming that down.  I hope that more real-world
use will shake out any remaining problems.

... and I suppose I should put this into a wiki page:
http://fedoraproject.org/wiki/FedoraExt4

We can keep it updated with any further issues or resolutions.

Thanks!
-Eric
