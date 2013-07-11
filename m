From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/4] ext4: ignore valid errors from defragmentation tests
Date: Thu, 11 Jul 2013 11:11:05 +1000
Message-ID: <20130711011105.GV3438@dastard>
References: <1373367918-7516-1-git-send-email-dmonakhov@openvz.org>
	<1373367918-7516-3-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	dchinner@redhat.com, xfs@oss.sgi.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <1373367918-7516-3-git-send-email-dmonakhov@openvz.org>
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

On Tue, Jul 09, 2013 at 03:05:17PM +0400, Dmitry Monakhov wrote:
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  tests/ext4/301 |    3 +++
>  tests/ext4/302 |    3 +++
>  tests/ext4/303 |    6 ++++++
>  tests/ext4/304 |    3 +++
>  4 files changed, 15 insertions(+), 0 deletions(-)
> 
> diff --git a/tests/ext4/301 b/tests/ext4/301
> index 0ca3622..30e4273 100755
> --- a/tests/ext4/301
> +++ b/tests/ext4/301
> @@ -74,6 +74,9 @@ donorname=test1.def
>  filename=test1
>  inplace=0
>  rw=write
> +continue_on_error=write
> +ignore_error=,ENOSPC:EBUSY
> +error_dump=0
>  numjobs=${NUM_JOBS}
>  runtime=30*${TIME_FACTOR}
>  time_based

Seems harmless enough to me.

Acked-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
