From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH] vfs: add missing check for __O_TMPFILE in fcntl_init()
 (Re: [PATCH] ext4: fix...)
Date: Mon, 29 Jul 2013 14:17:05 +0800
Message-ID: <20130729061705.GA17784@gmail.com>
References: <20130717161944.GA19405@redhat.com>
 <20130719121405.GA3856@gmail.com>
 <CAGW2f1GqTR8xtE_bEN3O+QrRy75h9EjHYkYVnn7-vaoRucaQzg@mail.gmail.com>
 <20130723095928.GA3278@gmail.com>
 <CAGW2f1GjYwVjw=b1O+_SmSW6CvCd9R1QP54TXFo7XoMguOqR=g@mail.gmail.com>
 <20130723233859.GA5435@gmail.com>
 <CAGW2f1HgtwdekeETXpZvm-KT6Sdw1bUas799yWjQ_jZp3kwaug@mail.gmail.com>
 <20130725001319.GA12994@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: jon ernst <jonernst07@gmail.com>, linux-ext4@vger.kernel.org,
	Al Viro <viro@zeniv.linux.org.uk>,
	linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130725001319.GA12994@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

[To linux-fsdevel mailing list]

On Thu, Jul 25, 2013 at 08:13:19AM +0800, Zheng Liu wrote:
[...]
> > Also, about this code:
> > 
> > /* a horrid kludge trying to make sure that this will fail on old kernels */
> > #define O_TMPFILE (__O_TMPFILE | O_DIRECTORY)
> > 
> > why not doing something like this:
> > 
> > #ifndef O_TMPFILE
> > /* a horrid kludge trying to make sure that this will fail on old kernels */
> > #define O_TMPFILE (__O_TMPFILE | O_DIRECTORY)
> > #endif
> 
> Sorry, I don't take a closer look at that thread.  I look at the code,
> and it seems that there is no any rule about adding '#ifndef XXX'.
> Meanwhile, I notice a comment:
> 
> /*
>  * When introducing new O_* bits, please check its uniqueness in fcntl_init().
>  */
> 
> But we are missing adding O_TMPFILE flag in fcntl_init().  So I attach a
> patch below.
> 
> Al, could you please answer this question?  Thanks.
> 
> Regards,
>                                                 - Zheng
> 
> Subject: [PATCH] vfs: add missing check for __O_TMPFILE in fcntl_init()
> 
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> As comment in include/uapi/asm-generic/fcntl.h described, when
> introducing new O_* bits, we need to check its uniqueness in
> fcntl_init().  But __O_TMPFILE bit is missing.  So fix it.
> 
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>

Any comment?

Thanks,
                                                - Zheng

> ---
> *This patch is against ext4/dev tree.*
> 
>  fs/fcntl.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/fcntl.c b/fs/fcntl.c
> index 6599222..65343c3 100644
> --- a/fs/fcntl.c
> +++ b/fs/fcntl.c
> @@ -730,14 +730,14 @@ static int __init fcntl_init(void)
>  	 * Exceptions: O_NONBLOCK is a two bit define on parisc; O_NDELAY
>  	 * is defined as O_NONBLOCK on some platforms and not on others.
>  	 */
> -	BUILD_BUG_ON(19 - 1 /* for O_RDONLY being 0 */ != HWEIGHT32(
> +	BUILD_BUG_ON(20 - 1 /* for O_RDONLY being 0 */ != HWEIGHT32(
>  		O_RDONLY	| O_WRONLY	| O_RDWR	|
>  		O_CREAT		| O_EXCL	| O_NOCTTY	|
>  		O_TRUNC		| O_APPEND	| /* O_NONBLOCK	| */
>  		__O_SYNC	| O_DSYNC	| FASYNC	|
>  		O_DIRECT	| O_LARGEFILE	| O_DIRECTORY	|
>  		O_NOFOLLOW	| O_NOATIME	| O_CLOEXEC	|
> -		__FMODE_EXEC	| O_PATH
> +		__FMODE_EXEC	| O_PATH	| __O_TMPFILE
>  		));
>  
>  	fasync_cache = kmem_cache_create("fasync_cache",
> -- 
> 1.7.9.7
> 
