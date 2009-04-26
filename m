From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/5] ext4: ext4_mark_recovery_complete() doesn't need
	to use lock_super
Date: Sun, 26 Apr 2009 07:49:04 -0400
Message-ID: <20090426114904.GA9212@infradead.org>
References: <1240717765-16572-1-git-send-email-tytso@mit.edu> <1240717765-16572-2-git-send-email-tytso@mit.edu> <1240717765-16572-3-git-send-email-tytso@mit.edu> <1240717765-16572-4-git-send-email-tytso@mit.edu> <20090426070713.GA17022@infradead.org> <20090426114608.GC10248@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Tso <tytso@mit.edu>,
	Christoph Hellwig <hch@infradead.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	A
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:34338 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074AbZDZLtE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 26 Apr 2009 07:49:04 -0400
Content-Disposition: inline
In-Reply-To: <20090426114608.GC10248@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Apr 26, 2009 at 07:46:08AM -0400, Theodore Tso wrote:
> That's true, but the patch also takes out the release/reacquire in in
> ext4_remount (which was particularly ugly, belch).

Sorry, missed the second hunk of the patch.

> So even if
> write_super gets called on an r/o filesystem (why?!?),

No good reason really.  Hopefully we'll sort all that out soon.

> we should be
> safe because remount will hold lock_super() throughout the entire
> remount operation.
> 
> We could delay this cleanup until you clean the mess with write_super,
> but I don't think it would be harmful in removing the
> lock_super()/unlock_super() pair in ext4_mark_recovery_complete(), and
> the unlock_super()/lock_super() pair in ext4_remount before then.  Am
> I missing something?

No, I was just missing the second hunk of the patch.
