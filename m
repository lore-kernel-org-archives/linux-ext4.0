From: Dave Chinner <david@fromorbit.com>
Subject: Re: Test 272 fails for ext3
Date: Fri, 17 Aug 2012 08:48:58 +1000
Message-ID: <20120816224858.GY2877@dastard>
References: <20120816092808.GA9057@quack.suse.cz>
	<20120816093757.GA11519@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, dmonakhov@openvz.org, xfs@oss.sgi.com
To: Jan Kara <jack@suse.cz>
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <20120816093757.GA11519@quack.suse.cz>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
List-Id: linux-ext4.vger.kernel.org

On Thu, Aug 16, 2012 at 11:37:57AM +0200, Jan Kara wrote:
>   Hello,
> 
>   I was looking into why test 272 from xfstests fails for ext3 and the
> reason is that ext3 does not support direct IO to file with enabled data
> journalling (open returns EINVAL because ->direct_IO callback is not
> specified). So I was thinking how to accomodate this fact in the test -
> the best I found was to just check using xfs_io whether O_DIRECT open
> succeeds and perform the test only in that case. Attached patch does this
> or do people have other ideas?


# ext3 doesn't support direct IO in journalling mode
ext3_write_opt_list="iflag=noatime conv=notrunc conv=fsync"
ext4_write_opt_list="iflag=noatime conv=notrunc conv=fsync oflag=direct"

if [ $FSTYP = "ext3" ]; then
	write_opt_list="$ext3_write_opt_list"
else
	write_opt_list="$ext4_write_opt_list"
fi

.....
> diff --git a/272 b/272
> index 26dfa3b..e39c52b 100755
> --- a/272
> +++ b/272
> @@ -52,6 +52,12 @@ _workout()
>  		    
>  			echo "OP write_opt: $write_opt 4M, \
>  chattr_opt: $chattr_opt"
> +			if [ "$write_opt" = "oflag=direct" ]; then
> +				# Some filesystems don't support direct IO
> +				# in some cases, check for that
> +				xfs_io -F -d -f -c "" $SCRATCH_MNT/file.$idx \
> +					>> $seq.full 2>&1 || continue
> +			fi

That only fixes one of the two places that does direct IO on a
jounralled file. The above will fix both...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
