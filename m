From: Hugh Dickins <hughd@google.com>
Subject: Re: punch-hole should go beyond i_size
Date: Thu, 12 Jan 2012 16:21:30 -0800 (PST)
Message-ID: <alpine.LSU.2.00.1201121617320.1541@eggly.anvils>
References: <alpine.LSU.2.00.1201111639240.1833@eggly.anvils> <20120112025547.GC2806@dastard> <4F0F08F6.2000205@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:58516 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756073Ab2AMAVu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Jan 2012 19:21:50 -0500
Received: by obcva7 with SMTP id va7so1451934obc.19
        for <linux-ext4@vger.kernel.org>; Thu, 12 Jan 2012 16:21:48 -0800 (PST)
In-Reply-To: <4F0F08F6.2000205@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 12 Jan 2012, Allison Henderson wrote:
> On 01/11/2012 07:55 PM, Dave Chinner wrote:
> > On Wed, Jan 11, 2012 at 05:02:12PM -0800, Hugh Dickins wrote:
> > > 
> > > ext4_ext_punch_hole() contains /* No need to punch hole beyond i_size */
> > > early return, and trimming to i_size below, but forgets that the other
> > > variety of fallocate(), with FALLOC_FL_KEEP_SIZE set, may have allocated
> > > blocks beyond i_size.  They can be removed with ftruncate(), but it is
> > > unexpected for fallocate() not to undo its own work, and xfs does so.
> > 
> > I'm pretty sure that's a bug as XFS allows punching holes in extents
> > beyond EOF.
> 
> Oh I see, I'll take a look at it, I think it will be ok to just take out the
> early return.  Thx!

Thanks.  And I've just noticed another, very easily fixed, error:
I believe those -ENOTSUPPs in ext4_punch_hole() should be -EOPNOTSUPPs.

Hugh
