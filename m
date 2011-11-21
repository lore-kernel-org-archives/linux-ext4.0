From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5/8] xfstests: use command line option for setting extra space
Date: Mon, 21 Nov 2011 22:31:25 +1100
Message-ID: <1321875088-30801-6-git-send-email-david@fromorbit.com>
References: <1321875088-30801-1-git-send-email-david@fromorbit.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: xfs@oss.sgi.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:10672 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755139Ab1KULgv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Nov 2011 06:36:51 -0500
In-Reply-To: <1321875088-30801-1-git-send-email-david@fromorbit.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Dave Chinner <dchinner@redhat.com>

Allow the extra free space to leave in large scratch filesystems to
be specified by a command line option rather than just via an
environment variable.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 common |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/common b/common
index da86cd9..78ac654 100644
--- a/common
+++ b/common
@@ -247,6 +247,11 @@ s/ .*//p
 	    usage
 	    ;;
 
+	--extra-space=*)
+	    export SCRATCH_DEV_EMPTY_SPACE=${r#*=}
+	    xpand=false
+	    ;;
+
 	*)
 	    start=$r
 	    end=$r
-- 
1.7.5.4

