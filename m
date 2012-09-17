From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: tests: kill debugfs on interrupted MMP test
Date: Sun, 16 Sep 2012 22:03:33 -0400
Message-ID: <20120917020333.GC15224@thunk.org>
References: <1347303887-5513-1-git-send-email-adilger@dilger.ca>
 <20120917011206.GA11666@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:51001 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752224Ab2IQCDh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 16 Sep 2012 22:03:37 -0400
Content-Disposition: inline
In-Reply-To: <20120917011206.GA11666@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Sep 16, 2012 at 09:12:06PM -0400, Theodore Ts'o wrote:
> On Mon, Sep 10, 2012 at 09:04:47AM -0000, Andreas Dilger wrote:
> > If the f_mmp test is interrupted during its test run, then it can
> > leave debugfs busy-looping in the background.  Since f_mmp is a
> > relatively long-running test, and is likely to be running during
> > a parallel test run, this can happen fairly often.
> > 
> > Set a signal trap for the f_mmp test script being killed, so that
> > the background debugfs command will always be killed by the test.
> > 
> > Signed-off-by: Andreas Dilger <adilger@dilger.ca>
> 
> Thanks, applied.

Oops, I'm going to guess you didn't test your patch after making a
last minute change to it.  I had to make the following change to the
f_mmp script to fix a problem where kill would complain about a
non-existing process id (because it was triyng to kill the already
exited awk process):

diff --git a/tests/f_mmp/script b/tests/f_mmp/script
index c1f13fc..d921672 100644
--- a/tests/f_mmp/script
+++ b/tests/f_mmp/script
@@ -21,8 +21,8 @@ fi
 
 kill_debugfs() {
 	trap 0
-	PID=$(ps -o pid,command | awk "/debugfs -w $TMPFILE/ { print \$1 }" |
-	      grep -v awk)
+	PID=$(ps -o pid,command | grep -v awk |
+		awk "/debugfs -w $TMPFILE/ { print \$1 }")
 	[ "x$PID" != "x" ] && kill -9 $PID
 }
 

						- Ted
