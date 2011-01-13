From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Oops while going into hibernate
Date: Thu, 13 Jan 2011 13:46:26 -0500
Message-ID: <20110113184626.GA31800@thunk.org>
References: <alpine.LFD.2.02.1101121443230.1900@localhost6.localdomain6>
 <20110112162655.GA13496@thunk.org>
 <alpine.LFD.2.02.1101121755400.2011@localhost6.localdomain6>
 <20110112172646.GB13496@thunk.org>
 <alpine.LFD.2.02.1101121934060.2011@localhost6.localdomain6>
 <A01161D0-D08F-4522-A546-90057B2E1F2A@mit.edu>
 <alpine.LFD.2.02.1101131238480.1899@localhost6.localdomain6>
 <20110113133612.GD2534@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sebastian Ott <sebott@linux.vnet.ibm.com>,
	"linux-ext4@vger.kernel.org development" <linux-ext4@vger.kernel.org>,
	LKML Kernel <linux-kernel@vger.kernel.org>,
	pm list <linux-pm@lists.linux-foundation.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:60815 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835Ab1AMSqi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Jan 2011 13:46:38 -0500
Content-Disposition: inline
In-Reply-To: <20110113133612.GD2534@osiris.boeblingen.de.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 13, 2011 at 02:36:12PM +0100, Heiko Carstens wrote:
> 
> Eeeek... this seems to be an architecture specific bug that is only present
> on s390.
> The dirty bit for user space pages on all architectures but s390 are stored
> into the PTE's. On s390 however they are stored into the storage key that
> exists per _physical_ page.
> So, what we should have done, when implementing suspend/resume on s390, is
> to save the storage key for each page and write that to the suspend device
> and upon resume restore the storage key contents for each physical page.
> The code that would do that is missing... Hence _all_ pages of the resumed
> image are dirty after they have been copied to their location.
> *ouch*
> 
> Will fix.

Glad you found the root cause.  If you don't think you can get this
fixed quickly, before -rc2 or -rc3, I can fairly quickly add some
checks to ext4 to detect this condition, issue a warning, and then
return an error code from the ->writepages() hook.  (Which will then
promptly be ignored by the writeback code, since, hey, what are they
going to do with an error, but that's a discussion for another forum.)
Would that be helpful?

I'm still a bit concerned with the call to set the pages' PTE to be
dirty that I found in the hibernate code, but I accept the fact that
removing it doesn't solve the s390 crash.  It still seems wrong to me,
and hopefully someone from linux-pm can look at that more closely.

    	      	      	   	    	     - Ted
