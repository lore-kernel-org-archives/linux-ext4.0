From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix warning message to output correct type.
Date: Sun, 22 Jul 2018 18:23:56 -0400
Message-ID: <20180722222356.GD3358@thunk.org>
References: <20180713091547.231108-1-uekawa@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Junichi Uekawa <uekawa@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180713091547.231108-1-uekawa@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jul 13, 2018 at 06:15:47PM +0900, Junichi Uekawa wrote:
> Output the warning message before we clobber type and be -1 all the time.
> The error message would now be
> 
> [    1.519791] EXT4-fs warning (device vdb): ext4_enable_quotas:5402:
> Failed to enable quota tracking (type=0, err=-3). Please run e2fsck to fix.
> 
> Signed-off-by: Junichi Uekawa <uekawa@google.com>

Thanks, applied.

					- Ted
