From: Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH RFC] ext3 data=guarded v3
Date: Thu, 16 Apr 2009 20:00:37 +0200
Message-ID: <1239904837.6091.1.camel@marge.simson.net>
References: <1239816159-6868-1-git-send-email-chris.mason@oracle.com>
	 <1239881953.20254.17.camel@marge.simson.net>
	 <1239893771.4346.0.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:46036 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757131AbZDPSAm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Apr 2009 14:00:42 -0400
In-Reply-To: <1239893771.4346.0.camel@think.oraclecorp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2009-04-16 at 10:56 -0400, Chris Mason wrote:
> On Thu, 2009-04-16 at 13:39 +0200, Mike Galbraith wrote:
> > On Wed, 2009-04-15 at 13:22 -0400, Chris Mason wrote:
> > > Hello everyone,
> > 
> > Greetings,
> > 
> > > This passed a longer stress test and generally seems to be working.  I
> > > don't think anyone would recommend it as a default for 2.6.30, but it
> > > may be a good idea to have a review party and decide if it is safe enough
> > > to include so people can experiment with it.
> > 
> > I know you didn't say RFT, but I did some anyway, and found a 100%
> > repeatable corruption scenario wrt git+umount.
> > 
> 
> Well, that's a surprise.  I can trigger it here too, trying to figure
> out how this is different from the fsx and fsstress hammering.  It looks
> like git is just going good old fashioned writes, so I must be losing
> one or two of them.

Yeah, I spent 6 hours doing a lot of this and that, and all was peachy.
This was the only hiccup, and I totally accidentally hit it.

	-Mike

