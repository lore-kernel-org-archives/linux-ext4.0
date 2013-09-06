From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH][RESEND]  xfstests: only run generic/300 on filesystems
	supporting
Date: Fri, 06 Sep 2013 14:51:48 -0500
Message-ID: <522A3254.3090704@redhat.com>
References: <20130906194243.GA19286@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, xfs@oss.sgi.com
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <20130906194243.GA19286@wallace>
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

On 9/6/13 2:42 PM, Eric Whitney wrote:
> Generic/300 fails when run on a test filesystem that does not support
> fallocate(), as in the case of an ext4 filesystem created without the
> extent feature.  It uses fio's falloc ioengine to generate part of its
> I/O load.
> 
> Verify that the test filesystem supports fallocate() before proceeding
> with the test.  Also, delete any pre-existing test output to avoid
> confusion with old results.

Hey Eric - sorry this got missed for review.

Since the test doesn't actually use xfs_io it seems like slightly the
wrong check, maybe we need a new _require_fio_falloc()?

But xfs_io will almost always be installed for someone running
xfstests, and the check as you have it will indeed test that the fs
can do fallocate; it's just not the most targeted test.

It's probably ok, though - a comment about why you _require_xfs_io
when xfs_io isn't used might be good.

What do you think?

-Eric

> Signed-off-by: Eric Whitney <enwlinux@gmail.com>
> ---
>  tests/generic/300 |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/tests/generic/300 b/tests/generic/300
> index 7c60728..1ac763b 100755
> --- a/tests/generic/300
> +++ b/tests/generic/300
> @@ -43,6 +43,9 @@ _supported_fs generic
>  _supported_os Linux
>  _need_to_be_root
>  _require_scratch
> +_require_xfs_io_falloc
> +
> +rm -f $seqres.full
>  
>  NUM_JOBS=$((4*LOAD_FACTOR))
>  BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
