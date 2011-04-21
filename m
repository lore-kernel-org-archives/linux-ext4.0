From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: buffered writeback torture program
Date: Thu, 21 Apr 2011 11:35:47 -0400
Message-ID: <20110421153547.GF8192@redhat.com>
References: <1303322378-sup-1722@think>
 <20110420220626.GL29872@redhat.com>
 <1303383609-sup-2330@think>
 <1303399343-sup-9292@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>, xfs <xfs@oss.sgi.com>,
	jack <jack@suse.cz>, axboe <axboe@kernel.dk>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24747 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915Ab1DUPgF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Apr 2011 11:36:05 -0400
Content-Disposition: inline
In-Reply-To: <1303399343-sup-9292@think>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 21, 2011 at 11:25:41AM -0400, Chris Mason wrote:
> Excerpts from Chris Mason's message of 2011-04-21 07:09:11 -0400:
> > Excerpts from Vivek Goyal's message of 2011-04-20 18:06:26 -0400:
> > > > 
> > > > In this case the 128s spent in write was on a single 4K overwrite on a
> > > > 4K file.
> > > 
> > > Chris, You seem to be doing 1MB (32768*32) writes on fsync file instead of 4K.
> > > I changed the size to 4K still not much difference though.
> > 
> > Whoops, I had that change made locally but didn't get it copied out.
> > 
> > > 
> > > Once the program has exited because of high write time, i restarted it and
> > > this time I don't see high write times.
> > 
> > I see this for some of my runs as well.
> > 
> > > 
> > > First run
> > > ---------
> > > # ./a.out 
> > > setting up random write file
> > > done setting up random write file
> > > starting fsync run
> > > starting random io!
> > > write time: 0.0006s fsync time: 0.3400s
> > > write time: 63.3270s fsync time: 0.3760s
> > > run done 2 fsyncs total, killing random writer
> > > 
> > > Second run
> > > ----------
> > > # ./a.out 
> > > starting fsync run
> > > starting random io!
> > > write time: 0.0006s fsync time: 0.5359s
> > > write time: 0.0007s fsync time: 0.3559s
> > > write time: 0.0009s fsync time: 0.3113s
> > > write time: 0.0008s fsync time: 0.4336s
> > > write time: 0.0009s fsync time: 0.3780s
> > > write time: 0.0008s fsync time: 0.3114s
> > > write time: 0.0009s fsync time: 0.3225s
> > > write time: 0.0009s fsync time: 0.3891s
> > > write time: 0.0009s fsync time: 0.4336s
> > > write time: 0.0009s fsync time: 0.4225s
> > > write time: 0.0009s fsync time: 0.4114s
> > > write time: 0.0007s fsync time: 0.4004s
> > > 
> > > Not sure why would that happen.
> > > 
> > > I am wondering why pwrite/fsync process was throttled. It did not have any
> > > pages in page cache and it shouldn't have hit the task dirty limits. Does that
> > > mean per task dirty limit logic does not work or I am completely missing
> > > the root cause of the problem.
> > 
> > I haven't traced it to see.  This test box only has 1GB of ram, so the
> > dirty ratios can be very tight.
> 
> Oh, I see now.  The test program first creates the file with a big
> streaming write.  So the task doing the streaming writes gets nailed
> with the per-task dirty accounting because it is making a ton of dirty
> data.
> 
> Then the task forks the random writer to do all the random IO.
> 
> Then the original pid goes back to do the fsyncs on the new file.
> 
> So, in the original run, we get stuffed into balance_dirty_pages because
> the per-task limits show we've done a lot of dirties.
> 
> In all later runs, the file already exists, so our fsyncing process
> hasn't done much dirtying at all.  Looks like the VM is doing something
> sane, we just get nailed with big random IO.

Ok, that makes sense. So initial file creation accounted lots of buffered
IO to this process hence VM thinks it has crossed it dirty limits and later
this task comes with 4K write and gets throttled.

Thanks
Vivek
