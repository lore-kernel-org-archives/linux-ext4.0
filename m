From: Theodore Tso <tytso@mit.edu>
Subject: Re: [E2FSPROGS, RFC] mke2fs: New bitmap and inode table allocation
	for FLEX_BG
Date: Tue, 22 Apr 2008 21:21:49 -0400
Message-ID: <20080423012149.GF20668@mit.edu>
References: <1208868379-17580-1-git-send-email-tytso@mit.edu> <1208868379-17580-2-git-send-email-tytso@mit.edu> <1208868379-17580-3-git-send-email-tytso@mit.edu> <20080422091847.50708436@gara> <20080422145125.GB12836@mit.edu> <20080422103212.1c974bd9@gara> <20080422185728.GC20668@mit.edu> <20080422172751.22d5aef9@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Valerie Clement <valerie.clement@bull.net>
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:51277 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753403AbYDWBW1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Apr 2008 21:22:27 -0400
Content-Disposition: inline
In-Reply-To: <20080422172751.22d5aef9@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 22, 2008 at 05:27:51PM -0500, Jose R. Santos wrote:
> > Let's stay with 16 then for now.  Spindle speed doesn't actually
> > matter here; what matters is seek speed, and the density of the disk
> 
> Well higher spindle speed affect cylinder seek times which affect
> overall seek time, which is why I think it should be tested as well.

Well, I looked at some laptop drives with spindle speeds of 4200rpm,
5400rpm, and 7200rpm, and they have an average read/write seek time of
of 10.5/12.5ms.

Comparing Western Digital's current enterprise disk drives (the RE-2)
which are 7200rpm, and their Enterprise "Green Power" drives (the
RE2-GP) which try to hide the fact that their disks are 5400RPM, but
which web sites have outed by using doing a frequency analysis of its
acoustic output --- both have the same read/write seek time of 8.9ms.

Interestingly, some of the older disks have faster seek times (i.e.,
4ms), at the same disk platters, and I doubt it's because hard drive
head positioning motors have gotten slower; rather, it's probably that
as the platter density has increased, the time to position the hard
drive heads is what's taking longer.  

Something that would be interesting to do is to do some experiments
measuring small seeks (i.e., within a 1 gigabyte or so), and long
seeks (i.e., across 10-20% and 50% of the disk drive).  The difference
between those two times is what's probably driving your flex_bg
performance numbers, and it might be easier simply to measure that
directly.

							- Ted
