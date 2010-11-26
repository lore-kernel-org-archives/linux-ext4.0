From: Mark Lord <kernel@teksavvy.com>
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate super_operation
Date: Fri, 26 Nov 2010 08:49:01 -0500
Message-ID: <4CEFBACD.6040603@teksavvy.com>
References: <20101118134804.GN5618@dhcp231-156.rdu.redhat.com> <20101118141957.GK6178@parisc-linux.org> <20101118142918.GA18510@infradead.org> <1290100750.3041.72.camel@mulgrave.site> <alpine.LFD.2.00.1011181826550.15886@dhcp-lab-213.englab.brq.redhat.com> <1290168976.2570.45.camel@dolmen> <4CE68155.50705@teksavvy.com> <20101119140203.GC10039@thunk.org> <4CE69940.6040908@teksavvy.com> <alpine.LFD.2.00.1011191640320.3238@dhcp-lab-213.englab.brq.redhat.com> <20101119163013.GJ10039@thunk.org> <4CEDCE60.9050109@teksavvy.com> <AANLkTimkGr=mpf6xbjvSFc9hZtf6f+UQ2F-N9aZxBsgb@mail.gmail.com> <4CEE7884.5010007@teksavvy.com> <AANLkTi=J_J68+758XOCYp=+YXaU1+yJjRrvBsAeB5eUi@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ted Ts'o <tytso@mit.edu>, Lukas Czerner <lczerner@redhat.com>,
	Steven Whitehouse <swhiteho@redhat.com>,
	James Bottomley <James.Bottomley@suse.de>,
	Christoph Hellwig <hch@infradead.org>,
	Matthew Wilcox <matthew@wil.cx>,
	Josef Bacik <josef@redhat.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	sandeen@redhat.com
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:44548 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752479Ab0KZNtF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Nov 2010 08:49:05 -0500
In-Reply-To: <AANLkTi=J_J68+758XOCYp=+YXaU1+yJjRrvBsAeB5eUi@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10-11-25 11:24 AM, Greg Freemyer wrote:
>
> I'm away from my systems today, but is there an easy way to tweak
> wiper.sh or hdparm to cause only a single range per trim command.
>
> I'm curious if for the Sandforce that would still be in the 90 second
> range, or closer to 64x that.

Good question.  The Indilinx based drives would be in the 64x range,
no doubt there.  But I don't know about the Sandforce.

And I don't think I'm willing to inflict so many life-shortening erase
cycles onto it just to find out.

One thing to note:  the execution time for TRIM does vary depending upon
whether the (logical) LBAs are already mostly in a "trimmed" state or not.

So anyone aspiring to benchmark this stuff will need to keep that in mind.
My timings above were for "already trimmed" cases.  I would expect them
to be much slower (2x - 3x) if the sectors all held data prior to trim.

Cheers
