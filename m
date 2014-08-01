From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/2] new API to allocate buffer-cache for superblock in
 non-movable area
Date: Fri, 1 Aug 2014 17:24:59 +0200
Message-ID: <20140801152459.GA7525@quack.suse.cz>
References: <53D8A258.7010904@lge.com>
 <20140730101143.GB19205@quack.suse.cz>
 <53D985C0.3070300@lge.com>
 <20140731000355.GB25362@quack.suse.cz>
 <53D98FBB.6060700@lge.com>
 <20140731122114.GA5240@quack.suse.cz>
 <53DADA2F.1020404@lge.com>
 <53DAE820.7050508@lge.com>
 <20140801095700.GB27281@quack.suse.cz>
 <20140801133618.GJ19379@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Gioh Kim <gioh.kim@lge.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-mm@kvack.org,
	Minchan Kim <minchan@kernel.org>, Joonsoo Kim <js1304@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20140801133618.GJ19379@twins.programming.kicks-ass.net>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Fri 01-08-14 15:36:18, Peter Zijlstra wrote:
> On Fri, Aug 01, 2014 at 11:57:00AM +0200, Jan Kara wrote:
> > So the quiestion really is how hard guarantee do you need that a page in
> > movable zone is really movable. Or better in what timeframe should it be
> > movable? It may be possible to make e.g. migratepage callback for ext4
> > blkdev pages which will handle migration of pages that are just idly
> > sitting in a journal waiting to be committed. That may be reasonably doable
> > although it won't be perfect. Or we may just decide it's not worth the
> > bother and allocate all blkdev pages from unmovable zone...
> 
> So the point of CMA is to cater to those (arguably broken) devices that
> do not have scatter gather IO, and these include things like the camera
> device on your phone.
> 
> Previously (and possibly currently) your android Linux kernel will
> simply preallocate a massive physically linear chunk of memory and
> assign it to the camera hardware and not use it at all.
> 
> This is a terrible waste for most of the time people aren't running
> their camera app at all. So the point is to allow usage of the memory,
> but upon request be able to 'immediately' clear it through
> migration/writeback.
> 
> So we should be fairly 'quick' in making the memory available,
> definitely sub second timeframes.
  OK, makes sense. But then if there's heavy IO going on, anything that has
IO pending on it is pinned and IO completion can easily take something
close to a second or more. So meeting subsecond deadlines may be tough even
for ordinary data pages under heavy load, even more so for metadata where
there are further constraints. OTOH phones aren't usually IO bound so in
practice it needn't be so bad ;). So if it is sub-second unless someone
loads the storage, then that sounds doable even for metadata. But we'll
need to attach ->migratepage callback to blkdev pages and at least in ext4
case teach it how to move pages tracked by the journal.
 
> Sadly its not only mobile devices that excel in crappy hardware, there's
> plenty desktop stuff that could use this too, like some of the v4l
> devices iirc.
  Yeah, but in such usecases the guarantees we can offer for completion of
migration are even more vague :(.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
