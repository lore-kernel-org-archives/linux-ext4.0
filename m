From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] resend : badblocks - Print progress in percent
	complete and time elapsed in verbose mode.
Date: Fri, 5 Sep 2008 09:06:48 -0400
Message-ID: <20080905130648.GG9129@mit.edu>
References: <ea11fea30809040214r5d5d3e41ifa32118b2e93660d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:43568 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752768AbYIEOgl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 5 Sep 2008 10:36:41 -0400
Content-Disposition: inline
In-Reply-To: <ea11fea30809040214r5d5d3e41ifa32118b2e93660d@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 04, 2008 at 02:44:38PM +0530, Manish Katiyar wrote:
> Make badblocks -v print percent complete and time elapsed. Addresses
> debian bug# 429739.

There were a couple of problems with this bug.  First of all, although
I understand your not wanting to change what -v does, having two
verbose options is rather confusing.  Also, since progress information
is printed using backspaces and so on, it's not really practical for a
program to depend on the output of badblocks -v.

Secondly, the way you formatted the elapsed time was very fragile and
would break if someone ever tried to change the way the elapsed time
was printed (or if the number of hours went ever became greater than
999, which I grant is unlikely).  I noticed the problem because I
wasn't fond of the the "34h 45m 20s" format (it doesn't
internationalize well, for one thing), and tried to change it to a
mm:ss or hh:mm:ss format, at which point mayhem broke loose.  

So I've simplified the patch significantly, as follows.

						- Ted

commit 504f7a2981306032fff7084c0d90beaa45872ee0
Author: Manish Katiyar <mkatiyar@gmail.com>
Date:   Thu Sep 4 14:44:38 2008 +0530

    badblocks: Display time and percentage complete in verbose mode.
    
    Addresses-Debian-Bug: #429739.
    
    Signed-off-by: "Manish Katiyar" <mkatiyar@gmail.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/misc/badblocks.c b/misc/badblocks.c
index 1d0f95a..e7e9968 100644
--- a/misc/badblocks.c
+++ b/misc/badblocks.c
@@ -55,7 +55,6 @@ extern int optind;
 #include <sys/time.h>
 #include <sys/ioctl.h>
 #include <sys/types.h>
-#include <sys/time.h>
 
 #include "et/com_err.h"
 #include "ext2fs/ext2_io.h"
@@ -78,6 +77,7 @@ static int current_O_DIRECT = 0;	/* Current status of O_DIRECT flag */
 static int exclusive_ok = 0;
 static unsigned int max_bb = 0;		/* Abort test if more than this number of bad blocks has been encountered */
 static unsigned int d_flag = 0;		/* delay factor between reads */
+static struct timeval time_start;
 
 #define T_INC 32
 
@@ -161,11 +161,52 @@ static int bb_output (blk_t bad)
 	return 1;
 }
 
+static char *time_diff_format(struct timeval *tv1,
+			      struct timeval *tv2, char *buf)
+{
+        time_t	diff = (tv1->tv_sec - tv2->tv_sec);
+	int	hr,min,sec;
+
+	sec = diff % 60;
+	diff /= 60;
+	min = diff % 60;
+	hr = diff / 60;
+
+	if (hr)
+		sprintf(buf, "%d:%02d:%02d", hr, min, sec);
+	else
+		sprintf(buf, "%d:%02d", min, sec);
+	return buf;
+}
+
+static float calc_percent(unsigned long current, unsigned long total) {
+	float percent = 0.0;
+	if (total <= 0)
+		return percent;
+	if (current >= total) {
+		percent = 100.0;
+	} else {
+		percent=(100.0*(float)current/(float)total);
+	}
+	return percent;
+}
+
 static void print_status(void)
 {
-	fprintf(stderr, "%15lu/%15lu", (unsigned long) currently_testing,
-		(unsigned long) num_blocks);
-	fputs("\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b", stderr);
+	struct timeval time_end;
+	char diff_buf[32], line_buf[128];
+	int len;
+
+	gettimeofday(&time_end, 0);
+	len = snprintf(line_buf, sizeof(line_buf), 
+		       _("%6.2f%% done, %s elapsed"),
+		       calc_percent((unsigned long) currently_testing,
+				    (unsigned long) num_blocks), 
+		       time_diff_format(&time_end, &time_start, diff_buf));
+	fputs(line_buf, stderr);
+	memset(line_buf, '\b', len);
+	line_buf[len] = 0;
+	fputs(line_buf, stderr);	
 	fflush (stderr);
 }
 
@@ -989,6 +1030,7 @@ int main (int argc, char ** argv)
 			break;
 		case 'v':
 			v_flag++;
+			gettimeofday(&time_start, 0);
 			break;
 		case 'w':
 			if (w_flag)
