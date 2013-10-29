From: Jan Kara <jack@suse.cz>
Subject: Re: process hangs in ext4_sync_file
Date: Tue, 29 Oct 2013 18:53:19 +0100
Message-ID: <20131029175319.GC6087@quack.suse.cz>
References: <CAEfL3KniKZNzehPH1Z4eWhhNF_RHrE4vHoRTHDPrfYj4t_2LtA@mail.gmail.com>
 <20131023102042.GE1275@quack.suse.cz>
 <CAEfL3KnUhETAWeh-OoRYTR5GxYL26TjaT=j_WDZeW5xa3vAdeg@mail.gmail.com>
 <CAEfL3KmAXw+mE24kZkG4YHU3C98rU6pkbAwMhSO1pw1rg81HVw@mail.gmail.com>
 <20131029144649.GB1890@quack.suse.cz>
 <20131029170435.GA7681@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Sandeep Joshi <sanjos100@gmail.com>,
	linux-ext4@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41795 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758416Ab3J2RxW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Oct 2013 13:53:22 -0400
Content-Disposition: inline
In-Reply-To: <20131029170435.GA7681@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 29-10-13 10:04:35, Christoph Hellwig wrote:
> On Tue, Oct 29, 2013 at 03:46:49PM +0100, Jan Kara wrote:
> >   No, it isn't really recommended for ordinary SSDs. If you have one of
> > those fancy PCIe attached SSDs, 'discard' option might be useful for you
> > but for usual SATA attached ones it's usually a disaster. There you might
> > be better off running 'fstrim' command once a week or something like that.
> 
> While some early consumer SSDs were indeed pretty bad just by
> theselves, and the lack of queue TRIM on most devices doesn't help,
> these days the biggest blame is with Linux itself.  Not only can't we
> merge multiple requests into a single ranged TRIM, but we also execute
> them all synchronously, meaning a constant stream of queue drains if
> the discard option is used.
> 
> Once we've fixed those issue we can start blaming those vendors that
> have issues again, but until that has happened we'd better shut up..
  OK, right. I've checked the spec and indeed the original TRIM
specification already allows for several ranges in one trim command which
we aren't able to use. I thought the multi-range thing was only a recent
addition. Next time I'll be blaming our block layer then ;) Thanks for
correction.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
