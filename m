From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 7/8] Revert "ext4: avoid deadlocks in the writeback path
 by using sb_getblk_gfp"
Date: Mon, 6 Mar 2017 12:59:15 +0100
Message-ID: <20170306115915.GB27953@dhcp22.suse.cz>
References: <20170106141107.23953-1-mhocko@kernel.org>
 <20170106141107.23953-8-mhocko@kernel.org>
 <20170117030118.727jqyamjhojzajb@thunk.org>
 <20170117075450.GC19699@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Chinner <david@fromorbit.com>, djwong@kernel.org,
	Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.cz>,
	Jan Kara <jack@suse.cz>, ceph-devel@vger.kernel.org,
	cluster-devel@redhat.com, linux-nfs@vger.kernel.org,
	logfs@logfs.org, linux-xfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-mtd@lists.infradead.org, reiserfs-devel@vger.kernel.org,
	linux-ntfs-dev@lists.sourceforge.net,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-afs@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20170117075450.GC19699@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Tue 17-01-17 08:54:50, Michal Hocko wrote:
> On Mon 16-01-17 22:01:18, Theodore Ts'o wrote:
> > On Fri, Jan 06, 2017 at 03:11:06PM +0100, Michal Hocko wrote:
> > > From: Michal Hocko <mhocko@suse.com>
> > > 
> > > This reverts commit c45653c341f5c8a0ce19c8f0ad4678640849cb86 because
> > > sb_getblk_gfp is not really needed as
> > > sb_getblk
> > >   __getblk_gfp
> > >     __getblk_slow
> > >       grow_buffers
> > >         grow_dev_page
> > > 	  gfp_mask = mapping_gfp_constraint(inode->i_mapping, ~__GFP_FS) | gfp
> > > 
> > > so __GFP_FS is cleared unconditionally and therefore the above commit
> > > didn't have any real effect in fact.
> > > 
> > > This patch should not introduce any functional change. The main point
> > > of this change is to reduce explicit GFP_NOFS usage inside ext4 code to
> > > make the review of the remaining usage easier.
> > > 
> > > Signed-off-by: Michal Hocko <mhocko@suse.com>
> > > Reviewed-by: Jan Kara <jack@suse.cz>
> > 
> > If I'm not mistaken, this patch is not dependent on any of the other
> > patches in this series (and the other patches are not dependent on
> > this one).  Hence, I could take this patch via the ext4 tree, correct?
> 
> Yes, that is correct

Hi Ted,
this doesn't seem to be in any of the branches [1]. I plan to resend the
whole scope nofs series, should I add this to the pile or you are going
to route it via your tree?

[1] git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git
-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
