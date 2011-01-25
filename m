From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 3/3] block: reimplement FLUSH/FUA to support merge
Date: Tue, 25 Jan 2011 16:04:16 -0500
Message-ID: <20110125210414.GC3013@redhat.com>
References: <1295625598-15203-1-git-send-email-tj@kernel.org>
 <1295625598-15203-4-git-send-email-tj@kernel.org>
 <20110122004955.GA17792@redhat.com>
 <20110123103133.GC23121@htj.dyndns.org>
 <20110125204606.GE10664@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tejun Heo <tj@kernel.org>, axboe@kernel.dk, tytso@mit.edu,
	djwong@us.ibm.com, shli@kernel.org, neilb@suse.de,
	adilger.kernel@dilger.ca, jack@suse.cz,
	linux-kernel@vger.kernel.org, kmannth@us.ibm.com, cmm@us.ibm.com,
	linux-ext4@vger.kernel.org, rwheeler@redhat.com, hch@lst.de,
	josef@redhat.com
To: Vivek Goyal <vgoyal@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48872 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753545Ab1AYVEc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Jan 2011 16:04:32 -0500
Content-Disposition: inline
In-Reply-To: <20110125204606.GE10664@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 25 2011 at  3:46pm -0500,
Vivek Goyal <vgoyal@redhat.com> wrote:

> On Sun, Jan 23, 2011 at 11:31:33AM +0100, Tejun Heo wrote:
> > On Fri, Jan 21, 2011 at 07:49:55PM -0500, Mike Snitzer wrote:
> > > > + * If the device doesn't have writeback cache, FLUSH and FUA don't make any
> > > > + * difference.  The requests are either completed immediately if there's no
> > > > + * data or executed as normal requests otherwise.
> > > 
> > > For devices without a writeback cache, I'm not seeing where pure flushes
> > > are completed immediately.  But I do see where data is processed
> > > directly in blk_insert_flush().
> > 
> > Yeah, it does.  Pure flushes on a device w/o writeback cache, @policy
> > is zero and blk_flush_complete_seq() will directly proceed to
> > REQ_FSEQ_DONE.
> 
> I see following code in __generic_make_request(). I am wondering if empty
> flushes will be completed here itself if device does not have writeback
> cache.
> 
>                 /*
>                  * Filter flush bio's early so that make_request based
>                  * drivers without flush support don't have to worry
>                  * about them.
>                  */
>                 if ((bio->bi_rw & (REQ_FLUSH | REQ_FUA)) && !q->flush_flags) {
>                         bio->bi_rw &= ~(REQ_FLUSH | REQ_FUA);
>                         if (!nr_sectors) {
>                                 err = 0;
>                                 goto end_io;
>                         }
>                 }

Yes, due to the !q->flush_flags check, empty flushes will complete here
if the device's request_queue doesn't advertise support for FLUSH or FUA
via blk_queue_flush().

Mike


