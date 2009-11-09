From: Pavel Machek <pavel@ucw.cz>
Subject: periodic fsck was Re: [patch] ext2/3: document conditions when
 reliable operation is possible
Date: Mon, 9 Nov 2009 09:53:18 +0100
Message-ID: <20091109085318.GE4818__43449.0505409942$1257756823$gmane$org@elf.ucw.cz>
References: <20090824223915.GI17684@mit.edu>
 <20090824230036.GK29763@elf.ucw.cz>
 <4A932B18.1020209@redhat.com>
 <20090825093414.GB15563@elf.ucw.cz>
 <4A94ACDF.30405@redhat.com>
 <20090826111751.GC26595@elf.ucw.cz>
 <alpine.DEB.2.00.0908260428310.30426@asgard.lang.hm>
 <20090826131028.GB1370@ucw.cz>
 <alpine.DEB.2.00.0908260642560.28411@asgard.lang.hm>
 <20090826180248.GB6997@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Tso <tytso@mit.edu>, david@lang.hm,
	Rik van Riel <riel@redhat.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40045 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754314AbZKIIxW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Nov 2009 03:53:22 -0500
Content-Disposition: inline
In-Reply-To: <20090826180248.GB6997@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 2009-08-26 14:02:48, Theodore Tso wrote:
> On Wed, Aug 26, 2009 at 06:43:24AM -0700, david@lang.hm wrote:
> >>>
> >>> as the ext3 authors have stated many times over the years, you still need
> >>> to run fsck periodicly anyway.
> >>
> >> Where is that documented?
> >
> > linux-kernel mailing list archives.
> 
> Probably from some 6-8 years ago, in e-mail postings that I made.  My
> argument has always been that PC-class hardware is crap, and it's a

Well, in SUSE11-or-so, distro stopped period fscks, silently :-(. I
believed that it was really bad idea at that point, but because I
could not find piece of documentation recommending them, I lost the
argument.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
