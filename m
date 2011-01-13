From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: Oops while going into hibernate
Date: Thu, 13 Jan 2011 14:36:12 +0100
Message-ID: <20110113133612.GD2534@osiris.boeblingen.de.ibm.com>
References: <alpine.LFD.2.02.1101121443230.1900@localhost6.localdomain6>
 <20110112162655.GA13496@thunk.org>
 <alpine.LFD.2.02.1101121755400.2011@localhost6.localdomain6>
 <20110112172646.GB13496@thunk.org>
 <alpine.LFD.2.02.1101121934060.2011@localhost6.localdomain6>
 <A01161D0-D08F-4522-A546-90057B2E1F2A@mit.edu>
 <alpine.LFD.2.02.1101131238480.1899@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org development" <linux-ext4@vger.kernel.org>,
	LKML Kernel <linux-kernel@vger.kernel.org>,
	pm list <linux-pm@lists.linux-foundation.org>
To: Sebastian Ott <sebott@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:55563 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755886Ab1AMNgP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Jan 2011 08:36:15 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1101131238480.1899@localhost6.localdomain6>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 13, 2011 at 12:48:40PM +0100, Sebastian Ott wrote:
> On Wed, 12 Jan 2011, Theodore Tso wrote:
> > It looks like somehow the pages were left marked as dirty, so the
> > writeback daemons attempted writing back a page to an inode which was
> > never opened read/write (and in fact as a text page for
> > /usr/bin/killall, was mapped read/only).
> > Given that ext4 initializes jinode only when the file is opened
> > read/write, the fact that it is null, and the fact that it makes no
> > sense that a program would be modifying /usr/bin/killall as part of a
> > suspend/resume, it looks very much like we just unmasked a software
> > suspend bug....
> Ah, ok. Thanks for the explanation!

Eeeek... this seems to be an architecture specific bug that is only present
on s390.
The dirty bit for user space pages on all architectures but s390 are stored
into the PTE's. On s390 however they are stored into the storage key that
exists per _physical_ page.
So, what we should have done, when implementing suspend/resume on s390, is
to save the storage key for each page and write that to the suspend device
and upon resume restore the storage key contents for each physical page.
The code that would do that is missing... Hence _all_ pages of the resumed
image are dirty after they have been copied to their location.
*ouch*

Will fix.
