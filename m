From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH RFC] jbd: don't wake kjournald unnecessarily
Date: Fri, 11 Jan 2013 20:03:51 +0100
Message-ID: <20130111190351.GA19912@quack.suse.cz>
References: <20121219012710.GF5987@quack.suse.cz>
 <20121219020526.GG5987@quack.suse.cz>
 <50D12FC3.6090209@redhat.com>
 <20121219081334.GB20163@quack.suse.cz>
 <20121219153725.GD7795@thunk.org>
 <20121219171401.GB28042@quack.suse.cz>
 <20121219202734.GA18804@thunk.org>
 <50D49606.3020708@redhat.com>
 <20121221174602.GA31731@thunk.org>
 <50F040D8.6060801@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46805 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753533Ab3AKTDy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Jan 2013 14:03:54 -0500
Content-Disposition: inline
In-Reply-To: <50F040D8.6060801@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 11-01-13 10:42:00, Eric Sandeen wrote:
> On 12/21/12 11:46 AM, Theodore Ts'o wrote:
> > On Fri, Dec 21, 2012 at 11:01:58AM -0600, Eric Sandeen wrote:
> >>> I'm also really puzzled about how Eric's patch makes a 10% different
> >>> on the AIM7 benchmark; as you've pointed out, that will just cause an
> >>> extra wakeup of the jbd/jbd2 thread, which should then quickly check
> >>> and decide to go back to sleep.
> >>
> >> Ted, just to double check - is that some wondering aloud, or a NAK
> >> of the original patch? :)
> > 
> > I'm still thinking....  Things that I don't understand worry me, since
> > there's a possibility there's more going on than we think.
> > 
> > Did you have a chance to have your perf people enable the the
> > jbd2_run_stats tracepoint, to see how the stats change with and
> > without the patch?
> 
> No tracepoint yet, but here's some data from the jbd2 info proc file
> for a whole AIM7 run, averaged over all devices.
> 
> Prior to d9b0193 jbd: fix fsync() tid wraparound bug went in:
> 
> 3387.93 transaction, each up to 8192 blocks
> average:
> 102.661ms waiting for transaction
> 189ms running transaction
> 65.375ms transaction was being locked
> 17.8393ms flushing data (in ordered mode)
> 164.518ms logging transaction
> 3694.29us average transaction commit time
> 2090.05 handles per transaction
> 12.5893 blocks per transaction
> 13.5893 logged blocks per transaction
> 
> with d9b0193 in place, the benchmark was about 10% slower:
> 
> 2857.96 transaction, each up to 8192 blocks
> average:
> 108.482ms waiting for transaction
> 266.286ms running transaction
> 71.625ms transaction was being locked
> 2.76786ms flushing data (in ordered mode)
> 252.625ms logging transaction
> 5932.82us average transaction commit time
> 2551.21 handles per transaction
> 43.25 blocks per transaction
> 44.25 logged blocks per transaction
> 
> and with my wake changes:
> 
> 3775.61 transaction, each up to 8192 blocks
> average:
> 92.9286ms waiting for transaction
> 173.571ms running transaction
> 60.3036ms transaction was being locked
> 16.6964ms flushing data (in ordered mode)
> 149.464ms logging transaction
> 3849.07us average transaction commit time
> 1924.84 handles per transaction
> 13.3036 blocks per transaction
> 14.3036 logged blocks per transaction
> 
> TBH though, this is somewhat opposite of what I'd expect; I thought more
> wakes might mean smaller transactions - except the wakes were "pointless"
> - so I'm not quite sure what's going on yet.  We can certainly see the
> difference, though, and that my change gets us back to the prior
> behavior.
  Yes, that's what I'd expect if the difference was really in IO. But
apparently the benchmark is CPU bound on the machine and so the higher
amount of work we do under j_state_lock (wake_up() has some small
cost after all - it disables interrupts and takes q->lock) results in
kjournald taking longer to wake and do its work. It might be interesting to
know about how many useless wakeups are we speaking here?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
