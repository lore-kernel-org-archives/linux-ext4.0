From: Theodore Tso <tytso@mit.edu>
Subject: Re: wishful thinking about atomic, multi-sector or full MD stripe
	width, writes in storage
Date: Mon, 7 Sep 2009 09:10:26 -0400
Message-ID: <20090907131026.GC32427@mit.edu>
References: <4A9BCDFE.50008@rtr.ca> <20090831132139.GA5425@infradead.org> <4A9F230F.40707@redhat.com> <m3ab1cp9ii.fsf@intrepid.localdomain> <4A9FA5F2.9090704@redhat.com> <m3ljkwnoct.fsf@intrepid.localdomain> <4A9FC9B3.1080809@redhat.com> <m3ab1cnn7y.fsf@intrepid.localdomain> <4A9FCF6B.1080704@redhat.com> <20090907114534.GP23450@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ric Wheeler <rwheeler@redhat.com>,
	Krzysztof Halasa <khc@pm.waw.pl>,
	Christoph Hellwig <hch@infradead.org>, Mark Lord <lkml@rtr.ca>,
	Michael Tokarev <mjt@tls.msk.ru>, david@lang.hm,
	NeilBrown <neilb@suse.de>, Rob Landley <rob@landley.net>,
	Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:44360 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446AbZIGNL4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Sep 2009 09:11:56 -0400
Content-Disposition: inline
In-Reply-To: <20090907114534.GP23450@elf.ucw.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 07, 2009 at 01:45:34PM +0200, Pavel Machek wrote:
> 
> Yes, but ext3 was designed to handle the partial write  (according to
> tytso).

I'm not sure what made you think that I said that.  In practice things
usually work out, as a conseuqence of the fact that ext3 uses physical
block journaling, but it's not perfect, becase...

> > Also, when you enable the write cache (MD or not) you are buffering 
> > multiple MB's of data that can go away on power loss. Far greater (10x) 
> > the exposure that the partial RAID rewrite case worries about.
> 
> Yes, that's what barriers are for. Except that they are not there on
> MD0/MD5/MD6. They actually work on local sata drives...

Yes, but ext3 does not enable barriers by default (the patch has been
submitted but akpm has balked because he doesn't like the performance
degredation and doesn't believe that Chris Mason's "workload of doom"
is a common case).  Note though that it is possible for dirty blocks
to remain in the track buffer for *minutes* without being written to
spinning rust platters without a barrier.

See Chris Mason's report of this phenonmenon here:

	http://lkml.org/lkml/2009/3/30/297

Here's Chris Mason "barrier test" which will corrupt ext3 filesystems
50% of the time after a power drop if the filesystem is mounted with
barriers disabled (which is the default; use the mount option
barrier=1 to enable barriers):

	http://lkml.indiana.edu/hypermail/linux/kernel/0805.2/1518.html

(Yes, ext4 has barriers enabled by default.)

							- Ted
