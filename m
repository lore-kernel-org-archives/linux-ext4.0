From: Andreas Dilger <adilger@sun.com>
Subject: Re: EXT4: kernel BUG at fs/jbd2/commit.c:533!
Date: Wed, 02 Sep 2009 15:07:37 -0600
Message-ID: <20090902210737.GV4197@webber.adilger.int>
References: <4A9E5496.8050909@in.ibm.com> <20090902120958.GA16415@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Sachin Sant <sachinp@in.ibm.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:54235 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbZIBVH2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Sep 2009 17:07:28 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n82L7UER016692
	for <linux-ext4@vger.kernel.org>; Wed, 2 Sep 2009 14:07:30 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KPD00C003QOFF00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Wed,
 02 Sep 2009 14:07:30 -0700 (PDT)
In-reply-to: <20090902120958.GA16415@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sep 02, 2009  08:09 -0400, Theodore Ts'o wrote:
> On Wed, Sep 02, 2009 at 04:48:46PM +0530, Sachin Sant wrote:
> > While executing fsstress against ext4 with 2.6.31-rc8 on a
> > powerpc box, ran into the following Bug.
> >
> > ------------[ cut here ]------------
> > cpu 0x0: Vector: 700 (Program Check) at [c0000000f3ae3970]
> >    pc: c000000000280f28: .jbd2_journal_commit_transaction+0x8ac/0x1bfc
> >    lr: c000000000280e58: .jbd2_journal_commit_transaction+0x7dc/0x1bfc
> >    sp: c0000000f3ae3bf0
> >   msr: 8000000000029032
> >  current = 0xc0000000f315c7d0
> >  paca    = 0xc000000000b62600
> >    pid   = 23139, comm = kjournald2
> > kernel BUG at fs/jbd2/commit.c:533!
> 
> Hmm, that's this ASSERT:
> 
>      J_ASSERT(commit_transaction->t_nr_buffers <=
>               commit_transaction->t_outstanding_credits);
> 
> in jbd2_journal_commit_transaction().  That's not something I've ever
> seen before, nor have we made any changes in the jbd2 logic in quite
> some time that would could be related to that code.
> 
> Is it possible to extract out the contents of the commit_transaction
> structure?  In particular, the t_nr_buffers and t_outstanding_credits value?
> 
> At this point, I can't rule out a wild pointer corrupting the data
> structure, however improbable that sounds... 

Given the nature of the test being run (fsstress) it seems entirely
possible that there is some transaction which doesn't reserve enough
credits for the operation in some rare corner case?

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

