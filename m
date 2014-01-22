From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH -v3] Add support for new compat feature "sparse_super2"
Date: Wed, 22 Jan 2014 11:51:03 -0500
Message-ID: <20140122165103.GA11233@thunk.org>
References: <1389999248-11960-1-git-send-email-tytso@mit.edu>
 <20140122133813.GA21687@orion.maiolino.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50787 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752282AbaAVQvG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 22 Jan 2014 11:51:06 -0500
Content-Disposition: inline
In-Reply-To: <20140122133813.GA21687@orion.maiolino.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 22, 2014 at 11:38:13AM -0200, Carlos Maiolino wrote:
> Hi Ted, in which tree you based this patch?

This was based on the maint branch, since I wanted to make sure that
if we release a 1.42.10, that e2fsck can deal with file systems with
this compat feature.

I need to get an updated maint branch published, since I have a number
of fixes in my tree.  I had been busy cleaning up a lot of patches,
which I had been doing on the maint branch in my local tree.  What I
need to do is to figure out which ones I'm ready to cast into
concrete, and then move the rest into a dev brach.  I'll try to get
that done in the next day or two.

				- Ted
