From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Doc fix: ext2 can only have 32,000 subdirs, not 32,768.
Date: Sat, 30 May 2009 17:13:26 -0700
Message-ID: <20090530171326.1381aa2d.akpm@linux-foundation.org>
References: <63a2e74f0905181213r54a2d8b2tb7dcecd177d474c2@mail.gmail.com>
	<20090527172045.f33b0b49.akpm@linux-foundation.org>
	<20090530113724.GA1444@ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Michael Shields <mshields@google.com>, rdunlap@xenotime.net,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	trivial@kernel.org
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41899 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753130AbZEaAOl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 30 May 2009 20:14:41 -0400
In-Reply-To: <20090530113724.GA1444@ucw.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, 30 May 2009 13:37:24 +0200 Pavel Machek <pavel@ucw.cz> wrote:

> On Wed 2009-05-27 17:20:45, Andrew Morton wrote:
> > On Mon, 18 May 2009 12:13:51 -0700
> > Michael Shields <mshields@google.com> wrote:
> > 
> > > ext2.txt says that dirs can have 32,768 subdirs, but the actual value
> > > of EXT2_LINK_MAX is 32000.
> > > ext3 is the same, but the doc does not mention it. __One of ext4's
> > > features is to "fix 32000 subdirectory limit".
> > > 
> > > --- linux-2.6.29.3/Documentation/filesystems/ext2.txt.orig 2009-05-08
> > > 15:47:21.000000000 -0700
> > > +++ linux-2.6.29.3/Documentation/filesystems/ext2.txt 2009-05-18
> > > 12:03:58.000000000 -0700
> > > @@ -322,7 +322,7 @@ an upper limit on the block size imposed
> > > __so 8kB blocks are only allowed on Alpha systems (and other architectures
> > > __which support larger pages).
> > > 
> > > -There is an upper limit of 32768 subdirectories in a single directory.
> > > +There is an upper limit of 32000 subdirectories in a single directory.
> > > 
> > > __There is a "soft" upper limit of about 10-15k files in a single directory
> > > __with the current linear linked-list directory implementation. __This limit
> > > --
> 
> Maybe it would be better to increase EXT2_LINK_MAX to fit the docs?
> 

Could be.  afacit filesystems which are created under such a driver
will still mount and work OK with older drivers.

I have this vague memory that there was a reason for the 32000 thing.

