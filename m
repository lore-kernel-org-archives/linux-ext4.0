From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] mm, oom: report compaction/migration stats for higher
 order requests
Date: Wed, 17 Aug 2016 12:57:11 +0200
Message-ID: <20160817105711.GA6656@quack2.suse.cz>
References: <201608120901.41463.a.miskiewicz@gmail.com>
 <20160814125327.GF9248@dhcp22.suse.cz>
 <20160815085129.GA3360@dhcp22.suse.cz>
 <201608161318.25412.a.miskiewicz@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Michal Hocko <mhocko@kernel.org>, linux-ext4@vger.kernel.org,
	linux-mm@kvack.org
To: arekm@maven.pl
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <201608161318.25412.a.miskiewicz@gmail.com>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Tue 16-08-16 13:18:25, Arkadiusz Miskiewicz wrote:
> On Monday 15 of August 2016, Michal Hocko wrote:
> > [Fixing up linux-mm]
> > 
> > Ups I had a c&p error in the previous patch. Here is an updated patch.
> 
> 
> Going to apply this patch now and report again. I mean time what I have is a 
> 
>  while (true); do echo "XX date"; date; echo "XX SLAB"; cat /proc/slabinfo ; 
> echo "XX VMSTAT"; cat /proc/vmstat ; echo "XX free"; free; echo "XX DMESG"; 
> dmesg -T | tail -n 50; /bin/sleep 60;done 2>&1 | tee log
> 
> loop gathering some data while few OOM conditions happened.
> 
> I was doing "rm -rf copyX; cp -al original copyX" 10x in parallel.
> 
> https://ixion.pld-linux.org/~arekm/p2/ext4/log-20160816.txt

Just one more debug idea to add on top of what Michal said: Can you enable
mm_shrink_slab_start and mm_shrink_slab_end tracepoints (via
/sys/kernel/debug/tracing/events/vmscan/mm_shrink_slab_{start,end}/enable)
and gather output from /sys/kernel/debug/tracing/trace_pipe while the copy
is running?

Because your slab caches seem to contain a lot of dentries as well (even
more than inodes in terms of numbers) so it may be that OOM is declared too
early before slab shrinkers can actually catch up...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
