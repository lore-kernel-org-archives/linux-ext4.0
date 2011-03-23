From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 3/3] block: reimplement FLUSH/FUA to support merge
Date: Wed, 23 Mar 2011 16:37:01 -0700
Message-ID: <20110323233701.GA24354@tux1.beaverton.ibm.com>
References: <1295625598-15203-1-git-send-email-tj@kernel.org> <1295625598-15203-4-git-send-email-tj@kernel.org> <20110121185617.GI12072@redhat.com> <20110123102526.GA23121@htj.dyndns.org> <20110124203155.GA32261@tux1.beaverton.ibm.com> <20110125102128.GO27510@htj.dyndns.org> <4D3EB66C.4090006@kernel.dk>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>,
	tytso@mit.edu, shli@kernel.org, neilb@suse.de,
	adilger.kernel@dilger.ca, jack@suse.cz, snitzer@redhat.com,
	linux-kernel@vger.kernel.org, kmannth@us.ibm.com, cmm@us.ibm.com,
	linux-ext4@vger.kernel.org, rwheeler@redhat.com, hch@lst.de,
	josef@redhat.com
To: Jens Axboe <axboe@kernel.dk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:58769 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933061Ab1CWXhF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Mar 2011 19:37:05 -0400
Content-Disposition: inline
In-Reply-To: <4D3EB66C.4090006@kernel.dk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 25, 2011 at 12:39:24PM +0100, Jens Axboe wrote:
> On 2011-01-25 11:21, Tejun Heo wrote:
> > Hello, Darrick.
> > 
> > On Mon, Jan 24, 2011 at 12:31:55PM -0800, Darrick J. Wong wrote:
> >>> So, I think it's better to start with something simple and improve it
> >>> with actual testing.  If the current simple implementation can match
> >>> Darrick's previous numbers, let's first settle the mechanisms.  We can
> >>
> >> Yep, the fsync-happy numbers more or less match... at least for 2.6.37:
> >> http://tinyurl.com/4q2xeao
> > 
> > Good to hear.  Thanks for the detailed testing.
> > 
> >> I'll give 2.6.38-rc2 a try later, though -rc1 didn't boot for me, so these
> >> numbers are based on a backport to .37. :(
> > 
> > Well, there hasn' been any change in the area during the merge window
> > anyway, so I think testing on 2.6.37 should be fine.
> > 
> >>> I don't really think we should design the whole thing around broken
> >>> devices which incorrectly report writeback cache when it need not.
> >>> The correct place to work around that is during device identification
> >>> not in the flush logic.
> >>
> >> elm3a4_sas and elm3c71_extsas advertise writeback cache yet the
> >> flush completion times are suspiciously low.  I suppose it could be
> >> useful to disable flushes to squeeze out that last bit of
> >> performance, though I don't know how one goes about querying the
> >> disk array to learn if there's a battery behind the cache.  I guess
> >> the current mechanism (admin knob that picks a safe default) is good
> >> enough.
> > 
> > Yeap, that or a blacklist of devices which lie.
> > 
> > Jens, what do you think?  If you don't object, let's put this through
> > linux-next.
> 
> I like the approach, I'll queue it up for 2.6.39.

Is this patch set still on the merge list for 2.6.39?

--D
> 
> -- 
> Jens Axboe
> 
