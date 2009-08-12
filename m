From: Valerie Aurora <vaurora@redhat.com>
Subject: Re: >16TB issues
Date: Wed, 12 Aug 2009 13:59:17 -0400
Message-ID: <20090812175916.GE11100@shell>
References: <20090721161018.GH4231@webber.adilger.int> <150c16850907211152y3136aadx6ce42a8535a6ed61@mail.gmail.com> <20090721192123.GK4231@webber.adilger.int> <150c16850907221527l3060aa85h883656bcc7d7e1c4@mail.gmail.com> <20090730222349.GC31141@shell> <150c16850907311824n71e36f66i86b508bc25d0c4bb@mail.gmail.com> <20090811213947.GA11100@shell> <20090811220511.GC31342@mit.edu> <20090812012538.GD11100@shell> <20090812020439.GE31342@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Justin Maggard <jmaggard10@gmail.com>,
	Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org,
	Nick Dokos <nicholas.dokos@hp.com>,
	Julia Lawall <julia@diku.dk>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:43421 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754754AbZHLScN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Aug 2009 14:32:13 -0400
Content-Disposition: inline
In-Reply-To: <20090812020439.GE31342@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

(Removing Jose from the cc list - his email at IBM is bouncing.)

On Tue, Aug 11, 2009 at 10:04:39PM -0400, Theodore Tso wrote:
> Just to be clear, since it's not clear from me what you said here:
> 
> On Tue, Aug 11, 2009 at 05:39:48PM -0400, Valerie Aurora wrote:
> > By the way, I'm just waiting for Ted's rebase/rewrite of the 64-bit
> > patches to try reproducing and fixing this bug.
> 
> Vs. a few hours later:
> 
> On Tue, Aug 11, 2009 at 09:25:39PM -0400, Valerie Aurora wrote:
> > I am going to stop tracking and fixing 64 bit bugs now.  I stopped
> > actively working on this project in February but wanted to follow up
> > on bugs for a few months.  This is the only outstanding bug report I
> > know of (I'm sure there are more!).
> 
> Are you going to try to reproduce and fix this bug or not?

I didn't realize this wouldn't be clear, but the second email does
override the first.  I won't be trying to reproduce and fix this
particular bug (more likely, set of bugs).

I'm stepping back from tracking bugs in this patch set for a couple of
reasons.  First, I've used all the time allocated for this project for
me by Red Hat.  I am now working on other projects, union mounts at
present, and btrfs utilities next.  Second, you're now the most active
developer on this feature, and the overhead of trying to synchronize
between two developers is far more than the benefit I can contribute.
I feel the project is in good hands now.

I will of course be happy to assist other people working on bugs in
the 64 bit patches, I just won't be taking the lead in tracking and
fixing them.  I'm also happy to answer questions, do code review, help
with spatch scripts, etc. - again, just not taking the lead since I'm
not the lead developer.

-VAL
