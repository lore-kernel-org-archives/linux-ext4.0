From: Jan Kara <jack@suse.cz>
Subject: Re: locking typo in ext4_mb_add_n_trim()
Date: Tue, 31 Mar 2009 15:00:32 +0200
Message-ID: <20090331130032.GE20127@atrey.karlin.mff.cuni.cz>
References: <Pine.LNX.4.64.0903262204430.4167@usbsys.site> <49CCDFDB.9000109@redhat.com> <20090327233634.GI5176@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	Dan Carpenter <error27@gmail.com>, adilger@sun.com,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41124 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754023AbZCaNAe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 31 Mar 2009 09:00:34 -0400
Content-Disposition: inline
In-Reply-To: <20090327233634.GI5176@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> On Fri, Mar 27, 2009 at 09:16:59AM -0500, Eric Sandeen wrote:
> > 
> > although I wonder why we don't trip over this in spinlock debugging
> > (seems like it'd lead to a double unlock at times)  I wonder if we can
> > tie this to any other bugs we've seen.
> 
> I was wondering if it could be tied to the "rm -rf" soft lockup hang....
> 
> I wonder if vendor kernels (specifically, Ubuntu in this case) disable
> spinlock debugging, which is why we wouldn't have seen the double
> unlock warning.  (Or maybe it happened earlier in the log, and users
> didn't notice it).
  Don't know about Ubuntu but SUSE has definitely turned off spinlock
debugging (I guess because it may cost some performance) and most other
debug stuff.

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
