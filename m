From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 01/10] Fs: ext4: acl.c: fixed indent issue
Date: Sat, 25 Sep 2010 22:10:30 -0400
Message-ID: <20100926021030.GJ19690@thunk.org>
References: <AANLkTimf9Q=jfga=--H0VaZeWnbAVNhCPMn_G81sZ8vh@mail.gmail.com>
 <20100925235643.GA3224@lst.de>
 <20100926000154.GB5299@thunk.org>
 <1285459769.6115.74.camel@Joe-Laptop>
 <20100926003255.GA19690@thunk.org>
 <1285462243.6115.89.camel@Joe-Laptop>
 <20100926010410.GC19690@thunk.org>
 <1285464746.6115.108.camel@Joe-Laptop>
 <20100926015328.GI19690@thunk.org>
 <1285466591.6115.117.camel@Joe-Laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andy Whitcroft <apw@canonical.com>, Christoph Hellwig <hch@lst.de>,
	T Dent <tdent48227@gmail.com>, adilger.kernel@dilger.ca,
	jack@suse.cz, dmonakhov@openvz.org, sandeen@redhat.com,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Joe Perches <joe@perches.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:58883 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756087Ab0IZCKk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 25 Sep 2010 22:10:40 -0400
Content-Disposition: inline
In-Reply-To: <1285466591.6115.117.camel@Joe-Laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Sep 25, 2010 at 07:03:11PM -0700, Joe Perches wrote:
> 
> When you define "it" that way, not as any simple
> file pattern match, but as a control for what
> 	"git log -- path"
> to inspect,  it's quite feasible to use the pattern
> match rather than the file name.
> 
> So, thanks, that's a good suggestion.

Don't make it an option, though.  If you must use hueristics, then at
least *try* to make the hueristics smarter.  If the file name falls
into certain patterns, such as:

     fs/*/*.[ch]
     drivers/scsi/*/*.[ch]
     drivers/net/*/*.[ch]

etc., then you really should be doing the analysis by subdirectory,
and not by file.

> > I don't believe get_maintainers.pl does have legitmate use, since it's
> > really not that hard to look up something in MAINTAINERS, and if it's
> > not there, some real human judgement is needed, and not hueristic
> > guessing --- or at the very least, the script needs to warn that it's
> > guessing, and maybe explain to the user in detail why it's making the
> > guesses that it's making, so the user has a chance of understanding
> > why it might be completely wrong.
> 
> Multiple warning labels on tools tend to get ignored.
> People that use tools without training tend to get injured.

There's something very simple you can do that would help.  Don't make
it easy for people to do

   mail $(./get_maintainer.pl) < annoying-e-mail

Instead have get_maintainer.pl always be very verbose, and have it
*explain* what it is doing, so that in order for someone to use the
damn thing, they have to read the text while they are finding the
e-mail address to cut and paste out of its output.

I really dislike training people that using dumb scripts is a good
idea.  Tools like that just plain shouldn't exist, if they are that
subject to error.  If you can clean up the tool to the point where the
error rate is manageable, maybe, perhaps.

But what was shipped as part of 2.6.35 was really, really, *REALLY*
bad.  It makes me wonder how much testing someone did with the
hueristics before turning it loose for the newbies to use.

	   	  	     	       	   - Ted
