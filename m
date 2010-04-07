From: tytso@mit.edu
Subject: Re: [PATCH] ext4: BUG_ON triggered in ext4_mb_complex_scan_group()
Date: Wed, 7 Apr 2010 11:31:05 -0400
Message-ID: <20100407153105.GR23670@thunk.org>
References: <m2uac8f92701004042130o76a81f3az89d538ebe0afea31@mail.gmail.com>
 <4BB968B6.1060005@redhat.com>
 <i2gac8f92701004042201gbe239f33la21b31828752fd3c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	"Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>,
	Andreas Dilger <adilger@sun.com>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: jing zhang <zj.barak@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:52181 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932581Ab0DGP4n (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 Apr 2010 11:56:43 -0400
Content-Disposition: inline
In-Reply-To: <i2gac8f92701004042201gbe239f33la21b31828752fd3c@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 05, 2010 at 01:01:31PM +0800, jing zhang wrote:
> 2010/4/5, Eric Sandeen <sandeen@redhat.com>:
> > jing zhang wrote:
> >> From: Jing Zhang <zj.barak@gmail.com>
> >>
> >> Date: Mon Apr 5 12:10:50     2010
> >>
> >> BUG_ON is triggered at [line:1762] in ext4_mb_complex_scan_group(),
> >
> > Do you have a test case which can trigger this BUG_ON?
> >
> > -Eric
> 
> No I do not have.
> 
> But you can check [line: 1762] and [line: 1321].
> 
> And please info me the result, if you like, after check.

Again, line numbers make it hard to determine what you're talking
about.  And we need a scenario description that might trigger this.
If you can't give it, then my fear is that you don't understand how
the code is used, in which case the risk is extremely high that that
your patch will not be correct, and may in fact may make things worse.

I could spend time trying to reverse engineer the scenario where this
might happen, but the fact of the matter is, no one has reported these
BUG_ON's ever triggering as far as I know.  So when I have free time,
I might get back to looking for them.  Otherwise, I have higher
priority things to work on, and it's going to be up to you to pursuade
me that this could actually happen in real life, and how.

Best regards,

					- Ted
