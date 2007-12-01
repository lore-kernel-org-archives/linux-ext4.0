From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [EXT4 set 6][PATCH 1/1]Export jbd stats through procfs
Date: Fri, 30 Nov 2007 17:22:16 -0800
Message-ID: <1196472136.11479.33.camel@localhost.localdomain>
References: <1183275490.4010.134.camel@localhost.localdomain>
	 <475097EB.30604@redhat.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:45817 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755883AbXLABWT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 30 Nov 2007 20:22:19 -0500
In-Reply-To: <475097EB.30604@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 2007-11-30 at 17:08 -0600, Eric Sandeen wrote:
> Mingming Cao wrote:
> > [PATCH] jbd2 stats through procfs
> > 
> > The patch below updates the jbd stats patch to 2.6.20/jbd2.
> > The initial patch was posted by Alex Tomas in December 2005
> > (http://marc.info/?l=linux-ext4&m=113538565128617&w=2).
> > It provides statistics via procfs such as transaction lifetime and size.
> > 
> > [ This probably should be rewritten to use debugfs?   -- Ted]
> > 
> > Signed-off-by: Johann Lombardi <johann.lombardi@bull.net>
> 
> I've started going through this one to clean it up to the point where it
> can go forward.  It's been sitting at the top of the unstable portion of
> the patch queue for long enough, I think :)
> 
Thanks!

> I've converted the msecs to jiffies until the user boundary, changed the
> union #defines as suggested by Andrew, and various other little issues etc.
> 
> Remaining to do is a generic time-difference calculator (instead of
> jbd2_time_diff), and looking into whether it should be made a config
> option; I tend to think it should, but it's fairly well sprinkled
> through the code, so I'll see how well that works.
> 
> Also did we ever decided if this should go to debugfs?
> 

I thought it was decided to keep it on procfs as debugfs is not always
on...
> Thanks,
> 
> -Eric
> -
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
