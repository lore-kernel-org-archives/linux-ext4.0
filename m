From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: errors following ext3 to ext4 conversion
Date: Fri, 28 Aug 2015 14:32:13 -0400
Message-ID: <20150828183213.GC10211@thunk.org>
References: <55DE5F79.4010004@yale.edu>
 <20150827033949.GA12151@thunk.org>
 <55DE8771.9050109@redhat.com>
 <20150827041536.GH10037@birch.djwong.org>
 <20150827185845.GB3357@thunk.org>
 <55DF64CC.8060201@yale.edu>
 <20150827224652.GA5945@thunk.org>
 <55E08B1A.6020503@yale.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Chris Hunter <chris.hunter@yale.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52951 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787AbbH1ScP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 28 Aug 2015 14:32:15 -0400
Content-Disposition: inline
In-Reply-To: <55E08B1A.6020503@yale.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 28, 2015 at 12:23:54PM -0400, Chris Hunter wrote:
> Hi Theodore,
> 
> You are correct there were human errors in these filesystem changes (eg.
> insufficient pre-checks/validation). I don't expect the software to
> compensate for poor planning.
> For future reference, I desire a better understanding of risks involved in
> using tune2fs. I incorrectly assumed that tune2fs doesn't "do" anything
> until a filesystem is mounted.
> Assuming you start with a clean filesystem, which tune2fs commands are the
> most dangerous ? which are the safest ?

In the e2fsprogs 1.42.x series (which is what you are using), the only
really "dangerous" option is "tune2fs -I", which changes the inode
size and require moving blocks around and which could potentially
cause data loss if you lose power while the tune2fs command is
running.

You're posting on the ext4 developer's mailing list, and there have
been discussions to add more "resize2fs-like" features to tune2fs in
the 1.43 development branch of e2fsprogs.  For the *most* part the
commands in tune2fs are "safe" in that they don't touch anything other
than the superblock --- although if the file system is mounted, they
can result in changes right away.

The one command which can have more traps for the unwary is "tune2fs
-O".  It only modifies the superblock, but in some cases, tune2fs will
ask you to run e2fsck afterwards.  We do try to mask out the dangerous
options --- for example, we don't allow you to turn off the extents
option, since that cause problems.  Someone who accidentally enabled
the extents flag on a file system that previously didn't, and while it
is unmounted, can turn it off using debugfs but that _is_ dangerous so
we don't allow tune2fs to do so.

So we do try to make tune2fs safer for non-experts.  In this
particular case, I got a bit frustrated because we got the typical bug
report, and I apologize for my tone.  For some reason, users tend not
to give us relevant information (such as this is a Lustre disk) as
background context, and in some cases, outright *wrong* information
(that this was an ext3 file system that you were converting to ext4;
from what you've said later, apparently this was already had some ext4
features because it was used as a part of Lustre).  This is the sort
of thing that gives support engineers nightmares, and it's why develop
people like myself who are developers sometimes don't make good
support engineers --- we don't have the protective assumptions from
long experience that everything a user asking for help tells us may be
lies.  :-)

						- Ted
						
