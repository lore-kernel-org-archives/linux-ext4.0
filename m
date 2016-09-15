From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/6 linux-next] ext4: remove unneeded test in
 ext4_alloc_file_blocks()
Date: Thu, 15 Sep 2016 11:52:52 -0400
Message-ID: <20160915155252.5k453j76dgrveqgf@thunk.org>
References: <1472069000-18897-1-git-send-email-fabf@skynet.be>
 <1472069000-18897-3-git-send-email-fabf@skynet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Fabian Frederick <fabf@skynet.be>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1472069000-18897-3-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Aug 24, 2016 at 10:03:16PM +0200, Fabian Frederick wrote:
> ext4_alloc_file_blocks() is called from ext4_zero_range() and
> ext4_fallocate() both already testing EXT4_INODE_EXTENTS
> We can call ext_depth(inode) unconditionnally.
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Applied, although I also added a BUG_ON() check to make sure
ext4_alloc_file_blocks() won't get called with an indirect-mapped
inode in the future.

				- Ted
