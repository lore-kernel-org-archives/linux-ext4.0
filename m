From: Jan Kara <jack@suse.cz>
Subject: Re: [v4.14-rc1 regression] ext4 failed fstests generic/233 quota test
Date: Tue, 10 Oct 2017 14:49:51 +0200
Message-ID: <20171010124951.GE3667@quack2.suse.cz>
References: <20171008054236.GA10593@eguan.usersys.redhat.com>
 <20171010114323.GD3667@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Jan Kara <jack@suse.cz>, Eric Whitney <enwlinux@gmail.com>
To: Eryu Guan <eguan@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171010114323.GD3667@quack2.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue 10-10-17 13:43:23, Jan Kara wrote:
> Hi Eryu,
> 
> On Sun 08-10-17 13:42:36, Eryu Guan wrote:
> > After generic/232 failure has been reported and resolved[1], I still
> > could see fstests generic/233 failure on ext4 with v4.14-rc3 kernel.
> > This is not 100% reproduced (block usage needs to exceed soft limit) but
> > reliably.
> > 
> >  seed = S
> >  Comparing user usage
> > -Comparing group usage
> > +4c4
> > +< #1001     +-   32064   32000   32000            998  1000  1000       
> > +---
> > +> #1001     +-   32064   32000   32000  7days     998  1000  1000
> > 
> > Grace time was not printed by repquota right after the fsstress run when
> > we exceeded the block soft limit, and only printed after a quotacheck
> > was run.  With v4.13 kernel, block grace time could be printed
> > immediately after the fsstress run.
> 
> Well, I'd rather interpret the results as "the grace time didn't get set by
> the failing kernel, only quotacheck would set it". This configuration with
> softlimit == hardlimit is a bit ambiguous (as effectively softlimit and
> grace time are unused) and I might have shortcut setting of grace time in
> this case somewhere (which would be harmless). But still it warrants closer
> investigation. I'll have a look.
> 
> > git bisect pointed the first bad to commit 7b9ca4c61bc2 ("quota: Reduce
> > contention on dq_data_lock"). And I've confirmed the bisection result by
> > converting the commit in question and running generic/233 for 20
> > iterations without a failure.
> 
> Thanks for digging into this!

OK, I've reproduced the issue (although it took me several xfstests run to
hit this) and it is a real bug in handling of DQUOT_ALLOC_NOFAIL quota
allocations. I'll send a fix shortly once testing completes.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
