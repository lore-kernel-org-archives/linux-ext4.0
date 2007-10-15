From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 01/13][e2fsprogs] Add initial checksum support.
Date: Mon, 15 Oct 2007 07:55:56 -0400
Message-ID: <20071015115556.GC21216@thunk.org>
References: <20071011191559.4599.69332.stgit@gara> <20071011191605.4599.34407.stgit@gara> <20071015024605.GA21216@thunk.org> <20071015044306.41a6448e@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:35761 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753761AbXJOL43 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Oct 2007 07:56:29 -0400
Content-Disposition: inline
In-Reply-To: <20071015044306.41a6448e@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Oct 15, 2007 at 04:43:06AM -0500, Jose R. Santos wrote:
> Yes, I notice the use of linux/types.h as well.  I already have this
> fixed on my patch queue and Im in the process of cleaning some of the
> other patches as well.

Ok, I'll wait for you to fix this, instead of futzing with the patch
queues to get it to compile for me.

BTW, not that it should be a big deal for me to rebase, but if you
rebase your patches against the "next" branch in e2fsprogs.git, you'll
save me a tiny bit of work.

						- Ted
