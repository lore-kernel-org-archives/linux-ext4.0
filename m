From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [RFC v2] ext4: Don't send extra barrier during fsync if there
	are no dirty pages.
Date: Fri, 6 Aug 2010 00:13:56 -0700
Message-ID: <20100806071356.GE2109@tux1.beaverton.ibm.com>
References: <20100429235102.GC15607@tux1.beaverton.ibm.com> <1272934667.2544.3.camel@mingming-laptop> <4BE02C45.6010608@redhat.com> <1273002566.3755.10.camel@mingming-laptop> <20100629205102.GM15515@tux1.beaverton.ibm.com> <20100805164008.GH2901@thunk.org>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: "Ted Ts'o" <tytso@mit.edu>, Mingming Cao <cmm@us.ibm.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Ke
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:37779 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760450Ab0HFHN7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 6 Aug 2010 03:13:59 -0400
Content-Disposition: inline
In-Reply-To: <20100805164008.GH2901@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 05, 2010 at 12:40:08PM -0400, Ted Ts'o wrote:
> On Tue, Jun 29, 2010 at 01:51:02PM -0700, Darrick J. Wong wrote:
> > 
> > This second version of the patch uses the inode state flags and
> > (suboptimally) also catches directio writes.  It might be a better
> > idea to try to coordinate all the barrier requests across the whole
> > filesystem, though that's a bit more difficult.
> 
> Hi Darrick,
> 
> When I looked at this patch more closely, and thought about it hard,
> the fact that this helps the FFSB mail server benchmark surprised me,
> and then I realized it's because it doesn't really accurately emulate
> a mail server at all.  Or at least, not a MTA.  In a MTA, only one CPU
> will touch a queue file, so there should never be a case of a double
> fsync to a single file.  This is why I was thinking about a
> coordinating barrier requests across the whole filesystem --- it helps
> out in the case where you have all your CPU threads hammering
> /var/spool/mqueue, or /var/spool/exim4/input, and where they are all
> creating queue files, and calling fsync() in parallel.  This patch
> won't help that case.
> 
> It will help the case of a MDA --- Mail Delivery Agent --- if you have
> multiple e-mails all getting delivered at the same time into the same
> /var/mail/<username> file, with an fsync() following after a mail
> message is appended to the file.  This is a much rarer case, and I
> can't think of any other workload where you will have multiple
> processes racing against each other and fsync'ing the same inode.
> Even in the MDA case, it's rare that you will have one mbox getting so
> many deliveries that this case would be hit.
> 
> So while I was thinking about accepting this patch, I now find myself
> hesitating.  There _is_ a minor race in the patch that I noticed,
> which I'll point out below, but that's easily fixed.  The bigger issue
> is it's not clear this patch will actually make a difference in the
> real world.  I trying and failing to think of a real-life application
> which is stupid enough to do back-to-back fsync commands, even if it's
> because it has multiple threads all trying to write to the file and
> fsync to it in an uncoordinated fashion.  It would be easily enough to
> add instrumentation that would trigger a printk if the patch optimized
> out a barrier --- and if someone can point out even one badly written
> application --- whether it's mysql, postgresql, a GNOME or KDE
> application, db2, Oracle, etc., I'd say sure.  But adding even a tiny
> amount of extra complexity for something which is _only_ helpful for a
> benchmark grates against my soul....
> 
> So if you can think of something, please point it out to me.  If it
> would help ext4 users in real life, I'd be all for it.  But at this
> point, I'm thinking that perhaps the real issue is that the mail
> server benchmark isn't accurately reflecting a real life workload.

Yes, it's a proxy for something else.  One of our larger products would like to
use fsync() to flush dirty data out to disk (right now it looks like they use
O_SYNC), but they're concerned that the many threads they use can create an
fsync() storm.  So, they wanted to know how to mitigate the effects of those
storms.  Not calling fsync() except when they really need to guarantee a disk
write is a good start, but I'd like to get ahead of them to pick off more low
hanging fruit like the barrier coordination and not sending barriers when
there's no dirty data ... before they run into it. :)

--D
