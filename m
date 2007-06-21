From: Theodore Tso <tytso@mit.edu>
Subject: Re: Patch to support LUKS UUIDs in libblkid
Date: Thu, 21 Jun 2007 13:56:18 -0400
Message-ID: <20070621175618.GA22285@thunk.org>
References: <4665479E.2060707@redhat.com> <20070608153600.GA9726@thunk.org> <466D373C.6000502@redhat.com> <20070612234004.GA12189@thunk.org> <466FCE52.4000605@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, dm-crypt@saout.de
To: Karsten Hopp <karsten@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:33771 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755751AbXFUR42 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Jun 2007 13:56:28 -0400
Content-Disposition: inline
In-Reply-To: <466FCE52.4000605@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Thanks, I've applied the blkid LUKS patch to the e2fsprogs SCM (modulo
a minor whitespace breakage which I fixed up).

BTW, there appears to be a problem here in udev regarding LUKS
identification:

https://bugs.launchpad.net/ubuntu/+source/e2fsprogs/+bug/93921

The problem is that udev sets its magic string in the first 512 bytes
of the partition.  This is dangerous and error-prone, because other
things like boot sectors and BSD disk labels tend to live in the first
512 byte sector.  Hence, many programs are very careful before zapping
the first 512 byte sector.  LUKS was added to the vol_id program very
high in the list of filesystems to be probed, ahead of ext2/ext3, so a
filesystem previously contained a LUKS setup, but then was later
mke2fs'ed to be used as a normal ext2/3 filesyste, may get
misidentified by udev's vol_id as still being a LUKS filesystem if
other fields in the first 512 byte sector cause mke2fs to mistakenly
think there was a BSD disklabel in the sector and thus refuse to zero
it out.

This won't be a problem with blkid, since LUKS is placed *after*
ext3/4.  However, it would be a good idea to check and make sure that
whever is setting up a LUKS partition clears the first and last 32k of
a filesystem, to avoid potential confusion by other in-band filesystem
type checkers.  It would probably be a good idea to (after you make
sure this is done) to submit a patch to the uev folks changing the
probing order of vol_id so that it probes for the LUK filesystem after
ext2/3.   

I am currently consider adding specific kludges to mke2fs that checks
the first couple of bytes of the 512 byte sector for the problematic
filesystem types (NTFS and LUKS), explicitly clearing just those bytes
to avoid future confusion.  But that won't help the existing
filesystems that are out there....

						- Ted
