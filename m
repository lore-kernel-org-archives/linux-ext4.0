From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/4] ext4: Fix deadlock during page writeback
Date: Wed, 6 Jul 2016 09:51:16 +0200
Message-ID: <20160706075116.GB14067@quack2.suse.cz>
References: <1466073736-30447-1-git-send-email-jack@suse.cz>
 <1466073736-30447-2-git-send-email-jack@suse.cz>
 <20160630150548.GC2028@thunk.org>
 <20160701090950.GB22922@quack2.suse.cz>
 <20160701165339.GB6075@thunk.org>
 <20160701174041.GA30040@quack2.suse.cz>
 <20160701212634.GA14277@thunk.org>
 <20160704141435.GA29557@thunk.org>
 <20160704155107.GB12022@quack2.suse.cz>
 <20160705033824.GD15193@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	Eryu Guan <eguan@redhat.com>, stable@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160705033824.GD15193@thunk.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon 04-07-16 23:38:24, Ted Tso wrote:
> On Mon, Jul 04, 2016 at 05:51:07PM +0200, Jan Kara wrote:
> > On Mon 04-07-16 10:14:35, Ted Tso wrote:
> > > This is what I'm currently testing; do you have objections to this?
> > 
> > Meh, I don't like it but it should work... Did you see any improvement with
> > your change or are you just operating on the assumption that you want as
> > few code while the handle is running as possible?
> 
> I haven't had a chance to try to benchmark it yet.  I've working at
> home over the long (US) holiday weekend, and the high core-count
> servers I need are on the internal work network, and it's pain to
> access them from home.
> 
> I've just been tired of seeing the sort of analysis that can be found
> at papers like:
> 
> https://www.usenix.org/system/files/conference/fast14/fast14-paper_kang.pdf

So the biggest gap shown in this paper is for buffered write where I suspect
ext4 suffers because it starts a handle for each write. There is some
low-hanging fruit though - we just need to start it when we may be updating
i_size. I'll try to look into this when I have time to setup proper
benchmark.

> (And there's a ATC 2016 paper which shows that things haven't gotten
> any better as well.)
> 
> Given that our massive lock bottlenecks come from the j_list_lock and
> j_state_lock, and that most of the contention happens when we are
> closing down a transaction for a commit, there is a pretty direct
> correlation between handle lifetimes and the contention statistics on
> the journal spinlocks.  Enough so that I've instrumented the handle
> type and handle line number in the jbd2_handle_stats tracepoint, and
> work to push down on the handle hold times have definitely helped our
> contention numbers.

Yeah, JBD2 scalability sucks. I suspect you are conflating two issues here
though. One issue is j_list_lock and j_state_lock contention - that is
exposed by starting handles often, doing lots of operations with buffers
etc. This is what the above paper shows. Another issue is that while a
transaction is preparing for commit, we have to wait for all outstanding
handles against that transaction and while we do that, we have no running
transaction and the whole journalling machinery is stalled. For this
problem, the time each handle runs is essential. This is what you've likely
seen in your testing.

Reducing j_list_lock and j_state_lock contention is IMO doable, although
the low hanging fruit is probably eaten these days ;). Fixing the second
problem is harder as that is inherent problem with block-level journalling.
I suspect we could allow starting another transaction while the previous
one is in "preparing for commit" phase but that would lead to two
transactions getting updates at one point in time which JBD2 currently does
not expect.

> So I do have experimental evidence that reducing code while the handle
> is running does matter in general.  I just don't have it for this
> specific case yet....

OK.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
