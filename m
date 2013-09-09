From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] resize2fs: fix interior extent node corruption
Date: Mon, 9 Sep 2013 10:48:27 -0400
Message-ID: <20130909144827.GG6059@thunk.org>
References: <52047972.5010307@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57032 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752195Ab3IIOsa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Sep 2013 10:48:30 -0400
Content-Disposition: inline
In-Reply-To: <52047972.5010307@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Applied, thanks.

> I have a testcase using fsx to create a complex extent tree which
> is then moved during resize; it hit this corruption quite easily,
> and with this fix, it succeeds.

How complex is this test case?  Is it something that we could put in
the regression tests, or is too big/unweildy?

Thanks,

						- Ted
