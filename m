From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate super_operation
Date: Fri, 19 Nov 2010 09:40:44 -0500
Message-ID: <1290177488-sup-6540@think>
References: <1290065809-3976-1-git-send-email-lczerner@redhat.com> <20101118130630.GJ6178@parisc-linux.org> <20101118134804.GN5618@dhcp231-156.rdu.redhat.com> <20101118141957.GK6178@parisc-linux.org> <20101118142918.GA18510@infradead.org> <1290100750.3041.72.camel@mulgrave.site> <4CE59C9E.6050902@teksavvy.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: James Bottomley <james.bottomley@suse.de>,
	Christoph Hellwig <hch@infradead.org>,
	Matthew Wilcox <matthew@wil.cx>,
	Josef Bacik <josef@redhat.com>,
	Lukas Czerner <lczerner@redhat.com>, tytso <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	sandeen <sandeen@redhat.com>
To: Mark Lord <kernel@teksavvy.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:59839 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856Ab0KSOmK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Nov 2010 09:42:10 -0500
In-reply-to: <4CE59C9E.6050902@teksavvy.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Excerpts from Mark Lord's message of 2010-11-18 16:37:34 -0500:
> On 10-11-18 12:19 PM, James Bottomley wrote:
> >
> > Not stepping into the debate: I'm happy to see punch go to the mapping
> > data and FITRIM pick it up later.
> >
> > However, I think it's time to question whether we actually still want to
> > allow online discard at all.  Most of the benchmarks show it to be a net
> > lose to almost everything (either SSD or Thinly Provisioned arrays), so
> > it's become an "enable this to degrade performance" option with no
> > upside.
> 
> I also suspect that online TRIM exerts significant premature wear on the SSDs.
> TRIM operations most likely trigger immediate copy/erase operations internal
> to most SSDs, often regardless of the amount of data being trimmed.
> 
> Performing a 256KB erase because of a 1024-byte TRIM, over and over, is going
> to harm the expected lifetime of an SSD.  Sure, some SSDs may do things differently
> internally, but I don't see it working that way in much of the current crop of SSDs.
> 
> Currently, I patch my kernels to remove the automatic online TRIMs.
> Is there a knob somewhere for this in the later kernels?

We've been told that online and constant trimming is the default in
windows7.   The ssds are most likely to just start ignoring the trims
they can't service efficiently.

-chris
