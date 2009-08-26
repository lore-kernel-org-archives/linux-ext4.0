From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
	possible
Date: Wed, 26 Aug 2009 03:16:06 +0200
Message-ID: <20090826011605.GS4300__30893.3613742285$1251249445$gmane$org@elf.ucw.cz>
References: <4A9468E8.607@redhat.com> <20090825225114.GE4300@elf.ucw.cz> <4A946DD1.8090906@redhat.com> <20090825232601.GF4300@elf.ucw.cz> <4A947682.2010204@redhat.com> <20090825235359.GJ4300@elf.ucw.cz> <4A947DA9.2080906@redhat.com> <20090826001645.GN4300@elf.ucw.cz> <4A948259.40007@redhat.com> <20090826010018.GA17684@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Tso <tytso@mit.edu>, Ric Wheeler <rwheeler@redhat.com>,
	Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	Rob Landley <rob@landley.net>,
	kernel list
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47360 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932352AbZHZBQN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Aug 2009 21:16:13 -0400
Content-Disposition: inline
In-Reply-To: <20090826010018.GA17684@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi!

> 3) Does that mean that you shouldn't use ext3 on RAID drives?  Of
> course not!  First of all, Ext3 still saves you against kernel panics
> and hangs caused by device driver bugs or other kernel hangs.  You
> will lose less data, and avoid needing to run a long and painful fsck
> after a forced reboot, compared to if you used ext2.  You are making

Actually... ext3 + MD RAID5 will still have a problem on kernel
panic. MD RAID5 is implemented in software, so if kernel panics, you
can still get inconsistent data in your array.

I mostly agree with the rest.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
