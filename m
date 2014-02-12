From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v3] ext4: initialize multi-block allocator before
 checking block descriptors
Date: Wed, 12 Feb 2014 11:29:04 -0500
Message-ID: <20140212162904.GD14520@thunk.org>
References: <1392128652-6882-1-git-send-email-a3at.mail@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	open list <linux-kernel@vger.kernel.org>
To: Azat Khuzhin <a3at.mail@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1392128652-6882-1-git-send-email-a3at.mail@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Feb 11, 2014 at 06:24:12PM +0400, Azat Khuzhin wrote:
> With EXT4FS_DEBUG ext4_count_free_clusters() will call
> ext4_read_block_bitmap() without s_group_info initialized, so we need to
> initialize multi-block allocator before.
> 
> And we can't initialize multi-block allocator without group descriptors,
> since it use them.
> Also we need to install s_op before initializing multi-block allocator,
> because in ext4_mb_init_backend() new inode is created.

Applied, thanks.

					- Ted
