From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH] block: Add a trace point whenever a barrier IO request
	is sent
Date: Fri, 23 Apr 2010 12:41:22 -0700
Message-ID: <20100423194122.GB15607@tux1.beaverton.ibm.com>
References: <20100421205626.GA15607@tux1.beaverton.ibm.com> <20100421212727.GY27497@kernel.dk>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Jens Axboe <jens.axboe@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100421212727.GY27497@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Apr 21, 2010 at 11:27:27PM +0200, Jens Axboe wrote:
> On Wed, Apr 21 2010, Darrick J. Wong wrote:
> > Simple debugging patch used to watch for barrier requests.  I've been using
> > this to watch ext4's barrier=1 behavior.
> 
> But barriers are already being logged, if you watch blkparse data, it'll
> be RB or WB events. So I don't see what this addition provides that we
> don't already have?

I also have the function graph tracer turned on, so I can (try to) map barrier
requests to specific chunks of ext4 code.  But, maybe there's a way to do this
with blkparse that I haven't found yet?

--D
