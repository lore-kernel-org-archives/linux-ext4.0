From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: remove unneeded variable.
Date: Sun, 20 Nov 2011 01:41:26 +0530
Message-ID: <4EC80D6E.3090404@linux.vnet.ibm.com>
References: <1321023744-16249-1-git-send-email-linkinjeon@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	Amit Sahrawat <amit.sahrawat83@gmail.com>
To: Namjae Jeon <linkinjeon@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1321023744-16249-1-git-send-email-linkinjeon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 11/11/2011 08:32 PM, Namjae Jeon wrote:
> ret2 is not needed in ext4_flush_completed_IO().
> 

Not needed? I went through the code briefly, and I don't agree.

> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
> Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
> ---
>  fs/ext4/fsync.c |    5 +----
>  1 files changed, 1 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
> index 00a2cb7..40397ac 100644
> --- a/fs/ext4/fsync.c
> +++ b/fs/ext4/fsync.c
> @@ -81,7 +81,6 @@ int ext4_flush_completed_IO(struct inode *inode)
>  	struct ext4_inode_info *ei = EXT4_I(inode);
>  	unsigned long flags;
>  	int ret = 0;
> -	int ret2 = 0;
> 
>  	dump_completed_IO(inode);
>  	spin_lock_irqsave(&ei->i_completed_io_lock, flags);
> @@ -105,12 +104,10 @@ int ext4_flush_completed_IO(struct inode *inode)
>  		 */
>  		spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
>  		ret = ext4_end_io_nolock(io);
> -		if (ret < 0)
> -			ret2 = ret;
>  		spin_lock_irqsave(&ei->i_completed_io_lock, flags);
>  	}
>  	spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
> -	return (ret2 < 0) ? ret2 : 0;
> +	return (ret < 0) ? ret : 0;
>  }

Please note that there is a while loop involved here. Which means, that ret2
is used to store the last negative value of ret. And due to the loop, ret can
be over-written in the next loop iteration, which we can afford, because we
have already stored what we need to save, in ret2. And this ret2 value is used
to return appropriate value to the caller. 

Thanks,
Srivatsa S. Bhat
