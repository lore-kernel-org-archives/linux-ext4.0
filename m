From: Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH] mm, vmscan: Do not wait for page writeback for GFP_NOFS
 allocations
Date: Wed, 12 Aug 2015 19:13:08 -0700 (PDT)
Message-ID: <alpine.LSU.2.11.1508121833220.3648@eggly.anvils>
References: <1435677437-16717-1-git-send-email-mhocko@suse.cz> <20150701061731.GB6286@dhcp22.suse.cz> <20150701133715.GA6287@dhcp22.suse.cz> <20150702142551.GB9456@thunk.org> <20150702151321.GE12547@dhcp22.suse.cz> <alpine.LSU.2.11.1508032227050.5070@eggly.anvils>
 <55C463B4.2050904@kyup.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.cz>,
    Linus Torvalds <torvalds@linux-foundation.org>,
    Theodore Ts'o <tytso@mit.edu>, Johannes Weiner <hannes@cmpxchg.org>,
    Andrew Morton <akpm@linux-foundation.org>,
    Dave Chinner <david@fromorbit.com>, Marian Marinov <mm@1h.com>,
    linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
    linux-ext4@vger.kernel.org
To: Nikolay Borisov <kernel@kyup.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <55C463B4.2050904@kyup.com>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 7 Aug 2015, Nikolay Borisov wrote:
> On 08/04/2015 09:32 AM, Hugh Dickins wrote:
> > 
> > And I've done quite a bit of testing.  The loads that hung at the
> > weekend have been running nicely for 24 hours now, no problem with the
> > writeback hang and no problem with the dcache ENOTDIR issue.  Though
> > I've no idea of what recent VM change turned this into a hot issue.
> > 
> 
> Are these production loads you are referring to that have been able to
> reproduce the issue or are they some synthetic ones which? So far I
> haven't been able to reproduce the issue using artifical loads so I'm
> interested in incorporating this into my test set setup if it's available?

Not production loads, no, just an artificial load.  But not very good
at reproducing the hang: variable, but took hours, and only showed up
on one faster machine; I had to run the load for 2 days, then again 2
days, to feel confident that this hang was fixed.

And I'm sorry, but describing it in full detail is not something I find
time to do, in days or in years - partly because once I try to detail it,
I need to simplify this and streamline that, and it turns into something
else.  As happened when I sent it, offlist, to someone in 2009: I looked
back at that with a view to forwarding to you, but a lot of the details
don't match what I reverted to or advanced to doing since.

Broadly, it's a pair of repeated make -j20 kernel builds, one in tmpfs,
one in ext4 over loop over tmpfs, in limited memory 700M with 1.5G swap.
And to test this particular hang, it needed to use memcg (of what's now
branded an "insane" variety, CONFIG_CGROUP_WRITEBACK=n): I was using 1G
not 700M ram for this, but 300M memcg limit and 250M soft limit on each
memcg that was hosting one of the pair of repeated builds.  It can be
difficult to tune the right balance, swapping heavily but not OOMing:
it's a 2.6.24 tree I've gone back to building, because that's so much
smaller than current, with a greater proportion active in the build.

Hugh

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
