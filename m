From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 8/8] Revert "ext4: fix wrong gfp type under transaction"
Date: Tue, 17 Jan 2017 16:18:17 +0100
Message-ID: <20170117151817.GR19699@dhcp22.suse.cz>
References: <20170106141107.23953-1-mhocko@kernel.org>
 <20170106141107.23953-9-mhocko@kernel.org>
 <20170117025607.frrcdbduthhutrzj@thunk.org>
 <20170117082425.GD19699@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
        Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, djwong-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org,
        Chris Mason <clm-b10kYP2dOMg@public.gmane.org>, David Sterba <dsterba-AlSwsSmVLrQ@public.gmane.org>,
        ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
        linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, logfs-PCqxUs/MD9bYtjvyW6yDsg@public.gmane.org,
        linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
        reiserfs-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-ntfs-dev-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,
        linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,
        linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170117082425.GD19699-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Tue 17-01-17 09:24:25, Michal Hocko wrote:
> On Mon 16-01-17 21:56:07, Theodore Ts'o wrote:
> > On Fri, Jan 06, 2017 at 03:11:07PM +0100, Michal Hocko wrote:
> > > From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
> > > 
> > > This reverts commit 216553c4b7f3e3e2beb4981cddca9b2027523928. Now that
> > > the transaction context uses memalloc_nofs_save and all allocations
> > > within the this context inherit GFP_NOFS automatically, there is no
> > > reason to mark specific allocations explicitly.
> > > 
> > > This patch should not introduce any functional change. The main point
> > > of this change is to reduce explicit GFP_NOFS usage inside ext4 code
> > > to make the review of the remaining usage easier.
> > > 
> > > Signed-off-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
> > > Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
> > 
> > Changes in the jbd2 layer aren't going to guarantee that
> > memalloc_nofs_save() will be executed if we are running ext4 without a
> > journal (aka in no journal mode).  And this is a *very* common
> > configuration; it's how ext4 is used inside Google in our production
> > servers.
> 
> OK, I wasn't aware of that.
> 
> > So that means the earlier patches will probably need to be changed so
> > the nOFS scope is done in the ext4_journal_{start,stop} functions in
> > fs/ext4/ext4_jbd2.c.
> 
> I could definitely appreciated some help here. The call paths are rather
> complex and I am not familiar with the code enough. On of the biggest
> problem I have currently is that there doesn't seem to be an easy place
> to store the old allocation context. 

OK, so I've been staring into the code and AFAIU current->journal_info
can contain my stored information. I could either hijack part of the
word as the ref counting is only consuming low 12b. But that looks too
ugly to live. Or I can allocate some placeholder.

But before going to play with that I am really wondering whether we need
all this with no journal at all. AFAIU what Jack told me it is the
journal lock(s) which is the biggest problem from the reclaim recursion
point of view. What would cause a deadlock in no journal mode?

-- 
Michal Hocko
SUSE Labs
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
