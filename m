From: Joel Becker <jlbec@evilplan.org>
Subject: Re: [PATCH 1/3] jbd2 : Make jbd2 transaction handle allocation to
 return errors and handle them gracefully.
Date: Mon, 24 Jan 2011 09:20:23 -0800
Message-ID: <20110124172020.GB22970@noexit>
References: <AANLkTi=o-rcsbY1gOExGyWdQ41m7KWpJ7=UzX4306m=t@mail.gmail.com>
 <20110123054049.GC3237@thunk.org>
 <20110123062900.GA7436@noexit>
 <20110124133143.GA5058@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Ts'o <tytso@mit.edu>, Manish Katiyar <mkatiyar@gmail.com>,
	ext4 <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:37779 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867Ab1AXRUm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Jan 2011 12:20:42 -0500
Content-Disposition: inline
In-Reply-To: <20110124133143.GA5058@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 24, 2011 at 02:31:43PM +0100, Jan Kara wrote:
> On Sat 22-01-11 22:29:01, Joel Becker wrote:
> > 	This API is markedly better to read.  Btw, does _nofail() mean no
> > possible failures, or just no memory errors?  If it is no failures, I'd
> > love to see the function become void.
>   jbd2_journal_start can always fail e.g. because the journal is aborted.
> So it really just means no memory failures...

	Then _nofail() is a terrible name, because it can still fail.
Let's call it jbd2_journal_start_nofs(); that's what it is.

Joel

-- 

"Under capitalism, man exploits man.  Under Communism, it's just 
   the opposite."
				 - John Kenneth Galbraith

			http://www.jlbec.org/
			jlbec@evilplan.org
