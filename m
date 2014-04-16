From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH -v2] check: add support for an external file containing
	tests to exclude
Date: Wed, 16 Apr 2014 16:40:18 +1000
Message-ID: <20140416064018.GJ15995@dastard>
References: <20140416001530.GU15995@dastard>
	<1397624302-9577-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <1397624302-9577-1-git-send-email-tytso@mit.edu>
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

On Wed, Apr 16, 2014 at 12:58:22AM -0400, Theodore Ts'o wrote:
> Currently the -X option is intended to specify a set of expunging
> files which are stored in each test/* subdirectory.  As described in
> the commit description for 0b1e8abd4, in order to exclude the test
> generic/280, the -X option is used as follows:
> 
>     $ cat tests/generic/3.0-stable-avoid
>     280
>     $ sudo ./check -X 3.0-stable-avoid generic/280
> 
> However, it is sometimes useful to store the set of expunged tests in
> a single file, outside of tests/* subdirectories.  This commit enables
> the following:
> 
>     $ cat /root/conf/data_journal.exclude
>     generic/068
>     ext4/301
>     $ sudo ./check -E /root/conf/data_journal.exclude -g auto
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  check | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/check b/check
> index e7ace63..b1eaed2 100755
> --- a/check
> +++ b/check
> @@ -81,6 +81,7 @@ testlist options
>      -g group[,group...]	include tests from these groups
>      -x group[,group...]	exclude tests from these groups
>      -X file		exclude individual tests
> +    -E external_file	exclude individual tests
>      [testlist]		include tests matching names in testlist
>  '
>  	    exit 0
> @@ -222,6 +223,11 @@ while [ $# -gt 0 ]; do
>  			done
>  		done
>  		;;
> +	-E)	xfile=$2; shift ;
> +		if [ -f $xfile ]; then
> +			cat "$xfile" >> $tmp.xlist
> +	        fi
> +		;;
>  	-s)	RUN_SECTION="$RUN_SECTION $2"; shift ;;
>  	-l)	diff="diff" ;;
>  	-udiff)	diff="$diff -u" ;;

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
