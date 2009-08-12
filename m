From: Valerie Aurora <vaurora@redhat.com>
Subject: Re: >16TB issues
Date: Tue, 11 Aug 2009 21:25:39 -0400
Message-ID: <20090812012538.GD11100@shell>
References: <20090703143729.GJ20343@webber.adilger.int> <150c16850907161104j5e059baep988c5f04a0552c8c@mail.gmail.com> <20090721161018.GH4231@webber.adilger.int> <150c16850907211152y3136aadx6ce42a8535a6ed61@mail.gmail.com> <20090721192123.GK4231@webber.adilger.int> <150c16850907221527l3060aa85h883656bcc7d7e1c4@mail.gmail.com> <20090730222349.GC31141@shell> <150c16850907311824n71e36f66i86b508bc25d0c4bb@mail.gmail.com> <20090811213947.GA11100@shell> <20090811220511.GC31342@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Justin Maggard <jmaggard10@gmail.com>,
	Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org,
	"Jose R. Santos" <jrs@us.ibm.com>,
	Nick Dokos <nicholas.dokos@hp.com>,
	Julia Lawall <julia@diku.dk>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:58259 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468AbZHLB02 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Aug 2009 21:26:28 -0400
Content-Disposition: inline
In-Reply-To: <20090811220511.GC31342@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 11, 2009 at 06:05:11PM -0400, Theodore Tso wrote:
> On Tue, Aug 11, 2009 at 05:39:48PM -0400, Valerie Aurora wrote:
> > By the way, I'm just waiting for Ted's rebase/rewrite of the 64-bit
> > patches to try reproducing and fixing this bug.
> 
> The 'pu' branch is always kept building and has the latest 64-bit
> patches.  I'm keeping it regularly rebased off of the development
> branch, so feel free to reproduce the bug at any time.  There's no
> need to wait until it is completely merged into the mainline e2fsprogs
> sources.

Oh, I wasn't waiting for a mainline merge, just for you to finish your
planned rewrites to this patch set.  I didn't realize you were done, I
must have missed an email or something.

I am going to stop tracking and fixing 64 bit bugs now.  I stopped
actively working on this project in February but wanted to follow up
on bugs for a few months.  This is the only outstanding bug report I
know of (I'm sure there are more!).

Thanks to everyone who worked on the 64 bit feature!  In particular,
Jose R. Santos for writing the first half of the 64 bit conversion,
Nick Dokos for lots of testing and bug fixes, Justin Maggard for more
testing, Andreas Dilger for code review, Julia Lawall and the
Coccinelle team for spatch, and of course, Theodore T'so for design,
rewrites, code review, merges, bug fixes, and other maintainerly
duties.

-VAL
