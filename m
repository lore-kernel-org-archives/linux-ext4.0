From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 1/6] lockdep: allow to disable reclaim lockup detection
Date: Mon, 6 Feb 2017 07:24:00 -0800
Message-ID: <20170206152400.GK2267@bombadil.infradead.org>
References: <20170206140718.16222-1-mhocko@kernel.org>
 <20170206140718.16222-2-mhocko@kernel.org>
 <20170206142641.GG2267@bombadil.infradead.org>
 <20170206143449.GD10298@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	Dave Chinner <david@fromorbit.com>, djwong@kernel.org,
	Theodore Ts'o <tytso@mit.edu>, Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.cz>, Jan Kara <jack@suse.cz>,
	ceph-devel@vger.kernel.org, cluster-devel@redhat.com,
	linux-nfs@vger.kernel.org, logfs@logfs.org,
	linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-mtd@lists.infradead.org,
	reiserfs-devel@vger.kernel.org,
	linux-ntfs-dev@lists.sourceforge.net,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-afs@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>
To: Michal Hocko <mhocko@kernel.org>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20170206143449.GD10298@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Feb 06, 2017 at 03:34:50PM +0100, Michal Hocko wrote:
> This part is not needed for the patch, strictly speaking but I wanted to
> make the code more future proof.

Understood.  I took an extra bit myself for marking the radix tree as
being used for an IDR (so the radix tree now uses 4 bits).  I see you
already split out the address space GFP mask from the other flags :-)
I would prefer not to do that with the radix tree, but I understand
your desire for more GFP bits.  I'm not entirely sure that an implicit
gfpmask makes a lot of sense for the radix tree, but it'd be a big effort
to change all the callers.  Anyway, I'm going to update your line here
for my current tree and add the build bug so we'll know if we ever hit
any problems.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
