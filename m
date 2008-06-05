From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 1/5] jbd: strictly check for write errors on data	buffers
Date: Thu, 05 Jun 2008 12:49:41 -0600
Message-ID: <20080605184941.GX2961@webber.adilger.int>
References: <20080603153050.fb99ac8a.akpm@linux-foundation.org>
 <20080604101925.GB16572@duck.suse.cz>
 <20080604111911.c1fe09c6.akpm@linux-foundation.org>
 <20080604212202.GA8727@mit.edu>
 <20080604145848.e3da6f20.akpm@linux-foundation.org>
 <20080604225155.GB8727@mit.edu> <20080605093536.GE27370@duck.suse.cz>
 <4847CF07.1020904@hitachi.com> <20080605142948.GA25477@mit.edu>
 <20080605092006.ba7dceef.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Theodore Tso <tytso@mit.edu>,
	Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
	Jan Kara <jack@suse.cz>, sct@redhat.com,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	jbacik@redhat.com, cmm@us.ibm.com, yumiko.sugita.yf@hitachi.com,
	satoshi.oshima.fk@hitachi.com
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:45251 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754277AbYFESts (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Jun 2008 14:49:48 -0400
In-reply-to: <20080605092006.ba7dceef.akpm@linux-foundation.org>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jun 05, 2008  09:20 -0700, Andrew Morton wrote:
> On Thu, 5 Jun 2008 10:29:48 -0400 Theodore Tso <tytso@mit.edu> wrote:
> > On Thu, Jun 05, 2008 at 08:33:27PM +0900, Hidehiro Kawai wrote:
> > > 
> > > My patch doesn't change the policy.  JBD aborts the journal when
> > > it detects I/O error in file data since 2.6.11.  Perhaps this patch:
> > > http://marc.info/?l=linux-kernel&m=110483888632225
> > > I just added missing error checkings.
> > 
> > Looking at the code paths touched by patch you referenced, you are
> > correct.  And Andrew even signed off on it.  :-)
> > 
> > But if someone was only examining the patch, it wasn't obvious that
> > the journal was getting aborted when the JBD layer was forcing buffers
> > from t_sync_datalist to disk.  So I suspect the change went in without
> > proper consideration of the net effect.  You just called it out
> > explicitly in the subject line, which caused Andrew to ask some good
> > questions; questions that weren't asked in 2005.
> 
> Sigh. An object lesson in the value of good changelogging :(

... and the value of "diff -p" so it is clear what function is being changed.

> I guess we need to undo this.  And yes, propagating errors into AS_EIO
> is the way.  I guess that's safe without holding lock_page(), as long
> as the bh is pinned.

Something like the following instead if -EIO and journal abort:

		if (!buffer_uptodate(bh)) {
			set_bit(AS_EIO, &bh->b_page->mapping->flags);
			SetPageError(bh->b_page);
		}

It seems end_buffer_async_write() does this already, but
journal_do_submit_data() uses end_buffer_write_sync() and it does not
do either of those operations.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

