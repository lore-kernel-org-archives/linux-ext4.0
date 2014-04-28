From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] resize2fs: fix overly-pessimistic calculation of minimum
 size required
Date: Mon, 28 Apr 2014 07:47:55 -0400
Message-ID: <20140428114755.GC15379@thunk.org>
References: <1398566894-14576-1-git-send-email-tytso@mit.edu>
 <20140427043537.GC25172@thunk.org>
 <87sioxdi01.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36958 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751916AbaD1Lr5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Apr 2014 07:47:57 -0400
Content-Disposition: inline
In-Reply-To: <87sioxdi01.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 28, 2014 at 11:34:54AM +0400, Dmitry Monakhov wrote:
> > I'm going to have to self-NACK this.  This patch causes the resize2fs
> > regression tests to fail.  (In fact, Dmitry's original patch also
> > causes the resize2fs regression tests to fail.)
>
> Agree, regressions are not acceptable. Can you please spacify
> which tests are failed. As far as i know xfstetsts has no tests
> for resize2fs.

It was 2 of the tests from e2fsprogs's "make check", where off-one
resize2fs regression tests belong.  The xfstests suite is a good place
to test on-line resize functionality, where the bulk of the code that
has to function correctly is in the kernel,, but for testing
functionality which is specific to e2fsprogs, it's better to test it
within the context of e2fsprogs's regression tests.

Anyway, the patch set I sent out fixes up the problem.

	    	      	     	       	  - Ted
