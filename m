From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/4] vfs: vfs-level fiemap interface
Date: Mon, 15 Sep 2008 10:47:54 -0400
Message-ID: <20080915144754.GA16491@infradead.org>
References: <E1Kea9F-0004L5-Ds@closure.thunk.org> <1221331767-16870-1-git-send-email-tytso@mit.edu> <20080914134711.GA21746@infradead.org> <20080914180132.GC13074@mit.edu> <20080914180843.GA31649@infradead.org> <20080914195811.GE13074@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	akpm@linuxfoundation.org, Mark Fasheh <mfasheh@suse.com>,
	mtk.manpages@gmail.com
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54072 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbYIOOr4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 15 Sep 2008 10:47:56 -0400
Content-Disposition: inline
In-Reply-To: <20080914195811.GE13074@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Sep 14, 2008 at 03:58:11PM -0400, Theodore Tso wrote:
> On Sun, Sep 14, 2008 at 02:08:44PM -0400, Christoph Hellwig wrote:
> > Sometimes I really wish people would read email before replying to them.
> > I did not say anywhere that this flag (at least for the use case I think
> > it is which no one even bothered to document) is good, but the name
> > and description are utterly wrong, and misleading.
> 
> Want to pick a name, then?

Again, I'd love it when people would read my mails :(  Can we please
first agree on what the flag is actually supposed to mean?  I made one
guess in this mail, but I'm not sure if that's even what Andreas
intended.  And of course the description for it is even more important
than the name.

