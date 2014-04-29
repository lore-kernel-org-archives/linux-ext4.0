From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] resize2fs: fix overly-pessimistic calculation of minimum
 size required
Date: Tue, 29 Apr 2014 13:30:18 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1404291326020.2183@localhost.localdomain>
References: <1398566894-14576-1-git-send-email-tytso@mit.edu> <20140427043537.GC25172@thunk.org> <87sioxdi01.fsf@openvz.org> <20140428114755.GC15379@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Dmitry Monakhov <dmonakhov@openvz.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22689 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751727AbaD2LrD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Apr 2014 07:47:03 -0400
In-Reply-To: <20140428114755.GC15379@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 28 Apr 2014, Theodore Ts'o wrote:

> Date: Mon, 28 Apr 2014 07:47:55 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Dmitry Monakhov <dmonakhov@openvz.org>
> Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
> Subject: Re: [PATCH] resize2fs: fix overly-pessimistic calculation of minimum
>     size required
> 
> On Mon, Apr 28, 2014 at 11:34:54AM +0400, Dmitry Monakhov wrote:
> > > I'm going to have to self-NACK this.  This patch causes the resize2fs
> > > regression tests to fail.  (In fact, Dmitry's original patch also
> > > causes the resize2fs regression tests to fail.)
> >
> > Agree, regressions are not acceptable. Can you please spacify
> > which tests are failed. As far as i know xfstetsts has no tests
> > for resize2fs.
> 
> It was 2 of the tests from e2fsprogs's "make check", where off-one
> resize2fs regression tests belong.  The xfstests suite is a good place
> to test on-line resize functionality, where the bulk of the code that
> has to function correctly is in the kernel,, but for testing
> functionality which is specific to e2fsprogs, it's better to test it
> within the context of e2fsprogs's regression tests.

While xfstests is definitely a good place for online resize test, I
do not see any reason not to put some offline resize tests into
xfstests as well. If nothing it is run more often and by much more
people than e2fsprogs tests.

Currently AFAICT we only have one resize2fs test in xfstests.

Thanks!
-Lukas

> 
> Anyway, the patch set I sent out fixes up the problem.
> 
> 	    	      	     	       	  - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
