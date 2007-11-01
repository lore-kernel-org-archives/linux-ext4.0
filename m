From: Alex Tomas <bzzz.tomas@gmail.com>
Subject: Re: delalloc fragmenting files?
Date: Thu, 01 Nov 2007 03:35:46 +0300
Message-ID: <47291F62.3000008@gmail.com>
References: <47225B1E.2060708@redhat.com>
 <20071026221938.GV3042@webber.adilger.int> <4728ED3B.1060407@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_swMsbyDWKBxcUdKihTV/Ng)"
Cc: Andreas Dilger <adilger@Sun.COM>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gmp-eb-mail-2.sun.com ([192.18.6.24]:47569 "EHLO
	gmp-eb-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616AbXKAAgN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 31 Oct 2007 20:36:13 -0400
Received: from fe-emea-09.sun.com (gmp-eb-lb-2-fe3.eu.sun.com [192.18.6.12])
	by gmp-eb-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id lA10a19B014648
	for <linux-ext4@vger.kernel.org>; Thu, 1 Nov 2007 00:36:11 GMT
Received: from conversion-daemon.fe-emea-09.sun.com by fe-emea-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JQS00801XHRNQ00@fe-emea-09.sun.com>
 (original mail from bzzz.tomas@gmail.com) for linux-ext4@vger.kernel.org; Thu,
 01 Nov 2007 00:36:00 +0000 (GMT)
In-reply-to: <4728ED3B.1060407@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is a multi-part message in MIME format.

--Boundary_(ID_swMsbyDWKBxcUdKihTV/Ng)
Content-type: text/plain; format=flowed; charset=ISO-8859-1
Content-transfer-encoding: 7BIT

please, try the patch attached.

thanks, Alex

Eric Sandeen wrote:
> One thing that seems to be happening is that thanks to delalloc, a nice
> big request is coming in (only 1036 blocks of the 4096, not quite sure
> why), but then it gets into ext4_mb_normalize_request(), which finds the
> most blocks it can "preallocate" is 256, and chops down the request to
> 256 blocks.  Shouldn't this preallocation be over & above what was asked
> for, vs. reducing the request?
> 
> Ok, so, we get allocations in 256-block chunks...  Why they don't all
> come out contiguous, I don't know yet...
> 
> -Eric


--Boundary_(ID_swMsbyDWKBxcUdKihTV/Ng)
Content-type: text/x-patch; name=mballoc-debug.patch
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=mballoc-debug.patch

Index: linux-2.6.24-rc1/fs/ext4/mballoc.c
===================================================================
--- linux-2.6.24-rc1.orig/fs/ext4/mballoc.c	2007-10-27 10:29:17.000000000 +0400
+++ linux-2.6.24-rc1/fs/ext4/mballoc.c	2007-10-27 22:14:54.000000000 +0400
@@ -3088,8 +3088,10 @@ static void ext4_mb_normalize_request(st
 			break;
 		}
 	}
+	size = wind;
+
 	if (wind == 0) {
-		__u64 tstart;
+		__u64 tstart, tend;
 		/* file is quite large, we now preallocate with
 		 * the biggest configured window with regart to
 		 * logical offset */
@@ -3097,8 +3099,11 @@ static void ext4_mb_normalize_request(st
 		tstart = ac->ac_o_ex.fe_logical;
 		do_div(tstart, wind);
 		start = tstart * wind;
+		tend = ac->ac_o_ex.fe_logical + ac->ac_o_ex.fe_len - 1;
+		do_div(tend, wind);
+		tend = tend * wind + wind;
+		size = tend - start;
 	}
-	size = wind;
 	orig_size = size;
 	orig_start = start;
 

--Boundary_(ID_swMsbyDWKBxcUdKihTV/Ng)--
