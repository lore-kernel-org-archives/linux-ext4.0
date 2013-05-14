From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: checksums
Date: Tue, 14 May 2013 11:09:23 -0700
Message-ID: <20130514180923.GD8037@blackbox.djwong.org>
References: <20130514091407.GC2041@belle.intranet.vanheusden.com>
 <20130514131830.GA19563@thunk.org>
 <20130514144032.GD2041@belle.intranet.vanheusden.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: folkert <folkert@vanheusden.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37928 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207Ab3ENSJb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 14 May 2013 14:09:31 -0400
Content-Disposition: inline
In-Reply-To: <20130514144032.GD2041@belle.intranet.vanheusden.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 14, 2013 at 04:40:34PM +0200, folkert wrote:
> > > Is it possible to "scrub" (check/verify) (the new-) checksums in ext4?
> > 
> > When e2fsck does a full check, it verifies the contents of all of the
> > metadata blocks, and this includes verifying all of the checksums.
> 
> Ok. But that would only when the filesystem is not mounted.
> Maybe some on-line functionality for doing so would be nice. I'm not
> totally aware of the filesystem structures in memory/on disk, but
> reading meta-data from disk which has changes pending in memory/in the
> journal would give at worst a verify of old(er) data. I don't think this
> (checking occasional old data) is a bad thing - scrubbing a
> raid-device/disk doesn't give you the situation for the whole disk(s) in
> 1 (!) point at time either. If that would be required, then the user
> could still unmount the filesystem and do a check.

Well... if you ran filefrag -v on every file on the disk and read all the
xattrs, you'd scrub nearly all the metadata.  The only things you'd miss are
unallocated parts of the disk, most of which e2fsck also skips.

Ofc e2fsck will also catch incorrect values in the metadata, whereas I think
the kernel only notices /insane/ values.

> > > Also: is it planned to add an option to add checksums to the data as
> > > well?
> > That's not currently on the development roadmap; I could imagine
> > someone deciding to design an extension to ext4 that would do this
> > probably by storing the checksums in the indirect blocks, but no one
> > is currently working on it.

sha256sum < file > file.sha256 ? :D

(If only there was disk space and brain-time to do something where you could
*reconstruct* data.)

--D

> Would crowdfunding such a feature be an option?
> E.g. via https://www.catincan.com/ or http://www.kickstarter.com/
> 
> On other thing I was thinking of, was a switch that would enable a
> read-after-write which would verify that the data is indeed on the
> platters/NAND-chips.
> (I don't care (too) much about speed - I just want to be really sure my
> data doesn't get corrupt/lost without investing huge piles of money on
> a san/nas with remote mirroring etc.).
> 
> 
> Regards,
> 
> Folkert van Heusden
> 
> -- 
> Winnen in de staatsloterij? Check htp://vanheusden.com/sl.php voor
> alle staatsloterij-uitslag statistieken denkbaar en zelfs ook een paar
> win-tips!
> ----------------------------------------------------------------------
> Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
