From: Christoph Hellwig <hch@infradead.org>
Subject: Re: process hangs in ext4_sync_file
Date: Tue, 29 Oct 2013 10:04:35 -0700
Message-ID: <20131029170435.GA7681@infradead.org>
References: <CAEfL3KniKZNzehPH1Z4eWhhNF_RHrE4vHoRTHDPrfYj4t_2LtA@mail.gmail.com>
 <20131023102042.GE1275@quack.suse.cz>
 <CAEfL3KnUhETAWeh-OoRYTR5GxYL26TjaT=j_WDZeW5xa3vAdeg@mail.gmail.com>
 <CAEfL3KmAXw+mE24kZkG4YHU3C98rU6pkbAwMhSO1pw1rg81HVw@mail.gmail.com>
 <20131029144649.GB1890@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sandeep Joshi <sanjos100@gmail.com>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43431 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287Ab3J2REm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Oct 2013 13:04:42 -0400
Content-Disposition: inline
In-Reply-To: <20131029144649.GB1890@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 29, 2013 at 03:46:49PM +0100, Jan Kara wrote:
>   No, it isn't really recommended for ordinary SSDs. If you have one of
> those fancy PCIe attached SSDs, 'discard' option might be useful for you
> but for usual SATA attached ones it's usually a disaster. There you might
> be better off running 'fstrim' command once a week or something like that.

While some early consumer SSDs were indeed pretty bad just by
theselves, and the lack of queue TRIM on most devices doesn't help,
these days the biggest blame is with Linux itself.  Not only can't we
merge multiple requests into a single ranged TRIM, but we also execute
them all synchronously, meaning a constant stream of queue drains if
the discard option is used.

Once we've fixed those issue we can start blaming those vendors that
have issues again, but until that has happened we'd better shut up..

