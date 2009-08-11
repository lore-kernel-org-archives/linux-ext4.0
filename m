From: Theodore Tso <tytso@mit.edu>
Subject: Re: >16TB issues
Date: Tue, 11 Aug 2009 18:05:11 -0400
Message-ID: <20090811220511.GC31342@mit.edu>
References: <150c16850907021523p25ddae32v2eeea54418d2e6d5@mail.gmail.com> <20090703143729.GJ20343@webber.adilger.int> <150c16850907161104j5e059baep988c5f04a0552c8c@mail.gmail.com> <20090721161018.GH4231@webber.adilger.int> <150c16850907211152y3136aadx6ce42a8535a6ed61@mail.gmail.com> <20090721192123.GK4231@webber.adilger.int> <150c16850907221527l3060aa85h883656bcc7d7e1c4@mail.gmail.com> <20090730222349.GC31141@shell> <150c16850907311824n71e36f66i86b508bc25d0c4bb@mail.gmail.com> <20090811213947.GA11100@shell>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Justin Maggard <jmaggard10@gmail.com>,
	Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Valerie Aurora <vaurora@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:41697 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753877AbZHKWF0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Aug 2009 18:05:26 -0400
Content-Disposition: inline
In-Reply-To: <20090811213947.GA11100@shell>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 11, 2009 at 05:39:48PM -0400, Valerie Aurora wrote:
> On Fri, Jul 31, 2009 at 06:24:50PM -0700, Justin Maggard wrote:
> > On Thu, Jul 30, 2009 at 3:23 PM, Valerie Aurora<vaurora@redhat.com> wrote:
> > > Any chance you can give us the exact mke2fs command lines, outputs,
> > > and device sizes you are using? ?dumpe2fs -h would be bonus.
> > >
> > 
> > Sure thing.  Here's the output using an x86_64 kernel with all 32-bit userland:
> 
> By the way, I'm just waiting for Ted's rebase/rewrite of the 64-bit
> patches to try reproducing and fixing this bug.

The 'pu' branch is always kept building and has the latest 64-bit
patches.  I'm keeping it regularly rebased off of the development
branch, so feel free to reproduce the bug at any time.  There's no
need to wait until it is completely merged into the mainline e2fsprogs
sources.

							- Ted
