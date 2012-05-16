From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: punch-hole should go beyond i_size
Date: Wed, 16 May 2012 08:14:56 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1205160810580.3179@dhcp-1-248.brq.redhat.com>
References: <alpine.LSU.2.00.1201111639240.1833@eggly.anvils> <20120112025547.GC2806@dastard> <4F0F08F6.2000205@linux.vnet.ibm.com> <alpine.LSU.2.00.1205131404040.1547@eggly.anvils> <4FB2CC79.4020200@linux.vnet.ibm.com>
 <alpine.LSU.2.00.1205151529140.1571@eggly.anvils>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Allison Henderson <achender@linux.vnet.ibm.com>,
	Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Lukas Czerner <lczerner@redhat.com>
To: Hugh Dickins <hughd@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20486 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335Ab2EPGPm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 May 2012 02:15:42 -0400
In-Reply-To: <alpine.LSU.2.00.1205151529140.1571@eggly.anvils>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 15 May 2012, Hugh Dickins wrote:

> Date: Tue, 15 May 2012 15:38:33 -0700 (PDT)
> From: Hugh Dickins <hughd@google.com>
> To: Allison Henderson <achender@linux.vnet.ibm.com>
> Cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
>     Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
>     Lukas Czerner <lczerner@redhat.com>
> Subject: Re: punch-hole should go beyond i_size
> 
> On Tue, 15 May 2012, Allison Henderson wrote:
> > On 05/13/2012 02:13 PM, Hugh Dickins wrote:
> > > On Thu, 12 Jan 2012, Allison Henderson wrote:
> > >> On 01/11/2012 07:55 PM, Dave Chinner wrote:
> > >>> On Wed, Jan 11, 2012 at 05:02:12PM -0800, Hugh Dickins wrote:
> > >>>> Hi Allison,
> > >>>>
> > >>>> In thinking about fallocate() on tmpfs, I cross-check with ext4
> > >>>> and find this bug in its implementation of FALLOC_FL_PUNCH_HOLE:
> > >>>>
> > >>>> rm -f temp
> > >>>> fallocate    -l 4096 temp
> > >>>> du temp				# shows 4, right
> > >>>> fallocate -p -l 4096 temp
> > >>>> du temp				# shows 0, right
> > >>>> rm -f temp
> > >>>> fallocate -n -l 4096 temp
> > >>>> du temp				# shows 4, right
> > >>>> fallocate -p -l 4096 temp
> > >>>> du temp				# shows 4, wrong
> > >>>> rm temp
> > >>>>
> > >>>> ext4_ext_punch_hole() contains /* No need to punch hole beyond i_size */
> > >>>> early return, and trimming to i_size below, but forgets that the other
> > >>>> variety of fallocate(), with FALLOC_FL_KEEP_SIZE set, may have allocated
> > >>>> blocks beyond i_size.  They can be removed with ftruncate(), but it is
> > >>>> unexpected for fallocate() not to undo its own work, and xfs does so.
> > >>>
> > >>> I'm pretty sure that's a bug as XFS allows punching holes in extents
> > >>> beyond EOF.
> > >>>
> > >>> Cheers,
> > >>>
> > >>> Dave.
> > >>
> > >> Oh I see, I'll take a look at it, I think it will be ok to just take out the
> > >> early return.  Thx!
> > > 
> > > I see the -EOPNOTSUPPs have gone into 3.4's ext4_punch_hole() - thanks -
> > > but the i_size issue remains unfixed.  I wouldn't be surprised if it were
> > > more complicated than you had hoped - I had no intention of trying a patch
> > > myself!  It's not an actual problem for me, but I thought I'd just send a
> > > reminder, before I move out of the hole-punching business.
> > 
> > Hi all,
> > 
> > I had a fix for this a while ago and I believe Lukas had rebased it
> > when he was working on some punch hole optimizations, but Im not sure
> > what happened to it after that.  I think Lukas might still be working
> > on that set?  If not, I can take a peek at it again and see if I can
> > get it updated and resent.  Thx!
> > 
> > Allison Henderson 
> 
> Thanks, Allison.  I just added Jan to the Cc list to make sure he sees,
> since we mentioned this in the inode_dio_wait thread (which I skilfully
> directed to an almost disjoint set of addressees - though I expect he
> already saw via linux-ext4).
> 
> Hugh

Yes, we've been talking about this issue on LSF with Ted and the
conclusion is that we want to wait for the range locks to be ready.
This way we can avoid taking imutex for the punch hole when punching
beyond isize which we would have to do otherwise.

I am not sure how big of an issue this is, probably not so big. If
we can not wait for the range locks, I can make a patch with imutex
protection.

Thanks!
-Lukas
