From: Pavel Machek <pavel@ucw.cz>
Subject: Re: two fsck.ext4's needed to clean filesystem
Date: Fri, 24 Jul 2015 16:27:42 +0200
Message-ID: <20150724142742.GA21571@amd>
References: <20150722141806.GA21181@amd>
 <20150722142159.GA21742@amd>
 <55AFC5BD.9000001@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, jack@suse.com, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60122 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbbGXO1o (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 24 Jul 2015 10:27:44 -0400
Content-Disposition: inline
In-Reply-To: <55AFC5BD.9000001@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi!

> >> Is that considered ok? Should fsck restart itself or report
> >> 'filesystem still has errors' in this case?
> 
> It should.

Ok, good.

> > delme.fsck.damaged: ***** FILE SYSTEM WAS MODIFIED *****
> > delme.fsck.damaged: 2053/25064 files (0.2% non-contiguous),
> > 97826/100000 blocks
> > Fsck lied about its success (result = 1)
> > pavel@amd:~/misc$ cp delme.fsck.original-damaged delme.report-2
> > 
> > (I can make the images public. Yes, it is artificial test.)
> 
> Please do - you're right, it should fix it on the first pass.

I put them on

http://atrey.karlin.mff.cuni.cz/~pavel/outgoing/delme.report-1
http://atrey.karlin.mff.cuni.cz/~pavel/outgoing/delme.report-2

. Let me know if you can reproduce it.

Thanks and best regards,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
