From: Mark Fasheh <mfasheh@suse.de>
Subject: Re: [Ocfs2-devel] [RFC PATCH] ext3, ext4, ocfs2: remove unused
	macro NAMEI_RA_INDEX
Date: Tue, 18 Dec 2012 15:26:50 -0800
Message-ID: <20121218232650.GA13017@wotan.suse.de>
References: <1355820999-27972-1-git-send-email-yan@linux.vnet.ibm.com> <20121218174811.GC5987@quack.suse.cz>
Reply-To: Mark Fasheh <mfasheh@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Guo Chao <yan@linux.vnet.ibm.com>, Theodore Ts'o <tytso@mit.edu>,
	akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
	ocfs2-devel@oss.oracle.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35244 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753683Ab2LRX0x (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 18 Dec 2012 18:26:53 -0500
Content-Disposition: inline
In-Reply-To: <20121218174811.GC5987@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 18, 2012 at 06:48:11PM +0100, Jan Kara wrote:
> On Tue 18-12-12 16:56:39, Guo Chao wrote:
> > This macro, initially introduced by ext2 in v0.99.15, does not
> > have any users from the beginning. It has been removed in later
> > ext2 version but still remains in the code of ext3, ext4, ocfs2.
> > Remove this macro there.
>   Thanks. I've merged the patch into my tree. Since it's trivial, I guess
> other fs maintainers won't mind.

Looks good, thanks!

Acked-by: Mark Fasheh <mfasheh@suse.de>
	--Mark

--
Mark Fasheh
