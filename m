From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Exciting :-( adventures in metadata checksumming
Date: Fri, 3 Aug 2012 19:49:02 -0400
Message-ID: <20120803234902.GA18757@thunk.org>
References: <20120803195508.18583.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: George Spelvin <linux@horizon.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42915 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753927Ab2HCXtG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 Aug 2012 19:49:06 -0400
Content-Disposition: inline
In-Reply-To: <20120803195508.18583.qmail@science.horizon.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 03, 2012 at 03:55:08PM -0400, George Spelvin wrote:
> A considerable amount of time trying to run "debuild -b -us -uc" and
> "debian/rules binary" elapses.  I am unable to build a .deb.  Damn.
> And debian/rules files are a complete maze of layers of helper
> utilities that I have no idea how to debug. :-(

This is what I normally do when I build debian packages.  I normally
will create a tarball using the gen-tarball script in the util
directory (which is a generated file, so that means you need to run
"configure ; sh -vx util/gen-tarball" if you are using a freshly
checked out git tree.  In theory you should be able to do a debian
build out of the git tree, but it's not what I normally do....

So normally, I do something like this:

cp build/util/e2fsprogs-1.42.5.tar.gz /u1/debian-bld/e2fsprogs_1.42.5.orig.tar.gz
#
# optional "schroot -c sid" if you're building for unstable in a debian chroot
# goes here
#
cd /u1/debian-bld
tar xvfz e2fsprogs_1.42.5.orig.tar.gz
cd e2fsprogs-1.42.5
./debian/rules
dpkg-buildpackage -rfakeroot


The "./debian/rules" line generates various files in debian based on
your build environment.  It's there so that the build tree can work on
older verisions of Debian/Ubuntu LTS as well as the very latest
versions of debian.  (i.e., it figures out whether or not we need to
build the uuid and blkid libraries, or whether we are on a system
where the responsibility of those libraries have been moved to
util-linux-ng.  It figures out whether you are on a new enough version
of Debian/Ubuntu to require the new multi-arch support.)

> Eek!  Doubleplusungood.  Repeating the e2fsck, the errors seem to be
> consistent.  For the record I did *nothing* to the file system between
> the two runs except used debugfs in read-only mode to ncheck the inodes
> that generated complaints.

Hmm... I can't replicate the problem using a cleanly created file
system, copying a huge number of files to it, and then enabling
metadata_csum using tune2fs, and then running e2fsck -f on the device
again.

The fact that you are were seeing multiple cases of file system
corruption before you started using metadata_csum makes me very
suspicious, though.  I'm not sure whether you have a hardware problem,
or a bug in the md layer, or something else but the fact you were
seeing what looks like metadata corruption problems even before
turning on metadata_csum doesn't make it surprising that you might be
having the checksum failures reported!

							- Ted
