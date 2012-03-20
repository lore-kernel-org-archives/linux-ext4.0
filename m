From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 2/9] ext4: Use pr_fmt and pr_<level>
Date: Mon, 19 Mar 2012 18:51:12 -0700
Message-ID: <1332208272.7847.39.camel@joe2Laptop>
References: <cover.1331856299.git.joe@perches.com>
	 <ceb0e02f9f0c1548a654e8718fbadc147595f8ee.1331856300.git.joe@perches.com>
	 <20120319040950.GG31682@thunk.org> <1332131137.23125.44.camel@joe2Laptop>
	 <4F6762F1.7050902@gmail.com> <1332176943.1983.28.camel@joe2Laptop>
	 <171703.1332178579@turing-police.cc.vt.edu>
	 <1332179050.3341.7.camel@joe2Laptop> <20120320010606.GC14363@thunk.org>
	 <alpine.DEB.2.02.1203191826100.22704@asgard.lang.hm>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Ted Ts'o <tytso@mit.edu>, Valdis.Kletnieks@vt.edu,
	Jiri Slaby <jirislaby@gmail.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
To: david@lang.hm
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:50141 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754215Ab2CTBvO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Mar 2012 21:51:14 -0400
In-Reply-To: <alpine.DEB.2.02.1203191826100.22704@asgard.lang.hm>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2012-03-19 at 18:28 -0700, david@lang.hm wrote:
> On Mon, 19 Mar 2012, Ted Ts'o wrote:
> > On Mon, Mar 19, 2012 at 10:44:10AM -0700, Joe Perches wrote:
> >> This stuff ain't whitespace.
> >>> I'll have to respectfully disagree with you.  For ext4, as far as I am
> > concerned, changing printk(KERN_INFO, ...) to pr_info(...) is *purely*
> > a whitespace-level change.
> Joe, if everything did change, what difference would it make?

Hi David.

> just being a consistant style doesn't matter much,

Perhaps we disagree on the value of consistency.
I believe it's a small but measurable effect and it
can reduce overall ongoing defect rates.

Is it DoublePlus_important_?  No, definitely not.

To me using pr_<level> is a bit like using const
or marking sections devinitconst.

It hardly matters, but it's good form and it can
free up some working memory in ram limited systems.

> but if there is some 
> functionality that would be possible with pr_info(...) that would not be 
> possible with printk(KERN_INFO, ...), there may be more reason to change.

Right now, it's just macros over printk so it's pretty
trivial.  I do intend to convert pr_<level> macros to
functions eventually to reduce code size ~.5% overall.
That reduction does depend on quantity of CONFIG_<FOO>
options enabled of course.  Enable everything, I think
it's ~.01%.  I haven't done it in quite awhile though
so that's a guess.

It matters a tiny bit more for flash or ram limited
systems.

Some driver optimizations like the rtlwifi reduction
in -next commit 481b9606ec might have more of an
impact though for those systems.

So, it depends...

cheers, Joe

