From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 3/3] block: reimplement FLUSH/FUA to support merge
Date: Tue, 25 Jan 2011 14:56:26 -0800
Message-ID: <20110125225626.GD32261@tux1.beaverton.ibm.com>
References: <1295625598-15203-1-git-send-email-tj@kernel.org> <1295625598-15203-4-git-send-email-tj@kernel.org> <20110121185617.GI12072@redhat.com> <20110123102526.GA23121@htj.dyndns.org> <20110124203155.GA32261@tux1.beaverton.ibm.com> <20110125102128.GO27510@htj.dyndns.org>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Vivek Goyal <vgoyal@redhat.com>, axboe@kernel.dk, tytso@mit.edu,
	shli@kernel.org, neilb@suse.de, adilger.kernel@dilger.ca,
	jack@suse.cz, snitzer@redhat.com, linux-kernel@vger.kernel.org,
	kmannth@us.ibm.com, cmm@us.ibm.com, linux-ext4@vger.kernel.org,
	rwheeler@redhat.com, hch@lst.de, josef@redhat.com
To: Tejun Heo <tj@kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:55918 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827Ab1AYW4a (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Jan 2011 17:56:30 -0500
Content-Disposition: inline
In-Reply-To: <20110125102128.GO27510@htj.dyndns.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 25, 2011 at 11:21:28AM +0100, Tejun Heo wrote:
> Hello, Darrick.
> 
> On Mon, Jan 24, 2011 at 12:31:55PM -0800, Darrick J. Wong wrote:
> > > So, I think it's better to start with something simple and improve it
> > > with actual testing.  If the current simple implementation can match
> > > Darrick's previous numbers, let's first settle the mechanisms.  We can
> > 
> > Yep, the fsync-happy numbers more or less match... at least for 2.6.37:
> > http://tinyurl.com/4q2xeao
> 
> Good to hear.  Thanks for the detailed testing.
> 
> > I'll give 2.6.38-rc2 a try later, though -rc1 didn't boot for me, so these
> > numbers are based on a backport to .37. :(
> 
> Well, there hasn' been any change in the area during the merge window
> anyway, so I think testing on 2.6.37 should be fine.

Well, I gave it a spin on -rc2 with no problems and no significant change in
performance, so:

Acked-by: Darrick J. Wong <djwong@us.ibm.com>

> > > I don't really think we should design the whole thing around broken
> > > devices which incorrectly report writeback cache when it need not.
> > > The correct place to work around that is during device identification
> > > not in the flush logic.
> > 
> > elm3a4_sas and elm3c71_extsas advertise writeback cache yet the
> > flush completion times are suspiciously low.  I suppose it could be
> > useful to disable flushes to squeeze out that last bit of
> > performance, though I don't know how one goes about querying the
> > disk array to learn if there's a battery behind the cache.  I guess
> > the current mechanism (admin knob that picks a safe default) is good
> > enough.
> 
> Yeap, that or a blacklist of devices which lie.

Hmm... I don't think a blacklist would work for our arrays, since one can force
them to run with write cache and no battery.  I _do_ have a patch that adds a
sysfs knob to the block layer to drop flush/fua if the admin really really
really wants it, so I'll send that out shortly along with another one to remove
the barrier= mount option from ext4.

(Unless the screams of objection rain from the skies. :))

--D
