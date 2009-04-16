From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH RFC] ext3 data=guarded v3
Date: Thu, 16 Apr 2009 10:44:30 +0200
Message-ID: <20090416084430.GA14150@duck.suse.cz>
References: <1239816159-6868-1-git-send-email-chris.mason@oracle.com> <alpine.LFD.2.00.0904151333020.4042@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34985 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752553AbZDPIoc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Apr 2009 04:44:32 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904151333020.4042@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 15-04-09 13:35:23, Linus Torvalds wrote:
> 
> 
> On Wed, 15 Apr 2009, Chris Mason wrote:
> > 
> > Here is another version of the data=guarded work for ext3.  The main
> > difference between this code and yesterday's is the guarded writepage
> > function now sends any newly allocated block through the old data=ordered code.
> 
> I'm inclined to apply the first two patches as infrastructure, since they 
> seem to make sense regardless of data=ordered. The ability to get a 
> callback when IO ends sounds like something that a number of cases might 
> find intriguing, and it's obviously how the actual IO has worked 
> internally anyway.
> 
> Comments?
  Yes, the first two patches look fine to me. I tried to review the third
patch yesterday but my mind has blown up when trying to track all the
possible interactions and I started doing something else to preserve last
bits of sanity ;). Will retry later...

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
