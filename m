From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfstests: master branch updated to 8874560
Date: Mon, 14 Apr 2014 11:22:25 +1000
Message-ID: <20140414012225.GF27694@dastard>
References: <20140414004938.GE27694@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org
To: xfs@oss.sgi.com
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <20140414004938.GE27694@dastard>
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

On Mon, Apr 14, 2014 at 10:49:38AM +1000, Dave Chinner wrote:
> Hi folks,
> 
> The xfstests repository at git://oss.sgi.com/xfs/cmds/xfstests has
> just been updated. Patches often get missed, so please check if your
> outstanding patches were in this update. If they have not been in
> this update, please resubmit them to xfs@oss.sgi.com so they can be
> picked up in the next update.
> 
> This update includes tests for the new renameat2 syscall, and a
> bunch of fixes for the new config file format infrastructure.

Actaully, it's now updated to:

8874560 generic/024: fix output number

because it missed a test number update in an output file again. That
test doesn't run yet on XFS, so I missed it until I ran some ext4
tests...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
