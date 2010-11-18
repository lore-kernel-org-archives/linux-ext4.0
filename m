From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate
	super_operation
Date: Thu, 18 Nov 2010 08:48:04 -0500
Message-ID: <20101118134804.GN5618@dhcp231-156.rdu.redhat.com>
References: <1290065809-3976-1-git-send-email-lczerner@redhat.com> <20101118130630.GJ6178@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Lukas Czerner <lczerner@redhat.com>, tytso@mit.edu,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, hch@infradead.org,
	sandeen@redhat.com, Josef Bacik <josef@redhat.com>
To: Matthew Wilcox <matthew@wil.cx>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30035 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757516Ab0KRNst (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Nov 2010 08:48:49 -0500
Content-Disposition: inline
In-Reply-To: <20101118130630.GJ6178@parisc-linux.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 18, 2010 at 06:06:30AM -0700, Matthew Wilcox wrote:
> On Thu, Nov 18, 2010 at 08:36:48AM +0100, Lukas Czerner wrote:
> > There was concern that FITRIM ioctl is not common enough to be included
> > in core vfs ioctl, as Christoph Hellwig pointed out there's no real point
> > in dispatching this out to a separate vector instead of just through
> > ->ioctl.
> 
> Um, are you and Josef working independently of each other?  You don't
> seem to be cc'ing each other on your patches, and you're basically doing
> the same thing.
>

I guess they are the same thing in that we're both dealing with free'ing up
space, but thats about where the similarities end.  Lukas' work is in TRIM'ing
already free'd space, mine is in creating free'd space.  Plus I don't know
anything nor wish to ever know anything about TRIM ;).  Thanks,

Josef 
