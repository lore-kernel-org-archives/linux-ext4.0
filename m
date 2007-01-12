From: Mingming Cao <cmm@us.ibm.com>
Subject: Call for Ext4 patches
Date: Thu, 11 Jan 2007 16:17:56 -0800
Message-ID: <1168561076.25812.20.camel@dyn9047017103.beaverton.ibm.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:45402 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbXALAR7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Jan 2007 19:17:59 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e31.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0C0HxFY011101
	for <linux-ext4@vger.kernel.org>; Thu, 11 Jan 2007 19:17:59 -0500
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id l0C0HwBE533338
	for <linux-ext4@vger.kernel.org>; Thu, 11 Jan 2007 17:17:58 -0700
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0C0HwM0027353
	for <linux-ext4@vger.kernel.org>; Thu, 11 Jan 2007 17:17:58 -0700
Received: from dyn9047017103.beaverton.ibm.com (dyn9047017103.beaverton.ibm.com [9.47.17.103])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l0C0HvbG027274
	for <linux-ext4@vger.kernel.org>; Thu, 11 Jan 2007 17:17:58 -0700
To: ext4 development <linux-ext4@vger.kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello,

Since ext4 was created at the end of last year, there are many wonderful
ideas and patches proposed to add to ext4, waiting for thorough review,
comment and testing. Some of them were briefly documented at Ext4 wiki
page(http://ext4.wiki.kernel.org/index.php/New_ext4_features).

To spin the wheels faster, at the ext4 interlock call yesterday, it was
agreed to create a home for ext4 candidate patches.  Ted suggested to
host a ext4 git tree somewhere at kernel.org, and probably also put all
patches together in quilt format. This will benefit the developer, the
reviewer and the end users to look at where things are, sort out the
directions, priorities, so we can then work on stabilizing the
code and getting it production-ready.

Instead of looking back to find out what patches have been posted last
year, it seems easier if the patches could be re-post to the mailing
list. It would be great to have a description of what the patches for,
current status, next steps, any dependencies and outstanding issues (if
there is any).

P.S. The feature list documented in the ext4 wiki page by no means to be
complete, very well may have missed some.  Any prototype patches, new
ideas, suggestions and requirements are very welcome and appreciated.

Happy New year!

Cheers,

Mingming
