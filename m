From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/3] jbd2 : Make jbd2 transaction handle allocation to
 return errors and handle them gracefully.
Date: Tue, 25 Jan 2011 12:40:20 +0100
Message-ID: <20110125114020.GA4088@quack.suse.cz>
References: <AANLkTi=o-rcsbY1gOExGyWdQ41m7KWpJ7=UzX4306m=t@mail.gmail.com>
 <20110123054049.GC3237@thunk.org>
 <20110123062900.GA7436@noexit>
 <20110124133143.GA5058@quack.suse.cz>
 <20110124172020.GB22970@noexit>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Ted Ts'o <tytso@mit.edu>,
	Manish Katiyar <mkatiyar@gmail.com>,
	ext4 <linux-ext4@vger.kernel.org>
To: Joel Becker <jlbec@evilplan.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46486 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752627Ab1AYLkW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Jan 2011 06:40:22 -0500
Content-Disposition: inline
In-Reply-To: <20110124172020.GB22970@noexit>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 24-01-11 09:20:23, Joel Becker wrote:
> On Mon, Jan 24, 2011 at 02:31:43PM +0100, Jan Kara wrote:
> > On Sat 22-01-11 22:29:01, Joel Becker wrote:
> > > 	This API is markedly better to read.  Btw, does _nofail() mean no
> > > possible failures, or just no memory errors?  If it is no failures, I'd
> > > love to see the function become void.
> >   jbd2_journal_start can always fail e.g. because the journal is aborted.
> > So it really just means no memory failures...
> 
> 	Then _nofail() is a terrible name, because it can still fail.
> Let's call it jbd2_journal_start_nofs(); that's what it is.
  Good point. But it's not even NO_FS - that's just an internal thing how
JBD2 abuses gfp flags to communicate it's wish. It should really be "do not
fail if there is still hope because user will silently loose data if you
do". But that's obviously too long for a function name suffix ;). I'm
looking for a better name... Andreas' _retry does not well describe what's
the desired effect either.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
