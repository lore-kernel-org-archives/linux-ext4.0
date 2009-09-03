From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [testcase] test your fs/storage stack (was Re: [patch] ext2/3:
	document conditions when reliable operation is possible)
Date: Thu, 3 Sep 2009 10:55:10 +0200
Message-ID: <20090903085510.GE3793@elf.ucw.cz>
References: <20090826001645.GN4300@elf.ucw.cz> <20090902201210.GC1840@ucw.cz> <4A9ED8AB.5080003@redhat.com> <200909021800.51096.rob@landley.net> <alpine.DEB.2.00.0909021605100.28411@asgard.lang.hm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Rob Landley <rob@landley.net>, Ric Wheeler <rwheeler@redhat.com>,
	Theodore Tso <tytso@mit.edu>, Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: david@lang.hm
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0909021605100.28411@asgard.lang.hm>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi!

>> However, thinking about how to _fix_ a problem is predicated on acknowledging
>> that there actually _is_ a problem.  "The hardware is not physically damaged
>> but your data was lost" sounds to me like a software problem, and thus
>> something software could at least _attempt_ to address.  "There's millions of
>> 'em, Linux can't cope" doesn't seem like a useful approach.
>
> no other OS avoids this problem either.
>
> I actually don't see how you can do this from userspace, because when you 
> write to the device you have _no_ idea where on the device your data will 
> actually land.

It certainly is not easy. Self-correcting codes could probably be
used, but that would be very special, very slow, and very
non-standard. (Basically... we could design filesystem so that it
would survive damage of arbitrarily 512K on disk -- using
self-correcting codes in CD-like manner). I'm not sure if it would be
practical.

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
