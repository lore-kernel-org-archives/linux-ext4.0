From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH, RFC] Don't do page stablization if
 !CONFIG_BLKDEV_INTEGRITY
Date: Thu, 8 Mar 2012 16:20:54 -0500
Message-ID: <20120308212054.GI29510@shiny>
References: <E1S5QTU-0005Cc-Kl@tytso-glaptop.cam.corp.google.com>
 <4F57F523.3020703@redhat.com>
 <4F581BF6.8000305@zabbo.net>
 <20120308155419.GB6777@thunk.org>
 <20120308180951.GB29510@shiny>
 <4F59148A.4070001@panasas.com>
 <20120308203741.GE29510@shiny>
 <x49linaj037.fsf@segfault.boston.devel.redhat.com>
 <20120308211221.GB11861@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeff Moyer <jmoyer@redhat.com>,
	Boaz Harrosh <bharrosh@panasas.com>,
	Zach Brown <zab@zabbo.net>, Eric Sandeen <sandeen@redhat.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120308211221.GB11861@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Mar 08, 2012 at 04:12:21PM -0500, Ted Ts'o wrote:
> On Thu, Mar 08, 2012 at 03:42:52PM -0500, Jeff Moyer wrote:
> > 
> > So now we're back to figuring out how to tell how long I/O will take?
> > If writeback is issuing random access I/Os to spinning media, you can
> > bet it might be a while.  Today, you could lower nr_requests to some
> > obscenely small number to improve worst-case latency.  I thought there
> > was some talk about improving the intelligence of writeback in this
> > regard, but it's a tough problem, especially given that writeback isn't
> > the only cook in the kitchen.
> 
> ... and it gets worse if there is any kind of I/O prioritization going
> on via ionice(), or (as was the case in our example) I/O cgroups were
> being used to provide proportional I/O rate controls.  I don't think
> it's realistic to assume the writeback code can predict how long I/O
> will take when it does a submission.

cgroups do make it much harder because it could be a simple IO priority
inversion.  The latencies are just going to be a fact of life for now
and the best choice is to skip the stable pages.

-chris
