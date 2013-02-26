From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: use native definition of O_DIRECT flag
Date: Wed, 27 Feb 2013 09:57:18 +1100
Message-ID: <20130226225718.GW5551@dastard>
References: <20130226210322.GB5275@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, xfs@oss.sgi.com
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <20130226210322.GB5275@wallace>
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

On Tue, Feb 26, 2013 at 04:03:22PM -0500, Eric Whitney wrote:
> The definition of O_DIRECT in src/trunc.c causes xfstest 125 to fail
> when run on a Pandaboard.  On ARM, the value used (0x040000) is
> O_DIRECTORY rather than O_DIRECT as it is on x86.  Prefer the platform's
> native definition of O_DIRECT supplied by fcntl.h if available.  Also,
> fix a couple of error messages to properly reflect their context.
> 
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
