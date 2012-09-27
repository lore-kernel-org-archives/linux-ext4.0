From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 03/10] ext4: fix unwritten counter leakage
Date: Thu, 27 Sep 2012 15:07:18 +0200
Message-ID: <20120927130718.GD28126@quack.suse.cz>
References: <1348487060-19598-1-git-send-email-dmonakhov@openvz.org>
 <1348487060-19598-4-git-send-email-dmonakhov@openvz.org>
 <20120926130714.GD10145@quack.suse.cz>
 <87bogr64lm.fsf@openvz.org>
 <20120927123420.GC28126@quack.suse.cz>
 <878vbv62yy.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, tytso@mit.edu,
	lczerner@redhat.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41849 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793Ab2I0NHV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 27 Sep 2012 09:07:21 -0400
Content-Disposition: inline
In-Reply-To: <878vbv62yy.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 27-09-12 16:54:13, Dmitry Monakhov wrote:
> On Thu, 27 Sep 2012 14:34:20 +0200, Jan Kara <jack@suse.cz> wrote:
> > On Thu 27-09-12 16:19:01, Dmitry Monakhov wrote:
> > > On Wed, 26 Sep 2012 15:07:14 +0200, Jan Kara <jack@suse.cz> wrote:
> > > > On Mon 24-09-12 15:44:13, Dmitry Monakhov wrote:
> > > > > ext4_set_io_unwritten_flag() will increment i_unwritten counter, so
> > > > > once we mark end_io with END_IO_UNWRITTEN we have to revert it back
> > > >                            ^^ EXT4_IO_END_UNWRITTEN
> > > > > on error path.
> > > > > 
> > > > >  - add missed error checks to prevent counter leakage
> > > > >  - ext4_end_io_nolock() will clear END_IO_UNWRITTEN flag to signal
> > > >                                      ^^ EXT4_IO_END_UNWRITTEN
> > > > >    that conversion finished.
> > > > >  - add BUGON to free_end_io() to prevent similar leackage in future.
> > > >          ^^ BUG_ON    ^^ext4_free_io_end()         ^^ leakage
> > > > 
> > > > > Visiable effect of this bug is that unaligned aio_stress may deadlock
> > > >   ^^ Visible
> > > > 
> > > >   Umm, and won't it be more foolproof it we just decrement i_unwritten in
> > > > ext4_free_io_end() when we see EXT4_IO_END_UNWRITTEN set?
> > > I'd like to consider BUG_ON inside ext4_free_io_end as a sanity check to
> > > force all callers to perform all necessary error checks in known context. 
> >   I'm not sure how "performing all necessary error checks in known context"
> > relates to ext4_free_io_end() cleaning up the structure on its own or
> > whether someone has to do it beforehand... Can you maybe elaborate a bit
> > more?
> I assume that if end_io was tagged with UNWRITTEN flag it should goes trough
> complete_io_list and end_io_nolock(), or caller should cancel it by
> itself in case of error, otherwise we may miss valid unwritten end_io
> but was not scheduled to complete_end_io routine by occasion (and endup
> in silent data loss). In my opinion at the time then ext4_free_io_end() 
> was called all possible conversions should be completed.
  Fair enough. I just hated verifying all the paths in extent.c and
checking whether they could happen to have end_io with UNWRITTEN flag set.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
