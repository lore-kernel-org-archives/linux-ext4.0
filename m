From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 1/3] 285: Fix test for ext4 in some configurations
Date: Thu, 30 May 2013 08:45:33 -0500
Message-ID: <51A757FD.1040104@redhat.com>
References: <1369917939-22660-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, xfs@oss.sgi.com
To: Jan Kara <jack@suse.cz>
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <1369917939-22660-1-git-send-email-jack@suse.cz>
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

On 5/30/13 7:45 AM, Jan Kara wrote:
> In some configurations (e.g. 1 KB block size), ext4 can decide it is
> better to zero out several blocks rather than splitting unwritten
> extent. This changes results SEEK_HOLE / SEEK_DATA returns and thus the
> test fails. Fix the problem by disabling the feature for this test.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  tests/generic/285 | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/tests/generic/285 b/tests/generic/285
> index b700a15..8078b1c 100755
> --- a/tests/generic/285
> +++ b/tests/generic/285
> @@ -46,6 +46,12 @@ BASE_TEST_FILE=$TEST_DIR/seek_sanity_testfile
>  
>  [ -x $here/src/seek_sanity_test ] || _notrun "seek_sanitfy_tester not built"
>  
> +# Disable extent zeroing for ext4 as that change where holes are created
> +if [ "$FSTYP" = "ext4" ]; then
> +	DEV=`basename $TEST_DEV`
> +	echo 0 >/sys/fs/ext4/$DEV/extent_max_zeroout_kb
> +fi
> +
>  _cleanup()
>  {
>  	eval "rm -f $BASE_TEST_FILE.*"
> 

When the test dev is unmounted & remounted this will be reset, right?  So:

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
