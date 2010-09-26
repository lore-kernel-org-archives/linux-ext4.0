From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 01/10] Fs: ext4: acl.c: fixed indent issue
Date: Sat, 25 Sep 2010 21:04:11 -0400
Message-ID: <20100926010410.GC19690@thunk.org>
References: <1285439521-2557-1-git-send-email-tdent48227@gmail.com>
 <20100925233600.GA2854@lst.de>
 <AANLkTimf9Q=jfga=--H0VaZeWnbAVNhCPMn_G81sZ8vh@mail.gmail.com>
 <20100925235643.GA3224@lst.de>
 <20100926000154.GB5299@thunk.org>
 <1285459769.6115.74.camel@Joe-Laptop>
 <20100926003255.GA19690@thunk.org>
 <1285462243.6115.89.camel@Joe-Laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@lst.de>, T Dent <tdent48227@gmail.com>,
	adilger.kernel@dilger.ca, jack@suse.cz, dmonakhov@openvz.org,
	sandeen@redhat.com, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Joe Perches <joe@perches.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:51261 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754013Ab0IZBES (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 25 Sep 2010 21:04:18 -0400
Content-Disposition: inline
In-Reply-To: <1285462243.6115.89.camel@Joe-Laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Sep 25, 2010 at 05:50:43PM -0700, Joe Perches wrote:
> The reason get_maintainers by default cc'd signers is mostly
> historical.  The file pattern coverage in MAINTAINERS when
> it was added wasn't very good, so signers were always added.
> It was also the Linus' preferred mechanism to find those
> "who really do the work".
> 
> http://lkml.org/lkml/2007/8/14/276

Yeah, but Linus said "subdirectory or file".  He was also assuming
some human intelligence.  In the case of a filesystem, you should use
who has done most of the work in the *subdirectory*, and not on a
file-by-file basis.  The brokeness is trying to do this in blind and
stupid script, that can't understand the difference between when you
should use subdirectory or a file.

This is what caused the completely insane result for fs/ext4/acl.c.
There have only been three commits in the past year, and they have all
been random folks who were doing random fixups --- many of which might
be stylistic cleanups.  That's not "the people who really do the
work".  It's just "the people who happened to do some random cleanups
on a file that happens not to change much".  But the stupid thing is
trying to do it on a file-by-file basis in the first place, when for
something like fs/ext4, it really should be done on a subdirectory
basis.

That, BTW, is also my biggest complaint about checkpatch.pl.  If it's
used by newbies who want to get warned about obvious things, that's
fine.  If it's used by maintainers as an automated way to catch nits,
that's also fine.  Maintainers are experts who know when it's OK to
disregard flase positives.

What really annoys me is newbies who use checkpatch.pl in its --file
mode, and then assume that every single warning is a deadly bug that
much be patched.  Scripts by definitions are stupid, and don't
substitute for thinking.  checkpatch.pl at least as the excuse that it
has some valid non-stupid uses.  But I'm not convinced
get_maintainers.pl has the same excuse.  

I at least never use it.  I'll look through the MAINTAINERS file by
hand, or I'll use git log by hand, and let my human intelligence
figure out whether or not the patches that are turned up constitute
"those that do real work", or are bullshit checkpatch.pl cleanup
patches.  Training people to use a script that by defintion can't be
smart enough to make these distinction ultimately is a huge disservice
to newbies (and experts won't use get_maintinaer.pl anyway, because
they will want to know the context).

					- Ted
