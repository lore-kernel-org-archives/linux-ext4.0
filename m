From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
	possible
Date: Sun, 30 Aug 2009 09:03:37 +0200
Message-ID: <20090830070336.GA1554@ucw.cz>
References: <20090824212518.GF29763@elf.ucw.cz> <20090824223915.GI17684@mit.edu> <20090824230036.GK29763@elf.ucw.cz> <4A932B18.1020209@redhat.com> <20090825093414.GB15563@elf.ucw.cz> <4A94ACDF.30405@redhat.com> <20090826111751.GC26595@elf.ucw.cz> <alpine.DEB.2.00.0908260428310.30426@asgard.lang.hm> <20090826131028.GB1370@ucw.cz> <alpine.DEB.2.00.0908260642560.28411@asgard.lang.hm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Rik van Riel <riel@redhat.com>, Ric Wheeler <rwheeler@redhat.com>,
	Theodore Tso <tytso@mit.edu>, Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	Rob Landley <rob@landley.net>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net, jack@suse.cz
To: david@lang.hm
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49020 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbZH3HDl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 30 Aug 2009 03:03:41 -0400
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0908260642560.28411@asgard.lang.hm>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 2009-08-26 06:43:24, david@lang.hm wrote:
> On Wed, 26 Aug 2009, Pavel Machek wrote:
>
>>>>> The metadata is just a way to get to my data, while the data
>>>>> is actually important.
>>>>
>>>> Personally, I care about metadata consistency, and ext3 documentation
>>>> suggests that journal protects its integrity. Except that it does not
>>>> on broken storage devices, and you still need to run fsck there.
>>>
>>> as the ext3 authors have stated many times over the years, you still need
>>> to run fsck periodicly anyway.
>>
>> Where is that documented?
>
> linux-kernel mailing list archives.

That's not where fs documentation belongs :-(.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
