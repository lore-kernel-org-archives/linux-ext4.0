From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] jbd2: fix wrong use of do_div
Date: Sun, 11 Jan 2009 22:36:15 -0500
Message-ID: <20090112033615.GA5798@mit.edu>
References: <1231701393.17759.30.camel@odie.local> <1231724680.3094.3.camel@odie.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Randy Dunlap <randy.dunlap@oracle.com>
To: Simon Holm =?iso-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:41276 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752069AbZALDgS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 11 Jan 2009 22:36:18 -0500
Content-Disposition: inline
In-Reply-To: <1231724680.3094.3.camel@odie.local>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks for the patch; I've queued it for testing and will push it to
Linus.

						- Ted
