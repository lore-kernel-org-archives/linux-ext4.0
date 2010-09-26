From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 01/10] Fs: ext4: acl.c: fixed indent issue
Date: Sat, 25 Sep 2010 19:29:52 -0700
Message-ID: <1285468192.6115.131.camel@Joe-Laptop>
References: <AANLkTimf9Q=jfga=--H0VaZeWnbAVNhCPMn_G81sZ8vh@mail.gmail.com>
	 <20100925235643.GA3224@lst.de> <20100926000154.GB5299@thunk.org>
	 <1285459769.6115.74.camel@Joe-Laptop> <20100926003255.GA19690@thunk.org>
	 <1285462243.6115.89.camel@Joe-Laptop> <20100926010410.GC19690@thunk.org>
	 <1285464746.6115.108.camel@Joe-Laptop> <20100926015328.GI19690@thunk.org>
	 <1285466591.6115.117.camel@Joe-Laptop>  <20100926021030.GJ19690@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Andy Whitcroft <apw@canonical.com>, Christoph Hellwig <hch@lst.de>,
	T Dent <tdent48227@gmail.com>, adilger.kernel@dilger.ca,
	jack@suse.cz, dmonakhov@openvz.org, sandeen@redhat.com,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:2417 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756196Ab0IZC3y (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 25 Sep 2010 22:29:54 -0400
In-Reply-To: <20100926021030.GJ19690@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, 2010-09-25 at 22:10 -0400, Ted Ts'o wrote:
> On Sat, Sep 25, 2010 at 07:03:11PM -0700, Joe Perches wrote:
> > When you define "it" that way, not as any simple
> > file pattern match, but as a control for what
> > 	"git log -- path"
> > to inspect,  it's quite feasible to use the pattern
> > match rather than the file name.
> > So, thanks, that's a good suggestion.
> Don't make it an option, though.  If you must use hueristics, then at
> least *try* to make the hueristics smarter.  If the file name falls
> into certain patterns, such as:
>      fs/*/*.[ch]
>      drivers/scsi/*/*.[ch]
>      drivers/net/*/*.[ch]
> etc., then you really should be doing the analysis by subdirectory,
> and not by file.
 
I think if there's an exact pattern "depth" match, then
git history should be searched by that subdirectory.

So for example:
	F:	drivers/scsi/megaraid/

A lookup for drivers/scsi/megaraid/mega_common.h (same depth,
search all commits in drivers/scsi/megaraid) now shows:

$ ./scripts/get_maintainer.pl -f drivers/scsi/megaraid/mega_common.h  --rolestats --git
Neela Syam Kolli <megaraidlinux@lsi.com> (maintainer:MEGARAID SCSI DRI...)
"James E.J. Bottomley" <James.Bottomley@suse.de> (maintainer:SCSI SUBSYSTEM,commit_signer:20/27=74%)
linux-scsi@vger.kernel.org (open list:MEGARAID SCSI DRI...)
linux-kernel@vger.kernel.org (open list)

> But what was shipped as part of 2.6.35 was really, really, *REALLY*
> bad.  It makes me wonder how much testing someone did with the
> hueristics before turning it loose for the newbies to use.
 
A fair bit with all public discussions.

It's been shipped more or less that way since 2.6.30
beginning in April, 2009.

I get annoyed when people suggest that the maintainer
of that silly script isn't responsive.

