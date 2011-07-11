From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/2] always default to issue cache flushes
Date: Mon, 11 Jul 2011 21:19:16 +0200
Message-ID: <20110711191916.GH5482@quack.suse.cz>
References: <20110711182532.GA12099@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: viro@zeniv.linux.org.uk, jeffm@suse.com, chris.mason@oracle.com,
	jack@suse.cz, reiserfs-devel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <reiserfs-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110711182532.GA12099@infradead.org>
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon 11-07-11 14:25:33, Christoph Hellwig wrote:
> It's bad enough that we still have filesystems who can't deal with
> the volatile write caches present on all modern consumer disks, but
> let's at least make use of this feature where present instead of
> playing fast and lose with users data.  Switch ext3 and reiserfs
> to the same default already applied in btrfs, ext4, gfs2, hfsplus,
> nilfs2 and XFS.
  Maybe it's worth noting that both RH and SUSE distributions actually have
barriers switched on by default for years so this change isn't going to
affect most enterprise users.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
