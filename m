From: folkert <folkert@vanheusden.com>
Subject: Re: checksums
Date: Tue, 14 May 2013 20:57:54 +0200
Message-ID: <20130514185754.GF2041@belle.intranet.vanheusden.com>
References: <20130514091407.GC2041@belle.intranet.vanheusden.com>
 <20130514131830.GA19563@thunk.org>
 <20130514144032.GD2041@belle.intranet.vanheusden.com>
 <20130514180923.GD8037@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from keetweej.vanheusden.com ([80.101.105.103]:49551 "EHLO
	keetweej.vanheusden.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757923Ab3ENS54 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 14 May 2013 14:57:56 -0400
Content-Disposition: inline
In-Reply-To: <20130514180923.GD8037@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> > Ok. But that would only when the filesystem is not mounted.
> > Maybe some on-line functionality for doing so would be nice. I'm not
> > totally aware of the filesystem structures in memory/on disk, but
> > reading meta-data from disk which has changes pending in memory/in the
> > journal would give at worst a verify of old(er) data. I don't think this
> > (checking occasional old data) is a bad thing - scrubbing a
> > raid-device/disk doesn't give you the situation for the whole disk(s) in
> > 1 (!) point at time either. If that would be required, then the user
> > could still unmount the filesystem and do a check.
> 
> Well... if you ran filefrag -v on every file on the disk and read all the
> xattrs, you'd scrub nearly all the metadata.  The only things you'd miss are
> unallocated parts of the disk, most of which e2fsck also skips.

Yes but that is, imho, a bit dirty method.
Because I assume the result will be a message in dmesg and the
filesystem being remounted r/o?
I think it would be better if a nice message on the user's terminal and
an exit code.

> > > That's not currently on the development roadmap; I could imagine
> > > someone deciding to design an extension to ext4 that would do this
> > > probably by storing the checksums in the indirect blocks, but no one
> > > is currently working on it.
> 
> sha256sum < file > file.sha256 ? :D

Then you would need to read the whole file. I think it would be better
to have this on e.g. block-level. 4KB so CRC32 suffices?

> (If only there was disk space and brain-time to do something where you could
> *reconstruct* data.)

ah yes.
These days everything is done by the gpu, maybe it can help with that :)


Folkert van Heusden

-- 
www.vanheusden.com/multitail - multitail is tail on steroids. multiple
               windows, filtering, coloring, anything you can think of
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
