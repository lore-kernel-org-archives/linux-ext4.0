From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfsprogs: Fix for xfstest 252 hang on ext4
Date: Mon, 30 May 2011 11:25:34 +1000
Message-ID: <20110530012534.GB561@dastard>
References: <4DDAC4EF.1050702@linux.vnet.ibm.com>
 <4DDE9CD9.3010300@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: xfs-oss <xfs@oss.sgi.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:60252 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751920Ab1E3BZi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 29 May 2011 21:25:38 -0400
Content-Disposition: inline
In-Reply-To: <4DDE9CD9.3010300@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 26, 2011 at 11:32:57AM -0700, Allison Henderson wrote:
> On 5/23/2011 1:34 PM, Allison Henderson wrote:
> >Hi all,
> >
> >While trying to add more punch hole tests to xfstest, I found
> >that test 252 hangs on ext4 due to a loop in xfsprogs that does
> >not exit.  XFS gets out of this loop because there is logic in
> >the loop that looks for the last extent flag and breaks out.  But
> >it looks like ext4 does not return a last extent when the file
> >has a hole at the end.  I am not sure if this is the correct
> >behavior or not, so I will copy the ext4 folks on this too.
> >Below is a copy of the fix for xfsprogs:
> >
> >diff --git a/io/fiemap.c b/io/fiemap.c
> >index fa990cc..81fc92c 100644
> >--- a/io/fiemap.c
> >+++ b/io/fiemap.c
> >@@ -246,7 +246,7 @@ fiemap_f(
> >  		       flg_w, _("FLAGS"));
> >  	}
> >
> >-	while (!last&&  ((cur_extent + 1) != max_extents)) {
> >+	while (!last&&  (cur_extent<= max_extents)) {
> >  		if (max_extents)
> >  			num_extents = min(num_extents,
> >  					  max_extents - (cur_extent + 1));
> >
> >
> >It looks like the loop enters with last=0, cur_extents=0, and
> >max_extents = 0, and on the first iteration cur_extents get set
> >to 2, so we dont see ((cur_extent + 1) == max_extents for a very
> >long time.  I doubt the logic was meant to work that way, so this
> >patch should fix it, but I wanted to make sure that the fiemap
> >for ext4 is working as intended too.  Feed back appreciated!  Thx
> >all!
> >
> >Allison Henderson
> >
> Hi all,
> 
> I haven't heard much back on this patch, so Im just poking this
> thread to make sure it doesn't get forgotten. I have some patches
> out there for punch hole, and I'm currently looking at fixing up
> some older punch hole tests in the dmapi code, but they wont do much
> good for ext4 with out this fix.  If I could get a quick peek from
> some one on the xfs list for this patch, that would be much
> appreciated.  Thx all!

If ext4 is not setting the last extent flag on the last extent then
that's an ext4 bug that the test has detected, right? And so you
should be fixing ext4 rather than modifying the test to hide the
different behaviour?

Cheer
-- 
Dave Chinner
david@fromorbit.com
