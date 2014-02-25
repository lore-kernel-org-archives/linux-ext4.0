From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/6] ext4/242: Add ext4 specific test for fallocate zero
	range
Date: Wed, 26 Feb 2014 07:53:49 +1100
Message-ID: <20140225205349.GD13647@dastard>
References: <1393355728-12056-1-git-send-email-lczerner@redhat.com>
	<1393355728-12056-6-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <1393355728-12056-6-git-send-email-lczerner@redhat.com>
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

On Tue, Feb 25, 2014 at 08:15:28PM +0100, Lukas Czerner wrote:
> This is copy of xfs/242. However it's better to make it file system
> specific because the range can be zeroes either directly by writing
> zeroes, or converting to unwritten extent, so the actual result might
> differ from file system to file system.

You could say the same thing about preallocation using unwritten
extents. Yet, funnily enough, we have generic tests for them because
all filesystems currently use unwritten extents for preallocation
and behave identically....

This test is no different - all filesystems currently use unwritten
extents, and so this test should be generic because all existing
filesystems *should* behave the same.

When we get a filesystem that zeros rather uses unwritten extents,
we can add a new *generic* test that tests for zeroed data extents
rather than unwritten extents. All that we will need is a method of
checking what behaviour the filesystem has and adding that to a
_requires directive to ensure the correct generic fallocate tests
are run...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
