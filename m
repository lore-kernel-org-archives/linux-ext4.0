From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [patch 1/5] mm: add nofail variants of kmalloc kcalloc and
 kzalloc
Date: Wed, 25 Aug 2010 20:19:01 -0400
Message-ID: <20100826001901.GL4453@thunk.org>
References: <20100825115709.GD4453@thunk.org>
 <1282740516.2605.3644.camel@laptop>
 <1282740778.2605.3652.camel@laptop>
 <E25A6DCB-3188-4CF9-9DC4-631192B2F0E2@mit.edu>
 <1282743090.2605.3696.camel@laptop>
 <alpine.DEB.2.00.1008251340420.16484@chino.kir.corp.google.com>
 <1282769729.1975.96.camel@laptop>
 <alpine.DEB.2.00.1008251406260.20253@chino.kir.corp.google.com>
 <1282771677.1975.138.camel@laptop>
 <alpine.DEB.2.00.1008251606450.31521@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Peter Zijlstra <peterz@infradead.org>,
	Jens Axboe <jaxboe@fusionio.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Neil Brown <neilb@suse.de>, Alasdair G Kergon <agk@redhat.com>,
	Chris Mason <chris.mason@oracle.com>,
	Steven Whitehouse <swhiteho@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"cluster-devel@redhat.com" <cluster-devel@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"reiserfs-devel@vger.kernel.org" <reiserfs-devel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: David Rientjes <rientjes@google.com>
Return-path: <reiserfs-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1008251606450.31521@chino.kir.corp.google.com>
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Aug 25, 2010 at 04:11:38PM -0700, David Rientjes wrote:
> 
> I'll repropose the patchset with __deprecated as you suggested.  Thanks!

And what Dave and I are saying is that we'll either need to do our on
loop to avoid the deprecation warning, or the use of the deprecated
function will probably be used forever...

	      	       	     	 - Ted
