From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: possible unintended integer truncation in
 fs/ext4/extents.c:get_implied_cluster_alloc
Date: Fri, 20 Dec 2013 00:12:56 -0500
Message-ID: <20131220051256.GD23508@thunk.org>
References: <52ACDBBE.32014.145F911E@pageexec.freemail.hu>
 <20131220045920.GB23508@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, re.emese@gmail.com
To: PaX Team <pageexec@freemail.hu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41878 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752502Ab3LTFM7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 Dec 2013 00:12:59 -0500
Content-Disposition: inline
In-Reply-To: <20131220045920.GB23508@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 19, 2013 at 11:59:20PM -0500, Theodore Ts'o wrote:
> So C's integer promotion and sign extension rules are very obscure and
> confusing, and that may be a reason why we should put in an explicit
> cast, but it looks like the right thing is happening here.  Here's a
> test program --- what am I missing?

Never mind, I see the problem.  It works if cr is a short, but not if
it is an unsigned int.  Sigh...

 					- Ted
