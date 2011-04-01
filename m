From: Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: Re: [Lsf-pc] [LSF/FS TOPIC] Ext4 snapshots status update
Date: Fri, 01 Apr 2011 02:10:09 +0200
Message-ID: <1301616609.26686.25.camel@lade.trondhjem.org>
References: <AANLkTink6o249JivXiETT6JnANNcikNqGGfr8+McDQsM@mail.gmail.com>
	 <20110204002043.GA15658@noexit>
	 <AANLkTimuR-oOprBR7Xkehx01ojrdxYOmgqdnX7wNbpt6@mail.gmail.com>
	 <20110330003429.GA32669@noexit>
	 <AANLkTi=vReDmq22=kKieJp9uaeAVC-VXj8VjHWQfXaDp@mail.gmail.com>
	 <1301485711-sup-3080@think>
	 <AANLkTim+7hUX0rsusDTvBNGKOU6bwA=8AGT9EM1+z7hu@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Cc: Chris Mason <chris.mason@oracle.com>,
	lsf-pc <lsf-pc@lists.linuxfoundation.org>,
	Joel Becker <jlbec@evilplan.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Josef Bacik <josef@redhat.com>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.netapp.com ([216.240.18.37]:33171 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759531Ab1DAAK0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 31 Mar 2011 20:10:26 -0400
In-Reply-To: <AANLkTim+7hUX0rsusDTvBNGKOU6bwA=8AGT9EM1+z7hu@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 2011-03-30 at 14:08 +0200, Amir Goldstein wrote:
> On Wed, Mar 30, 2011 at 1:50 PM, Chris Mason <chris.mason@oracle.com> wrote:
> > Excerpts from Amir Goldstein's message of 2011-03-30 00:16:45 -0400:
> >> On Wed, Mar 30, 2011 at 2:34 AM, Joel Becker <jlbec@evilplan.org> wrote:
> >> > On Wed, Mar 23, 2011 at 10:19:38PM +0200, Amir Goldstein wrote:
> >> >> On Fri, Feb 4, 2011 at 2:20 AM, Joel Becker <jlbec@evilplan.org> wrote:
> >> >> > On Fri, Feb 04, 2011 at 12:33:39AM +0200, Amir Goldstein wrote:
> >> >> >        I've already got a design for a front-end snapshot program that
> >> >> > implements a policy on top this generic behavior.  This design would
> >> >> > cover both first-class and hidden style snapshots, because it assume
> >> >> > snapshots are in a distinct namespace.  I haven't gotten around to
> >> >> > implementing it yet, but btrfs and other snapshottable filesystems were
> >> >> > part of the design goal.
> >> >>
> >> >> Any chance of getting a copy of that design of yours, to get a head start
> >> >> for LSF?
> >> >
> >> >        Yeah, I owe it to you.  It wasn't a written-down thing, it was a
> >> > hammered-out-in-our-heads thing among some ocfs2 developers.  I'm going
> >> > to braindump here to get us going.  First, I'll speak to your points.
> >> >
> >> >> Here are some other generic snapshot related topics we may want to discuss:
> >> >>
> >> >> 1. Collaborating the use of inode flags COW_FL, NOCOW_FL, suggested by Chris.
> >> >
> >> >        I'm unsure where these fit, perhaps because I missed the
> >> > discussion between Chris and you.  ocfs2 has the inode flag
> >> > OCFS2_REFCOUNTED_FL to signify a refcount tree is attached to the inode.
> >> > This is ocfs2's structure for maintaining extent reference counts.  Is
> >> > your COW_FL the same?  Or is it a permission flag?  NOCOW_FL sounds
> >> > like: "Set this flag on the inode and it will prevent CoW."
> >>
> >> I don't have a use for COW_FL, since my snapshots are volume level snapshots.
> >> I intend to use NOCOW_FL to mark an inode as an "island" of NOCOW
> >> blocks in the volume.
> >> Maybe Chris or Josef can elaborate of the flags intended use in btrfs.
> >
> > NOWCOW_FL in btrfs means to directly overwrite blocks (and not do crcs)
> > unless the block has another reference.  If there is another reference,
> > we COW once to honor the snapshot and then continue in NOCOW mode.
> >
> > I'm kind of worried about your NOCOW island idea, maybe we can talk more
> > about that next week.  It seems like it will lead to a lot of admin
> > surprises.
> >
> 
> Yes, that's something to talk about.
> My desire for NOCOW comes from lack of sub volume granularity
> in ext4 snapshots.
> 
> My NOCOW design states that NOCOW flag cannot be toggled on a regular file.
> like a snapshot file, a NOCOW file must be born and die NOCOW, to avoid
> admin surprises. NOCOW directories (which ARE COWed) are were NOCOW
> files are born.
> 
> Using this scheme, an admin can exclude->include->exclude directory sub trees
> from snapshots.

OK. I'd like to schedule a general talk about the state of snapshots and
future improvements. I'm assuming you would like to lead the debate.

Cheers
  Trond
-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

