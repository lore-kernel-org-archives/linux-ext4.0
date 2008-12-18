From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/1] Allow ext4 to run without a journal.
Date: Thu, 18 Dec 2008 19:27:21 +0100
Message-ID: <20081218182721.GE6797@atrey.karlin.mff.cuni.cz>
References: <1228953270.14314.15.camel@bobble.smo.corp.google.com> <20081218180004.GB6797@atrey.karlin.mff.cuni.cz> <532480950812181013m76fef953s3b3fb517d708b383@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Frank Mayhar <fmayhar@google.com>, linux-ext4@vger.kernel.org
To: Michael Rubin <mrubin@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54778 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112AbYLRS1W (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Dec 2008 13:27:22 -0500
Content-Disposition: inline
In-Reply-To: <532480950812181013m76fef953s3b3fb517d708b383@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> On Thu, Dec 18, 2008 at 10:00 AM, Jan Kara <jack@suse.cz> wrote:
> >  Interesting although I'm not that surprised because those tests seem
> > to do a lot of data changes (which are never journaled in fact) and tiny
> > amount of metadata changes. If you run some benchmark doing lots of
> > directory operations, I guess the numbers would be considerably
> > different.
> 
> Actually we have some compile bench numbers (coming to this list soon)
> that also surprised us.
> The stages of compile bench that I believe are dominated by directory
> operations are also showing improvements without the journal.
  Yes, compilebench excercises directory operations quite heavily so
that is the kind of benchmark I'd be interested in :).

> > Maybe trying dbench (I know it's kind of stupid ;) or
> > postmark will show the differences better.
> 
> I admit also we see huge variance using dbench on subsequent runs. To
> the point where I don't know how much I trust it's numbers.
> Is this a tool that people on this list have a lot of faith in?
  Not really (at least as far as I'm concerned :). I had to deal with
dbench recently tracking some reported performance regression and lost
a lot of my faith in it ;). It measures something but the numbers
vary greatly and also the load it puts on the filesystem is not much
realistic (lots of rewrites of the same pages and file deletes just
after creation). I think compilebench is a better choice, I just didn't
remember its name when I was writing the email.

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
