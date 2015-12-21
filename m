From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 06/11] reflink: more tests
Date: Mon, 21 Dec 2015 17:31:11 +1100
Message-ID: <20151221063111.GO19802@dastard>
References: <20151219091052.15320.94973.stgit@birch.djwong.org>
	<20151219091131.15320.12391.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, fstests@vger.kernel.org,
	linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <20151219091131.15320.12391.stgit@birch.djwong.org>
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

On Sat, Dec 19, 2015 at 01:11:31AM -0800, Darrick J. Wong wrote:
> Add more tests for unaligned copy-on-write things, and explicitly
> test the ability to pass "len == 0" to mean reflink/dedupe all
> the way to the end of the file".
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
.....
> +_cleanup()
> +{
> +    cd /
> +    rm -rf "$tmp".* "$TESTDIR"
> +}
.....
> +
> +TESTDIR="$TEST_DIR/test-$seq"
> +rm -rf "$TESTDIR"
> +mkdir "$TESTDIR"

This use of TESTDIR is highly confusing. When I see TESTDIR I think
that it's the mount point of the test device, not potentially some
directory on the scratch device.

I see that this occurs through lots of tests, not just these new
ones. Can you do a pass across the tests with, say, sed and rename
all these to something less confusing? e.g. "testdir", in lower
case, makes it clear that it's a local variable, not the global test
device mount point.... (i.e. test local variables are lower case,
exported test harnes variables are upper case ;)

Separate patch/pull req is fine.

Cheers,

dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
