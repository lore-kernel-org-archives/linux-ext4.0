From: Jan Kara <jack@suse.cz>
Subject: Re: jbd2: don't wake kjournald unnecessarily
Date: Wed, 23 Jan 2013 00:50:41 +0100
Message-ID: <20130122235041.GA7497@quack.suse.cz>
References: <CA+icZUWOvk5i+XY22xdZYuxu=Vy3fG2QxJStEgNFQVS4u55y-w@mail.gmail.com>
 <CA+icZUUzNYE9QAh_p7=ZNuvZbxRPCb9zd4k7+aW-hv34mQWz=A@mail.gmail.com>
 <20130121104733.GE5588@quack.suse.cz>
 <CA+icZUVy-=jJkRsEKmX+ZGRjiGr4wwp3pqdxuLCRHeqW_H0x9Q@mail.gmail.com>
 <CA+icZUVAP4ArN+j34GTUwMxte5DtLPJSrLmK9T6Na8Qy+aM0Rg@mail.gmail.com>
 <20130121140738.GI5588@quack.suse.cz>
 <CA+icZUXLcdnNPvA9o8d5msOQ0MkMci8mPXujLZ3zcYjYcVZ7JQ@mail.gmail.com>
 <20130121231130.GB12410@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sedat Dilek <sedat.dilek@gmail.com>, Jan Kara <jack@suse.cz>,
	Eric Sandeen <sandeen@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-next <linux-next@vger.kernel.org>, mszeredi@suse.cz
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47314 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752361Ab3AVXuo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Jan 2013 18:50:44 -0500
Content-Disposition: inline
In-Reply-To: <20130121231130.GB12410@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 21-01-13 18:11:30, Ted Tso wrote:
> On Tue, Jan 22, 2013 at 12:04:32AM +0100, Sedat Dilek wrote:
> > 
> > Beyond the FUSE/LOOP fun, will you apply this patch to your linux-next GIT tree?
> > 
> > Feel free to add...
> > 
> >      Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
> > 
> > A similiar patch for JBD went through your tree into mainline (see [1] and [2]).
> 
> I'm not at all convinced that this patch has anything to do with your
> problem.  I don't see how it could affect things, and I believe you
> mentioned that you saw the problem even with this patch applied?  (I'm
> not sure; some of your messages which you sent were hard to
> understand, and you mentioned something about trying to send messages
> when low on sleep :-).
> 
> In any case, the reason why I haven't pulled this patch into the ext4
> tree is because I was waiting for Eric and some of the performance
> team folks at Red Hat to supply some additional information about why
> this commit was making a difference in performance for a particular
> proprietary, closed source benchmark.
  Just a small correction - it was aim7 AFAIK which isn't closed source
(anymore). You can download it from SourceForge
(http://sourceforge.net/projects/aimbench/files/aim-suite7/Initial%20release/).
Now I have some reservations about what the benchmark does but historically
it has found quite a few issues for us as well.

> I'm very suspicious about applying patches under the "cargo cult"
> school of programming.  ("We don't understand why it makes a
> difference, but it seems to be good, so bombs away!" :-)
  Well, neither am I ;) But it is obvious the patch speeds up
log_start_commit() by 'a bit' (taking spinlock, disabling irqs, ...). And
apparently 'a bit' is noticeable for particular workload on a particular
machine - commit statistics Eric provided showed that clearly. I'd still be
happier if Eric also told us how much log_start_commit() calls there were
so that one could verify that 'a bit' could indeed multiply to a measurable
difference. But given how simple the patch is, I gave away after a while
and just merged it...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
