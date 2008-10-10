From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC] Btrfs mainline plans
Date: Thu, 9 Oct 2008 23:01:31 -0400
Message-ID: <20081010030131.GO17512@mit.edu>
References: <1222717460.30627.56.camel@think.oraclecorp.com> <20081005141113.GA6132@us.ibm.com> <20081005150957.GC12047@cs181140183.pp.htv.fi> <200810081433.32766.phillips@phunq.net> <20081009082234.GA17013@cs181140183.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Daniel Phillips <phillips@phunq.net>,
	"Serge E. Hallyn" <serue@us.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Mason <chris.mason@oracle.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Adrian Bunk <bunk@kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20081009082234.GA17013@cs181140183.pp.htv.fi>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I've refrained from commenting on this thread mainly because I've been
hugely busy between (a) Linux Foundation 2009 budget planning, (b)
preparing for the Linux Foundation end user summit, (c) making sure
ext4 tree was ready for the opening of the 2.6.28 merge window, and a
million other things --- and because I think this thread is largely
pointless.  At the end of the day, it's mostly Adrian arguing against
early merging, and if Andrew is favor of merging btrfs this point, and
given Linus preferences for early merging of things like device
drivers, it's going to happen regardless of Adrian's opinions.

>From the point of the filesystem, it's all upside to be merged into
the kernel mainline.  We've *always* said that we strongly discourage
out-of-tree kernel modules, whether it's device drivers or externally
maintained filesystems whether it's binary VxFS or ClearCase
filesystem (which is GPL'ed and yet maintained out of tree for a
variety of reasons).  One of the things that we do in order to
strongly discourage out of tree drivers/filesystems is that we
constantly make changes to the API, without regard to making life easy
to the out-of-tree kernel module.  Most of the time the changes are
justified --- although sometimes people have suspected that some
changes made had benefits that were so marginal that it seemed that
the main justification was to screw over externally maintained
drivers/filesystems.  Whether or not that's true, the official party
line is that we show no mercy towards externally maintained device
drivers (even ones that are GPL'ed); the Right Answer is that they
should be part of the mainline kernel.

If that is true, there are very few justifications for keeping a
proposed kernel module out of the tree.  The main consideration is
whether the code will, in the long term, be maintainable.  There is
some minimum level of quality that is needed, although there is some
disagreement about what that level is; but probably what is more
important is the reputation of the maintainer and how trusted that
maintainer is to fix any problems which come up.  If we're going to be
honest with ourselves, that's probably one of the reasons why Reiser4
was never accepted.  Sure, there were technical problems with the
code, but at the main day, the primary problem was that Hans didn't
play well with others, especially those who tried to send him
criticism and/or suggestions about how is code would be improved.  As
a result, it drove away people who were willing to review his code,
and no one was willing to speak up in his defense or give him the
benefit of the doubt.

As far as ext4 is concerned, being in the mainline was all upside, and
I believe that having in the kernel *did* accelerate its progress.  It
meant that kernel-wide API changes were applied automatically, and it
meant that kernel developers who wanted to try out ext4 could do so
quite easily.  Yes, in the past two releases I started maintaining
patchsets against a stable kernel; this was mainly to support those
users who didn't want to follow the latest git releases --- and that
was a reflection that ext4 was mature enough that there were stable
kernel users who were interested in using ext4.  I could have used the
-stable infrastructure, but ext4 was changing so rapidly that it was
easier just to maintain a full patchset.  As a matter of fact,
starting with 2.6.27, given that we'll be renaming ext4dev to ext4 in
the 2.6.28 mergeset, the plan is that we'll be submitting patches to
the -stable series.

Yes, ext4 didn't go as quickly as I would have liked, but part of the
problem was I personally didn't have enough time to review the patches
being created by the various ext4 developers, and I wasn't about to
merge patches until they were ready.  We didn't have enough senior
developers on ext4, and it took a while for some of the developers
assigned to the project to get up to speed.  (I was the most senior
developer, but I've never had time assigned by my employer to work on
ext4; it has always something I did on my own time, often late at
night (hint: check the time this mail was sent, and when the last ext4
patchset was sent out last night).  Fortunately, at this point a
number of developers like Aneesh have become comfortable with the
code, and good at writing patches that don't require major review and
changes, and the addition of engineers hired by Red Hat, such as Eric
and Val, have also helped immensely.

As far as btrfs is concerned, one of the things that you may not know
is that about a year ago (on November 12-13, 2007), a small group key
filesystem developers, that included engineers employed by HP, Oracle,
IBM, Intel, HP, and Red Hat, and whose experience included working
with a large number of filesystems: ext2, ext4, ext4, ocfs2, lustre,
btrfs, advfs, reiserfs, and xfs came together for a two day "next
generation filesystem" (NGFS) workshop.  At the end of the that
workshop, there was unaminous agreement (including from yours truly)
that (a) Linux needed a next generation filesystem to be competitive,
(b) Chris Mason's btrfs (with some changes/enhancements discussed
during the workshop) was the best long-term solution for NGFS, and (c)
because creating a new enterprise filesystem always takes longer than
people expect, and even then, it takes a while for enterprise users to
trust a new filesystem for their most critical data, ext4 in the next
generation of filesystems was needed as the bridge to the NGFS.

The reason why we made these recommendations was not to influence open
source developers (which is why we haven't really talked about it a
lot in venues like the LKML) but as recommendations to the management
of the above-mentioned for assigning resources to the project.  (One
of the recommendations we made was that a critical success factor was
that knowledge about the filesystem must be spread throughout multiple
vendors and distributions.)  But I think it is fair to say that btrfs
isn't just a private a project of a single Linux kernel developer, but
rather the design has been discussed and reviewed by a large number of
experienced filesystem architects.  What *is* important is that Chris
is a well-known kernel developer who is trusted to create and maintain
quality kernel code, and his employer *has* apparently given him
enough time that he can do a lot of personal, hands-on development.

Given btrfs's current status, in terms of its functionality, even its
format is not fully cast into stone yet, and given Chris's reputation
and skills as a kernel devleoper, my personal opinion is that we would
not be making a "special case exception" for btrfs to get it into
mainline, but rather something which makes completely good sense.

At the end of the day, though, it's not my opinion or Adrian's opinion
that matters --- it's really Linus's call.  But if Linus were to ask
my opinion, I would say, "Yes, absolutely --- we should merge btrfs
into mainline."

Regards,

							- Ted
