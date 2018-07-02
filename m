From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Check superblock mapped prior to committing
Date: Mon, 2 Jul 2018 18:50:42 -0400
Message-ID: <20180702225042.GF30481@thunk.org>
References: <1530300995-25583-1-git-send-email-jonathan.derrick@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-kernel@vger.kernel.org
To: Jon Derrick <jonathan.derrick@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1530300995-25583-1-git-send-email-jonathan.derrick@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jun 29, 2018 at 01:36:35PM -0600, Jon Derrick wrote:
> This patch attempts to close a hole leading to a BUG seen with hot
> removals during writes [1].
> 
> A block device (NVME namespace in this test case) is formatted to EXT4
> without partitions. It's mounted and write I/O is run to a file, then
> the device is hot removed from the slot. The superblock attempts to be
> written to the drive which is no longer present.
> 
> The typical chain of events leading to the BUG:
> ext4_commit_super()
>   __sync_dirty_buffer()
>     submit_bh()
>       submit_bh_wbc()
>         BUG_ON(!buffer_mapped(bh));
> 
> This fix checks for the superblock's buffer head being mapped prior to
> syncing.
> 
> [1] https://www.spinics.net/lists/linux-ext4/msg56527.html
> 
> Signed-off-by: Jon Derrick <jonathan.derrick@intel.com>

Thanks, applied.

				- Ted
