From: tytso@mit.edu
Subject: Re: [patch/rft] jbd2: tag journal writes as metadata I/O
Date: Mon, 5 Apr 2010 17:01:33 -0400
Message-ID: <20100405210133.GG23670@thunk.org>
References: <x49iq8b9ep5.fsf@segfault.boston.devel.redhat.com>
 <20100405175205.GA4681@thunk.org>
 <x49hbnpkaqw.fsf@segfault.boston.devel.redhat.com>
 <20100405194803.GC23670@thunk.org>
 <x49zl1hiqoz.fsf@segfault.boston.devel.redhat.com>
 <x49vdc5iqcz.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	jens.axboe@oracle.com, esandeen@redhat.com
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <x49vdc5iqcz.fsf@segfault.boston.devel.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Apr 05, 2010 at 04:41:48PM -0400, Jeff Moyer wrote:
> > Sorry, Ted, what I meant to say was that iozone showed differences
> > between deadline and cfq, where cfq's performance was much worse than
> > deadline's.
> 
> And to be 100% clear, with the patch, the performance differences
> between deadline and cfq were in the noise.

Right, and since most people don't actually change the I/O scheduler
from cfq, this is basically a performance improvement patch, which is
how I'm going to describe it.  :-)

						- Ted
