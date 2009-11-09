From: Theodore Tso <tytso@mit.edu>
Subject: Re: periodic fsck was Re: [patch] ext2/3: document conditions when
	reliable operation is possible
Date: Mon, 9 Nov 2009 09:05:55 -0500
Message-ID: <20091109140555.GG7592@mit.edu>
References: <20090824230036.GK29763@elf.ucw.cz> <4A932B18.1020209@redhat.com> <20090825093414.GB15563@elf.ucw.cz> <4A94ACDF.30405@redhat.com> <20090826111751.GC26595@elf.ucw.cz> <alpine.DEB.2.00.0908260428310.30426@asgard.lang.hm> <20090826131028.GB1370@ucw.cz> <alpine.DEB.2.00.0908260642560.28411@asgard.lang.hm> <20090826180248.GB6997@mit.edu> <20091109085318.GE4818@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: david@lang.hm, Rik van Riel <riel@redhat.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	Rob Landley <rob@landley.net>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net, jack@suse.cz
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756005AbZKIOHO@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20091109085318.GE4818@elf.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Nov 09, 2009 at 09:53:18AM +0100, Pavel Machek wrote:
> 
> Well, in SUSE11-or-so, distro stopped period fscks, silently :-(. I
> believed that it was really bad idea at that point, but because I
> could not find piece of documentation recommending them, I lost the
> argument.

It's an engineering trade-off.  If you have perfect memory that is
never has cosmic-ray hiccups, and hard drives that never write data to
the wrong place, etc. then you don't need periodic fsck's.

If you do have imperfect hardware, the question then is how imperfect
your hardware is, and how frequently it introduces errors.  If you
check too frequently, though, users get upset, especially when it
happens at the most inconvenient time (when you're trying to recover
from unscheduled downtime by rebooting); if you check too infrequently
then it doesn't help you too much since too much data gets damaged
before fsck notices.

So these days, what I strongly recommend is that people use LVM
snapshots, and schedule weekly checks during some low usage period
(i.e., 3am on Saturdays), using something like the e2croncheck shell
script.

						- Ted
