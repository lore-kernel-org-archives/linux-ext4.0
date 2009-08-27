From: Rob Landley <rob@landley.net>
Subject: Re: [patch] ext2/3: document conditions when reliable operation is possible
Date: Wed, 26 Aug 2009 22:34:52 -0500
Message-ID: <200908262234.54586.rob@landley.net>
References: <20090824093143.GD25591@elf.ucw.cz> <20090824230036.GK29763@elf.ucw.cz> <20090825000842.GM17684@mit.edu>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Pavel Machek <pavel@ucw.cz>, Ric Wheeler <rwheeler@redhat.com>,
	Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:44841
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115AbZH0DfM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 26 Aug 2009 23:35:12 -0400
In-Reply-To: <20090825000842.GM17684@mit.edu>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Monday 24 August 2009 19:08:42 Theodore Tso wrote:
> And if your
> claim is that several hundred lines of fsck output detailing the
> filesystem's destruction somehow makes things all better, I suspect
> most users would disagree with you.

Suppose a small office makes nightly backups to an offsite server via rsync.  If 
a thunderstorm goes by causing their system to reboot twice in a 15 minute 
period, would they rather notice the filesystem corruption immediately upon 
reboot, or notice after the next rsync?

> In any case, depending on where the flash was writing at the time of
> the unplug, the data corruption could be silent anyway.

Yup.  Hopefully btrfs will cope less badly?  They keep talking about 
checksumming extents...

> Maybe this came as a surprise to you, but anyone who has used a
> compact flash in a digital camera knows that you ***have*** to wait
> until the led has gone out before trying to eject the flash card.

I doubt the cupholder crowd is going to stop treating USB sticks as magical 
any time soon, but I also wonder how many of them even remember Linux _exists_ 
anymore.

> I
> remember seeing all sorts of horror stories from professional
> photographers about how they lost an important wedding's day worth of
> pictures with the attendant commercial loss, on various digital
> photography forums.  It tends to be the sort of mistake that digital
> photographers only make once.

Professionals have horror stories about this issue, therefore documenting it 
is _less_ important?

Ok...

Rob
-- 
Latency is more important than throughput. It's that simple. - Linus Torvalds
