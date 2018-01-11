From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] FS: EXT4: syn error in __ext4_grp_locked_error
Date: Thu, 11 Jan 2018 13:13:07 -0500
Message-ID: <20180111181307.GC19241@thunk.org>
References: <1513305136-27652-1-git-send-email-zhouzhouyi@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: zhouzhouyi@gmail.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1513305136-27652-1-git-send-email-zhouzhouyi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Dec 15, 2017 at 02:32:16AM +0000, zhouzhouyi@gmail.com wrote:
> From: Zhouyi Zhou <zhouzhouyi@gmail.com>
> 
> In function __ext4_grp_locked_error,   __save_error_info
> is called to save error info in super block block, but does not sync
> that information to disk to info the subsequence fsck after reboot.
> 
> This patch sync the error information to disk. After this patch,
> I think there is no obvious EXT4 error handle branche which leads to
> "Remounting filesystem read-only" will leave the disk partition miss
> the subsequence fsck.
> 
> Compiled in x86_64 Linux
> Signed-off-by: Zhouyi Zhou <zhouzhouyi@gmail.com>

Applied, thanks.

					- Ted
