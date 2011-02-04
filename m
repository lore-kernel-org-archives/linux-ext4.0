From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/3] jbd2 : Make jbd2 transaction handle allocation to
 return errors and handle them gracefully.
Date: Fri, 4 Feb 2011 16:53:58 +0100
Message-ID: <20110204155358.GF4104@quack.suse.cz>
References: <AANLkTi=o-rcsbY1gOExGyWdQ41m7KWpJ7=UzX4306m=t@mail.gmail.com>
 <20110123054049.GC3237@thunk.org>
 <20110123062900.GA7436@noexit>
 <20110124133143.GA5058@quack.suse.cz>
 <AA32FD05-E9BD-40AB-8495-EAD0547B5E02@dilger.ca>
 <20110125114656.GB4088@quack.suse.cz>
 <AANLkTi=x_RufCNMGaM1DBbYKPKdO-JoQP5YCdDz6dfAc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Andreas Dilger <adilger.kernel@dilger.ca>,
	Joel Becker <jlbec@evilplan.org>, Ted Ts'o <tytso@mit.edu>,
	ext4 <linux-ext4@vger.kernel.org>
To: Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:33077 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082Ab1BDPyG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 4 Feb 2011 10:54:06 -0500
Content-Disposition: inline
In-Reply-To: <AANLkTi=x_RufCNMGaM1DBbYKPKdO-JoQP5YCdDz6dfAc@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat 29-01-11 21:40:03, Manish Katiyar wrote:
  Hi Manish,

> Have we reached on any conclusion yet on the function name which I can
> use to send my updated patch ? My preference from the above list is to
> use ext4_journal_start_nofs() as that seems the closest match, but I
> would like hear the conclusion from experts.
  How about "ext4_journal_start_tryhard()"? I don't like "nofs" because
the fact whether we use GFP_NOFS is separate from the fact whether we are
able to handle memory allocation failure.

In fact, your patch set should keep calling kzalloc() with GFP_NOFS in all
cases to avoid new recursions into the filesystem (which could cause
deadlocks - changing that would need a separate audit if we care enough).
Just the retrying logic should be influenced by your work.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
