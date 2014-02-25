From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/6] xfstests: fsstress punch should always have
	FALLOC_FL_KEEP_SIZE set
Date: Wed, 26 Feb 2014 07:18:54 +1100
Message-ID: <20140225201854.GA13647@dastard>
References: <1393355728-12056-1-git-send-email-lczerner@redhat.com>
	<1393355728-12056-3-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <1393355728-12056-3-git-send-email-lczerner@redhat.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
List-Id: linux-ext4.vger.kernel.org

On Tue, Feb 25, 2014 at 08:15:25PM +0100, Lukas Czerner wrote:
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  ltp/fsstress.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/ltp/fsstress.c b/ltp/fsstress.c
> index 4c3368f..42c8a5a 100644
> --- a/ltp/fsstress.c
> +++ b/ltp/fsstress.c
> @@ -2555,8 +2555,8 @@ punch_f(int opno, long r)
>  	off = (off64_t)(lr % MIN(stb.st_size + (1024 * 1024), MAXFSIZE));
>  	off %= maxfsize;
>  	len = (off64_t)(random() % (1024 * 1024));
> -	mode |= FALLOC_FL_KEEP_SIZE & random();
>  	e = fallocate(fd, mode, (loff_t)off, (loff_t)len) < 0 ? errno : 0;
> +	mode |= FALLOC_FL_KEEP_SIZE;
>  	if (v)
>  		printf("%d/%d: punch hole(%d) %s %s %lld %lld %d\n",
>  		       procid, opno, mode,

NACK. There's nothing wrong with testing a set of parameters that
should fail in a stress test.

Regardless, the patch is wrong...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
