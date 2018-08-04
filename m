From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] ext4/mballoc: Remove unneeded variable "err"
Date: Sat, 4 Aug 2018 17:24:26 -0400
Message-ID: <20180804212426.GE4461@thunk.org>
References: <1533380696-16325-1-git-send-email-zhongjiang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: zhong jiang <zhongjiang@huawei.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1533380696-16325-1-git-send-email-zhongjiang@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Aug 04, 2018 at 07:04:56PM +0800, zhong jiang wrote:
> The err is not used after initalization. So just remove the variable.
> 
> Signed-off-by: zhong jiang <zhongjiang@huawei.com>

I'll apply this patch, but how did you generate the diff?  The
function name here is all wrong:

> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 8b24d3d..e29fce2 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -3801,7 +3801,6 @@ static int ext4_mb_new_preallocation(struct ext4_allocation_context *ac)
                                   ^^^^^^^^^^^^^^^^^^^^^^^^^

The lines in question are from ext4_mb_release_inode_pa(), *not*
ext4_mb_new_preallocation().  So when I inspected the patch visually,
my first reaction was, "there's no way this patch would apply".

But then I looked at the C code changed by the patch, and I was
surprised to see that it applied correctly in a completely different
function, and when I regenerated the patch, the line numbers matched
yours --- so the only thing "wrong" in your patch is the function name.

So that raises the question --- how did you create the diff in this
patch?  What version of git?  And what version of the kernel?

Regards,

					- Ted
