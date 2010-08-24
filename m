From: Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [patch 1/5] mm: add nofail variants of kmalloc kcalloc and  kzalloc
Date: Tue, 24 Aug 2010 15:33:24 +0200
Message-ID: <4C73CA24.3060707@fusionio.com>
References: <alpine.DEB.2.00.1008240340010.18908@chino.kir.corp.google.com> <1282656558.2605.2742.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: David Rientjes <rientjes@google.com>,
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
To: Peter Zijlstra <peterz@infradead.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1282656558.2605.2742.camel@laptop>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 2010-08-24 15:29, Peter Zijlstra wrote:
> On Tue, 2010-08-24 at 03:50 -0700, David Rientjes wrote:
>> These were added as helper functions for documentation and auditability.
>> No future callers should be added.
> 
> git grep GFP_NOFAIL isn't auditable enough?
> 
> might as well declare these functions depricated if you really want to
> do this.

Agree, adding a helper function would seem to be going in the reverse
direction imho. Nobody will read that comment on top of the function.

Should be possible to warn at build time for anyone using __GFP_NOFAIL
without wrapping it in a function.

-- 
Jens Axboe

