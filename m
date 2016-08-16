From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] mm, oom: report compaction/migration stats for higher
 order requests
Date: Tue, 16 Aug 2016 16:10:10 +0200
Message-ID: <20160816141007.GF17417@dhcp22.suse.cz>
References: <201608120901.41463.a.miskiewicz@gmail.com>
 <20160814125327.GF9248@dhcp22.suse.cz>
 <20160815085129.GA3360@dhcp22.suse.cz>
 <201608161318.25412.a.miskiewicz@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-mm@kvack.org
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

David was right when assuming it would be the ext4 inode cache which
consumes the large portion of the memory. /proc/slabinfo shows
ext4_inode_cache consuming between 2.5 to 4.6G of memory.

			first value	last-first
pgmigrate_success       1861785 	2157917
pgmigrate_fail  	335344  	1400384
compact_isolated        4106390 	5777027
compact_migrate_scanned 113962774       446290647
compact_daemon_wake     17039   	43981
compact_fail    	645     	1039
compact_free_scanned    381701557       793430119
compact_success 	217     	307
compact_stall   	862     	1346

which means that we have invoked compaction 1346 times and failed in
77% of cases. It is interesting to see that the migration wasn't all
that unsuccessful. We managed to migrate 1.5x more pages than failed. It
smells like the compaction just backs off. Could you try to test with
patch from http://lkml.kernel.org/r/20160816031222.GC16913@js1304-P5Q-DELUXE
please? Ideally on top of linux-next. You can add both the compaction
counters patch in the oom report and high order atomic reserves patch on
top.

Thanks
-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
