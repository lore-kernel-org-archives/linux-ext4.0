From: Hugh Dickins <hughd@google.com>
Subject: Re: punch-hole should go beyond i_size
Date: Sun, 13 May 2012 14:13:31 -0700 (PDT)
Message-ID: <alpine.LSU.2.00.1205131404040.1547@eggly.anvils>
References: <alpine.LSU.2.00.1201111639240.1833@eggly.anvils> <20120112025547.GC2806@dastard> <4F0F08F6.2000205@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Dave Chinner <david@fromorbit.com>, Theodore Ts'o <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46109 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746Ab2EMVNq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 13 May 2012 17:13:46 -0400
Received: by pbbrp8 with SMTP id rp8so5307335pbb.19
        for <linux-ext4@vger.kernel.org>; Sun, 13 May 2012 14:13:46 -0700 (PDT)
In-Reply-To: <4F0F08F6.2000205@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 12 Jan 2012, Allison Henderson wrote:
> On 01/11/2012 07:55 PM, Dave Chinner wrote:
> > On Wed, Jan 11, 2012 at 05:02:12PM -0800, Hugh Dickins wrote:
> > > Hi Allison,
> > > 
> > > In thinking about fallocate() on tmpfs, I cross-check with ext4
> > > and find this bug in its implementation of FALLOC_FL_PUNCH_HOLE:
> > > 
> > > rm -f temp
> > > fallocate    -l 4096 temp
> > > du temp				# shows 4, right
> > > fallocate -p -l 4096 temp
> > > du temp				# shows 0, right
> > > rm -f temp
> > > fallocate -n -l 4096 temp
> > > du temp				# shows 4, right
> > > fallocate -p -l 4096 temp
> > > du temp				# shows 4, wrong
> > > rm temp
> > > 
> > > ext4_ext_punch_hole() contains /* No need to punch hole beyond i_size */
> > > early return, and trimming to i_size below, but forgets that the other
> > > variety of fallocate(), with FALLOC_FL_KEEP_SIZE set, may have allocated
> > > blocks beyond i_size.  They can be removed with ftruncate(), but it is
> > > unexpected for fallocate() not to undo its own work, and xfs does so.
> > 
> > I'm pretty sure that's a bug as XFS allows punching holes in extents
> > beyond EOF.
> > 
> > Cheers,
> > 
> > Dave.
> 
> Oh I see, I'll take a look at it, I think it will be ok to just take out the
> early return.  Thx!

I see the -EOPNOTSUPPs have gone into 3.4's ext4_punch_hole() - thanks -
but the i_size issue remains unfixed.  I wouldn't be surprised if it were
more complicated than you had hoped - I had no intention of trying a patch
myself!  It's not an actual problem for me, but I thought I'd just send a
reminder, before I move out of the hole-punching business.

Hugh
