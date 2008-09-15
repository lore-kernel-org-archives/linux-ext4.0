From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Ocfs2-devel] [PATCH] jbd2: Create proc entry with
	bdevname+i_ino.
Date: Mon, 15 Sep 2008 10:42:30 -0400
Message-ID: <20080915144230.GA21089@infradead.org>
References: <20080908233114.GD20100@mail.oracle.com> <20080914084003.GP4563@wotan.suse.de> <20080914090306.GF30537@mit.edu> <20080914160635.GA31958@infradead.org> <20080915011042.GA29193@mail.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Christoph Hellwig <hch@infradead.org>,
	Theodore Tso <tytso@MIT.EDU>, Mark Fasheh <mfasheh@suse.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	ocfs2-devel@oss.oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:42638 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394AbYIOOmd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 15 Sep 2008 10:42:33 -0400
Content-Disposition: inline
In-Reply-To: <20080915011042.GA29193@mail.oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Sep 14, 2008 at 06:10:42PM -0700, Joel Becker wrote:
> Christoph,
> 	Not sure what you mean here.  Do you mean switching over
> wholesale without the JBD compat config option?  We're currently
> tracking a spinlock deadlock in JBD2, so I don't know if we're ready for
> that.
> 	If you don't get this, I'll try to track you down tomorrow.

Sorry, not related to jbd2 in ocfs2, but the bdevname bits in this
thread.  I saw Ted posted another patch later that basically does the
same for the journal dev as the VFS does for sb->s_id so this is okay.
I still think we should do the / substitution in get_sb_bdev, too and
will send a separate patch for it.

