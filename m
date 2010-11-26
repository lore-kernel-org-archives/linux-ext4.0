From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate
 super_operation
Date: Fri, 26 Nov 2010 15:00:49 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1011261456080.2936@dhcp-lab-213.englab.brq.redhat.com>
References: <20101118134804.GN5618@dhcp231-156.rdu.redhat.com> <20101118141957.GK6178@parisc-linux.org> <20101118142918.GA18510@infradead.org> <1290100750.3041.72.camel@mulgrave.site> <alpine.LFD.2.00.1011181826550.15886@dhcp-lab-213.englab.brq.redhat.com>
 <1290168976.2570.45.camel@dolmen> <4CE68155.50705@teksavvy.com> <20101119140203.GC10039@thunk.org> <4CE69940.6040908@teksavvy.com> <alpine.LFD.2.00.1011191640320.3238@dhcp-lab-213.englab.brq.redhat.com> <20101119163013.GJ10039@thunk.org> <4CEDCE60.9050109@teksavvy.com>
 <AANLkTimkGr=mpf6xbjvSFc9hZtf6f+UQ2F-N9aZxBsgb@mail.gmail.com> <4CEE7884.5010007@teksavvy.com> <AANLkTi=J_J68+758XOCYp=+YXaU1+yJjRrvBsAeB5eUi@mail.gmail.com> <4CEFBACD.6040603@teksavvy.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Greg Freemyer <greg.freemyer@gmail.com>,
	"Ted Ts'o" <tytso@mit.edu>, Lukas Czerner <lczerner@redhat.com>,
	Steven Whitehouse <swhiteho@redhat.com>,
	James Bottomley <James.Bottomley@suse.de>,
	Christoph Hellwig <hch@infradead.org>,
	Matthew Wilcox <matthew@wil.cx>,
	Josef Bacik <josef@redhat.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	sandeen@redhat.com
To: Mark Lord <kernel@teksavvy.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5142 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479Ab0KZOBJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 26 Nov 2010 09:01:09 -0500
In-Reply-To: <4CEFBACD.6040603@teksavvy.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 26 Nov 2010, Mark Lord wrote:

> On 10-11-25 11:24 AM, Greg Freemyer wrote:
> > 
> > I'm away from my systems today, but is there an easy way to tweak
> > wiper.sh or hdparm to cause only a single range per trim command.
> > 
> > I'm curious if for the Sandforce that would still be in the 90 second
> > range, or closer to 64x that.
> 
> Good question.  The Indilinx based drives would be in the 64x range,
> no doubt there.  But I don't know about the Sandforce.
> 
> And I don't think I'm willing to inflict so many life-shortening erase
> cycles onto it just to find out.
> 
> One thing to note:  the execution time for TRIM does vary depending upon
> whether the (logical) LBAs are already mostly in a "trimmed" state or not.
> 
> So anyone aspiring to benchmark this stuff will need to keep that in mind.
> My timings above were for "already trimmed" cases.  I would expect them
> to be much slower (2x - 3x) if the sectors all held data prior to trim.
> 
> Cheers
> 

I have already did some TRIM benchmarking, but especially regarding trim
extent size. Also there is a tool test-discard for that purpose, so it
may be handy for anyone trying to do something similar.

http://people.redhat.com/lczerner/discard/

Thanks!

-Lukas
