From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 2/2] Ext3: return ENOMEM rather than EIO if sb_getblk
 fails
Date: Sat, 12 Jan 2013 20:43:42 -0800
Message-ID: <20130113044342.GA11738@kroah.com>
References: <1294915634-3413-1-git-send-email-wangshilong1991@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.cz, linux-fsdevel@vger.kernel.org, tytso@mit.edu,
	linux-ext4@vger.kernel.org,
	Wang Shilong <wangsl-fnst@cn.fujitsu.com>
To: Wang shilong <wangshilong1991@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1294915634-3413-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jan 13, 2011 at 06:47:14PM +0800, Wang shilong wrote:
> From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> 
> It will be better to have ENOMEM return rather than EIO,because
> the only reason that sb_getblk fails is allocation fails.
> 
> Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> ---
> fs/ext3/inode.c  | 6 +++---
> fs/ext3/resize.c | 6 +++---
> fs/ext3/xattr.c  | 2 +-
> 3 files changed, 7 insertions(+), 7 deletions(-)


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
