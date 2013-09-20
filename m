From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext4: fix memory leak in xattr code.
Date: Fri, 20 Sep 2013 10:29:59 -0500
Message-ID: <523C69F7.4030903@redhat.com>
References: <20130920142918.GA21988@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Dave Jones <davej@redhat.com>, tytso@mit.edu,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130920142918.GA21988@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 9/20/13 9:29 AM, Dave Jones wrote:
> If we take the 2nd retry path in ext4_expand_extra_isize_ea, we potentionally
> return from the function without having freed these allocations.
> If we don't do the return, we over-write the previous allocation pointers, 
> so we leak either way.
> 
> Spotted with Coverity.
> 
> Signed-off-by: Dave Jones <davej@fedoraproject.org>

Looks right to me.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Thanks!

-Eric

> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index c081e34..f3a6220 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -1350,6 +1350,8 @@ retry:
>  				    s_min_extra_isize) {
>  					tried_min_extra_isize++;
>  					new_extra_isize = s_min_extra_isize;
> +					kfree(is);
> +					kfree(bs);
>  					goto retry;
>  				}
>  				error = -1;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
