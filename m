From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [linux-pm] Oops while going into hibernate
Date: Fri, 14 Jan 2011 10:53:21 +0100
Message-ID: <20110114095321.GA2696@osiris.boeblingen.de.ibm.com>
References: <alpine.LFD.2.02.1101121443230.1900@localhost6.localdomain6>
 <20110112162655.GA13496@thunk.org>
 <alpine.LFD.2.02.1101121755400.2011@localhost6.localdomain6>
 <20110112172646.GB13496@thunk.org>
 <alpine.LFD.2.02.1101121934060.2011@localhost6.localdomain6>
 <A01161D0-D08F-4522-A546-90057B2E1F2A@mit.edu>
 <alpine.LFD.2.02.1101131238480.1899@localhost6.localdomain6>
 <20110113133612.GD2534@osiris.boeblingen.de.ibm.com>
 <20110113184626.GA31800@thunk.org>
 <1294954212.2781.8.camel@shrek.rexursive.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Ted Ts'o" <tytso@mit.edu>,
	pm list <linux-pm@lists.linux-foundation.org>,
	"linux-ext4@vger.kernel.org development" <linux-ext4@vger.kernel.org>,
	LKML Kernel <linux-kernel@vger.kernel.org>
To: Bojan Smojver <bojan@rexursive.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mtagate6.uk.ibm.com ([194.196.100.166]:46218 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756825Ab1ANJxY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 14 Jan 2011 04:53:24 -0500
Content-Disposition: inline
In-Reply-To: <1294954212.2781.8.camel@shrek.rexursive.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 14, 2011 at 08:30:12AM +1100, Bojan Smojver wrote:
> On Thu, 2011-01-13 at 13:46 -0500, Ted Ts'o wrote:
> > I'm still a bit concerned with the call to set the pages' PTE to be
> > dirty that I found in the hibernate code, but I accept the fact that
> > removing it doesn't solve the s390 crash.  It still seems wrong to me,
> > and hopefully someone from linux-pm can look at that more closely. 
> 
> If I'm understanding things correctly, this should affect only the
> situation when compression is not used. Otherwise, pages that are read
> into by block I/O are decompressed first and copied into different
> pages. No?

When the pages get copied to their final resting place the dirty bits
of the corresponding physical pages get set automatically by the
hardware.
If there would be some code that would clear the dirty bit after the
copy operation then we would have some underindication and as a result
the possibility of data corruption, but we've never seen this.
However since s390 is the only architecture which has dirty bits for
physical pages I doubt that there is any such code present. So the
bug should happen independently of image compression.

What is missing is code that restores the original storage keys after
the pages have been copied to their final place.
I need to read the suspend/resume code and figure out how to fix this.
