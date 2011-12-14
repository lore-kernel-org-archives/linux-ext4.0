From: Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>
Subject: Re: [PATCH] update 068 to reproduce an unfreeze hanging up problem
Date: Wed, 14 Dec 2011 11:22:10 +0900
Message-ID: <20111214112209.1002.61FB500B@jp.fujitsu.com>
References: <20111213094245.4004.61FB500B@jp.fujitsu.com> <20111213063212.GC14273@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55830 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457Ab1LNCWT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Dec 2011 21:22:19 -0500
In-Reply-To: <20111213063212.GC14273@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


(2011/12/13 15:32), Dave Chinner wrote:

> On Tue, Dec 13, 2011 at 09:42:46AM +0900, Masayoshi MIZUMA wrote:
> > update 068 to reproduce an unfreeze hanging up problem which is unfreeze
> > function, thaw_super(), sometimes hangs up if flush kernel thread does
> > writeback to the same filesystem concurrently.
> 
> That's not exactly what I asked to be done when I reviewed the
> original patch -  I asked you to "make 068 generic" because it
> already exercises freeze/thaw under a stressful workload. What I
> expected was a change to "supported_fs" and the scratch mkfs
> command so it will run on all filesystems.
> 
> test 068 will catch problems like the one your specific test
> catches, but maybe not every time. Test 068 will catch problems your
> test case won't, though - it's a trade-off between having lots of
> tests that are similar but slightly different (difficult to
> maintain, increases runtime, etc), and having one test that
> exercises the functionality in a simple manner likely to detect
> problems.

Thank you for your explanation about the policy and I understand it.

(snip)
 
> > @@ -99,13 +98,11 @@ do
> >  	xfs_freeze -f "$SCRATCH_MNT" | tee -a $seq.full
> >  	[ $? != 0 ] && echo xfs_freeze -f "$SCRATCH_MNT" failed | \
> >  	    tee -a $seq.full
> > -	sleep 2
> 
> And this simulates typical freeze/do something/thaw cycles. It also
> allows fsstress to execute operations while the filesytem is frozen
> and potentially try to grab things like the superblock lock because
> fsstress issued a sync() system call. Dropping the sleep makes the
> test less likely to find problems....

I tried to reproduce the problem not dropping the sleep, but the problem was
not reproduced... Therefore, I dropped it and the problem was reproduced.

However, as you mentioned, the problem is a timing proglem, so the
my reproduction might be just by chance. Dropping sleep may increase
the possibility of the reproduction, but not every time, so the change
is not good. That is same for the arguments of fsstress which I changed.

OK, I update 068 just to run other filesystem, ext3, ext4 and btrfs which
I confirmed xfs_freeze works on.
(xfs_freeze may work on the other filesystems which have freeze_fs/unfreeze_fs
 super_operations but I don't confirm...)

The patch is below.
-----------------------------------------------------------
update 068 to run other filesystems, ext3, ext4 and btrfs because
xfs_freeze works on the filesystems.

---
 068 |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/068 b/068
index 5d0053d..6f08f18 100755
--- a/068
+++ b/068
@@ -51,7 +51,7 @@ trap "_cleanup" 0 1 2 3 15
 . ./common.filter
 
 # real QA test starts here
-_supported_fs xfs
+_supported_fs btrfs ext3 ext4 xfs
 _supported_os Linux IRIX
 
 _require_scratch
@@ -62,7 +62,7 @@ rm -f $seq.full
 umount $SCRATCH_DEV >/dev/null 2>&1
 echo "*** MKFS ***"                         >>$seq.full
 echo ""                                     >>$seq.full
-_scratch_mkfs_xfs                           >>$seq.full 2>&1 \
+_scratch_mkfs                               >>$seq.full 2>&1 \
     || _fail "mkfs failed"
 _scratch_mount                              >>$seq.full 2>&1 \
     || _fail "mount failed"
-- 
1.7.1

Thanks,
Masayoshi Mizuma


> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com



