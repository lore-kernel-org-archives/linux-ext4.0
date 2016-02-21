From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] xfstests-bld: add exclude file for ext3 tests
Date: Sun, 21 Feb 2016 00:45:30 -0500
Message-ID: <20160221054530.GB15641@thunk.org>
References: <20160220155157.GA19420@localhost.localdomain>
 <20160221003411.GZ14668@dastard>
 <20160221025754.GA15641@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Whitney <enwlinux@gmail.com>, linux-ext4@vger.kernel.org,
	fstests@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160221025754.GA15641@thunk.org>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Feb 20, 2016 at 09:57:54PM -0500, Theodore Ts'o wrote:
> 
> So probably the right answer here is to change _require_defrag so that
> for EXT4, to also add the assertion:
> 
> _require_xfs_io_command "falloc"

So like this...  (BTW what's up with my other pending xfstests
patches?  Would you like me to resend a whole back with the
reviewed-by lines merged in?)

						- Ted

>From a1cd89ca74d8e8cd345b88e62a5eabab70aed62e Mon Sep 17 00:00:00 2001
From: Theodore Ts'o <tytso@mit.edu>
Date: Sun, 21 Feb 2016 00:12:00 -0500
Subject: [PATCH] defrag: require falloc support for ext4 defrag

The e4defrag program requires the use of fallocate.  Certain ext4 file
system configurations which don't enable extents do not support
fallocate, so we should skip the defrag tests in that case.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 common/defrag | 1 +
 1 file changed, 1 insertion(+)

diff --git a/common/defrag b/common/defrag
index 942593e..f3d9e43 100644
--- a/common/defrag
+++ b/common/defrag
@@ -28,6 +28,7 @@ _require_defrag()
 	;;
     ext4|ext4dev)
         DEFRAG_PROG="$E4DEFRAG_PROG"
+	_require_xfs_io_command "falloc"
 	;;
     btrfs)
 	DEFRAG_PROG="$BTRFS_UTIL_PROG filesystem defragment"
-- 
2.5.0
