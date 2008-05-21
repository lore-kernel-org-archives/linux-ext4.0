From: Pavel Machek <pavel@suse.cz>
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Date: Wed, 21 May 2008 13:22:25 +0200
Message-ID: <20080521112224.GD5028@ucw.cz>
References: <482DDA56.6000301@redhat.com> <20080518211140.b29bee30.akpm@linux-foundation.org> <200805191316.27551.chris.mason@oracle.com> <200805191439.36577.chris.mason@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Eric Sandeen <sandeen@redhat.com>,
	Theodore Tso <tytso@mit.edu>, Andi Kleen <andi@firstfloor.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:48882 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756916AbYEULWd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 21 May 2008 07:22:33 -0400
Content-Disposition: inline
In-Reply-To: <200805191439.36577.chris.mason@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi!
> >
> > Here's a test workload that corrupts ext3 50% of the time on power fail
> > testing for me.  The machine in this test is my poor dell desktop (3ghz,
> > dual core, 2GB of ram), and the power controller is me walking over and
> > ripping the plug out the back.
> 
> Here's a new version that still gets about corruptions 50% of the time, but 
> does it with fewer files by using longer file names (240 chars instead of 160 
> chars).
> 
> I tested this one with a larger FS (40GB instead of 2GB) and larger log (128MB 
> instead of 32MB).  barrier-test -s 32 -p 1500 was still able to get a 50% 
> corruption rate on the larger FS.

Ok, Andrew, is this enough to get barrier patch applied and stop
corrupting data in default config, or do you want some more testing?

I guess 20% benchmark regression is bad, but seldom and impossible to
debug data corruption is worse...
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
