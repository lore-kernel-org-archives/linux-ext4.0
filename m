From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfstests 299-305: remove fio config files after
	finished test
Date: Wed, 27 Mar 2013 13:05:33 +1100
Message-ID: <20130327020532.GP6369@dastard>
References: <1364127266-13325-1-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>,
	Zheng Liu <wenqing.lz@taobao.com>, xfs@oss.sgi.com
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <1364127266-13325-1-git-send-email-wenqing.lz@taobao.com>
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

On Sun, Mar 24, 2013 at 08:14:26PM +0800, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> After finished test, temporarily fio config file should be removed.
> Meanwhile in #305 poweron_scratch_dev is removed because no one uses
> it.
> 
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> Cc: Eric Sandeen <sandeen@sandeen.net>
> Cc: Dave Chinner <david@fromorbit.com>
> ---
>  299 |  9 +++++----
>  300 |  9 +++++----
>  301 |  9 +++++----
>  302 |  9 +++++----
>  303 |  9 +++++----
>  304 |  9 +++++----
>  305 | 11 ++++++-----
>  7 files changed, 36 insertions(+), 29 deletions(-)
>  mode change 100644 => 100755 299
>  mode change 100644 => 100755 300
>  mode change 100644 => 100755 301
>  mode change 100644 => 100755 302
>  mode change 100644 => 100755 303
>  mode change 100644 => 100755 304
>  mode change 100644 => 100755 305

Mode changes should be in a separate patch. And if you are going to
do this, please change all the tests that need this to be done in
one sweep.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
