From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 1/5] jbd: Fail to load a journal if it is too short
Date: Tue, 21 Jul 2009 10:50:14 -0600
Message-ID: <20090721165014.GI4231@webber.adilger.int>
References: <1248170659-11771-1-git-send-email-jack@suse.cz>
 <1248170659-11771-2-git-send-email-jack@suse.cz>
 <20090721091946.06bcdef8.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:49729 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754526AbZGUQup (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Jul 2009 12:50:45 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n6LGofZ6007608
	for <linux-ext4@vger.kernel.org>; Tue, 21 Jul 2009 09:50:41 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 id <0KN50050057EBA00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Tue,
 21 Jul 2009 09:50:41 -0700 (PDT)
In-reply-to: <20090721091946.06bcdef8.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jul 21, 2009  09:19 -0700, Andrew Morton wrote:
> On Tue, 21 Jul 2009 12:04:15 +0200 Jan Kara <jack@suse.cz> wrote:
> > Due to on disk corruption, it can happen that journal is too short. Fail
> > to load it in such case so that we don't oops somewhere later.
> > 
> > Reported-by: Nageswara R Sastry <rnsastry@linux.vnet.ibm.com>
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/jbd/journal.c |    6 ++++++
> >  1 files changed, 6 insertions(+), 0 deletions(-)
> > 
> > diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
> > index 737f724..94a64a1 100644
> > --- a/fs/jbd/journal.c
> > +++ b/fs/jbd/journal.c
> > @@ -848,6 +848,12 @@ static int journal_reset(journal_t *journal)
> >  
> >  	first = be32_to_cpu(sb->s_first);
> >  	last = be32_to_cpu(sb->s_maxlen);
> > +	if (first + JFS_MIN_JOURNAL_BLOCKS > last + 1) {
> > +		printk(KERN_ERR "JBD: Journal too short (blocks %lu-%lu).\n",
> > +		       first, last);
> > +		journal_fail_superblock(journal);
> > +		return -EINVAL;
> > +	}
> >  
> >  	journal->j_first = first;
> >  	journal->j_last = last;
> 
> It's odd that sb->s_first/s_maxlen are 32-bit and
> journal->j_first/j_last are unsigned long.
> 
> These things will only ever be 32-bit unless we change the journal
> superblock.

The jbd on disk structure and APIs cannot handle 64-bit block numbers.
That is one of the first changes we made for jbd2 so that it is possible
to store either 32-bit or 64-bit block numbers in a transaction.  I don't
think that needs to be fixed for the jbd code.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

