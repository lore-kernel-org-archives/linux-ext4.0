From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Please help: Is ext4 counting trims as writes, or is something
 killing my SSD?
Date: Thu, 12 Sep 2013 14:47:32 -0400
Message-ID: <20130912184732.GA28067@thunk.org>
References: <20130912141856.GA17640@jak-x230>
 <1378997643.28638.53.camel@hp-a6734f>
 <5231DB33.9090104@redhat.com>
 <20130912153232.GA19548@jak-x230>
 <5231E346.5030000@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Julian Andres Klode <jak@jak-linux.org>,
	Calvin Walton <calvin.walton@kepstin.ca>,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:59140 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754550Ab3ILSrh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Sep 2013 14:47:37 -0400
Content-Disposition: inline
In-Reply-To: <5231E346.5030000@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 12, 2013 at 10:52:38AM -0500, Eric Sandeen wrote:
> 
> However, it seems a little odd to me that ext4 feels it necessary to issue
> discards on blocks which have been fallocated but not written to, I'll have
> to think about that part (doesn't really matter for your case, it's just a
> curiosity).

For fstrim, we issue discards based on blocks which are not in use
according to the block allocation bitmap.

It shouldn't matter that we've issued discard on blocks which had been
previously discarded, and in fact, it might help, since sometimes
storage devices only traces block usage on large granularities ---
that is, it might only releases blocks on a thin provisioned storage
when a full megabyte worth of blocks are discarded.

					- Ted
