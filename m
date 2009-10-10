From: Theodore Tso <tytso@mit.edu>
Subject: Re: [Bug 14256] kernel BUG at fs/ext3/super.c:435
Date: Fri, 9 Oct 2009 21:31:31 -0400
Message-ID: <20091010013131.GC18440@mit.edu>
References: <bug-14256-13602@http.bugzilla.kernel.org/> <200910092201.n99M1iBY007169@demeter.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, bugzilla-daemon@bugzilla.kernel.org
To: Mikael Pettersson <mikpe@it.uu.se>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:52062 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753005AbZJJBcK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 9 Oct 2009 21:32:10 -0400
Content-Disposition: inline
In-Reply-To: <200910092201.n99M1iBY007169@demeter.kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 09, 2009 at 10:01:44PM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> > Not fixed in 2.6.32-rc3. A glibc rebuild + install triggered the
> > exact same bug on the third machine.

Can you isolate this down to something simpler?  Will "make install"
followed by a reboot be sufficient to replicate the assertion failure?
If it does, will copying in a new version of libc.so.6 and then
rebooting be enough to trigger the assert failure?

Thanks,

	     	       	       	   	  - Ted
