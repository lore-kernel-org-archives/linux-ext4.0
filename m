From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Ubuntu Ext4 regression testing
Date: Tue, 18 Sep 2012 23:41:02 -0400
Message-ID: <20120919034102.GA18707@thunk.org>
References: <50511241.2090603@canonical.com>
 <20120913021818.GA27544@thunk.org>
 <50514A08.80903@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Brad Figg <brad.figg@canonical.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:51424 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754149Ab2ISDlN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 18 Sep 2012 23:41:13 -0400
Content-Disposition: inline
In-Reply-To: <50514A08.80903@canonical.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 12, 2012 at 07:50:48PM -0700, Brad Figg wrote:
> 
> Thanks, this is very helpful. I wouldn't mind seeing your script if you
> feel like sharing it.

I've checked in the scripts into my xfstests-bld repository.  You can
get the repository here:

	git://git.kernel.org/pub/scm/fs/ext2/xfstests-bld.git

This is how I build xfstests and its dependencies hermetically, so
that even if you are forced (as I was for a while) to build on an
ancient enterprise or LTS distribution, it will build cleanly.
(Xfstests requires the libraries in xfsprogs newer than what was
shipped with LTS 10.04, and I'd guess RHEL 6 and definitely RHEL 5.)

The scripts that run in the VM can be found in the directory
kvm-autorun; they are installed into a file system built using
debootstrap.  The scripts I use to kick off kvm in the host OS can be
found in the directory kvm-xfstests.

Sorry for the delay; it took me a while to get things packaged up
cleanly.  Unfortunately I can't just ship you the root_fs.img due of
GPL licensing issues (figuring what all of the necessary source files
that I'd have to ship that correspond to the application image is a
huge pain in the ass).  One of these days I'll create a shell script
that runs debootsrap and automatically sets up the root_fs.img for the
VM for people building the VM while running Debian or Ubuntu ---
unless someone beats me to it first (hint, hint :-).

          	      	      	       	     - Ted
