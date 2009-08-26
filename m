From: Rik van Riel <riel@redhat.com>
Subject: Re: [patch] document flash/RAID dangers
Date: Wed, 26 Aug 2009 00:20:58 -0400
Message-ID: <4A94B82A.30905@redhat.com>
References: <20090824205209.GE29763@elf.ucw.cz> <4A930160.8060508@redhat.com> <20090824212518.GF29763@elf.ucw.cz> <20090824223915.GI17684@mit.edu> <20090824230036.GK29763@elf.ucw.cz> <20090825000842.GM17684@mit.edu> <20090825094244.GC15563@elf.ucw.cz> <20090825161110.GP17684@mit.edu> <20090825222112.GB4300@elf.ucw.cz> <alpine.DEB.2.00.0908251526290.28411@asgard.lang.hm> <20090825224004.GD4300@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: david@lang.hm, Theodore Tso <tytso@mit.edu>,
	Ric Wheeler <rwheeler@redhat.com>,
	Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	Rob Landley <rob@landley.net>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52191 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751257AbZHZEVw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Aug 2009 00:21:52 -0400
In-Reply-To: <20090825224004.GD4300@elf.ucw.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Pavel Machek wrote:

> Lets say you are writing to the (healthy) RAID5 and have a powerfail.
> 
> So now data blocks do not correspond to the parity block. You don't
> yet have the corruption, but you already have a problem.
> 
> If you get a disk failing at this point, you'll get corruption.

Not necessarily.  Say you wrote out the entire stripe
in a 5 disk RAID 5 array, but only 3 data blocks and
the parity block got written out before power failure.

If the disk with the 4th (unwritten) data block were
to fail and get taken out of the RAID 5 array, the
degradation of the array could actually undo your data
corruption.

With RAID 5 and incomplete writes, you just don't know.

This kind of thing could go wrong at any level in the
system, with any kind of RAID 5 setup.

Of course, on a single disk system without RAID you can
still get incomplete writes, for the exact same reasons.

RAID 5 does not make things worse.  It will protect your
data against certain failure modes, but not against others.

With or without RAID, you still need to make backups.

-- 
All rights reversed.
