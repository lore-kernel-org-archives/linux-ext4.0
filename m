From: folkert <folkert@vanheusden.com>
Subject: Re: checksums
Date: Tue, 14 May 2013 16:40:34 +0200
Message-ID: <20130514144032.GD2041@belle.intranet.vanheusden.com>
References: <20130514091407.GC2041@belle.intranet.vanheusden.com>
 <20130514131830.GA19563@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from keetweej.vanheusden.com ([80.101.105.103]:52292 "EHLO
	keetweej.vanheusden.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932124Ab3ENOkh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 14 May 2013 10:40:37 -0400
Content-Disposition: inline
In-Reply-To: <20130514131830.GA19563@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> > Is it possible to "scrub" (check/verify) (the new-) checksums in ext4?
> 
> When e2fsck does a full check, it verifies the contents of all of the
> metadata blocks, and this includes verifying all of the checksums.

Ok. But that would only when the filesystem is not mounted.
Maybe some on-line functionality for doing so would be nice. I'm not
totally aware of the filesystem structures in memory/on disk, but
reading meta-data from disk which has changes pending in memory/in the
journal would give at worst a verify of old(er) data. I don't think this
(checking occasional old data) is a bad thing - scrubbing a
raid-device/disk doesn't give you the situation for the whole disk(s) in
1 (!) point at time either. If that would be required, then the user
could still unmount the filesystem and do a check.

> > Also: is it planned to add an option to add checksums to the data as
> > well?
> That's not currently on the development roadmap; I could imagine
> someone deciding to design an extension to ext4 that would do this
> probably by storing the checksums in the indirect blocks, but no one
> is currently working on it.

Would crowdfunding such a feature be an option?
E.g. via https://www.catincan.com/ or http://www.kickstarter.com/

On other thing I was thinking of, was a switch that would enable a
read-after-write which would verify that the data is indeed on the
platters/NAND-chips.
(I don't care (too) much about speed - I just want to be really sure my
data doesn't get corrupt/lost without investing huge piles of money on
a san/nas with remote mirroring etc.).


Regards,

Folkert van Heusden

-- 
Winnen in de staatsloterij? Check htp://vanheusden.com/sl.php voor
alle staatsloterij-uitslag statistieken denkbaar en zelfs ook een paar
win-tips!
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
