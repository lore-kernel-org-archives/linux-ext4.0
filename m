From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Always journal quota file modifications
Date: Tue, 27 Jul 2010 09:37:04 -0400
Message-ID: <20100727133704.GB18966@thunk.org>
References: <1275488593-7237-1-git-send-email-jack@suse.cz>
 <4C323BAC.5030101@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:51192 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752661Ab0G0NhD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 Jul 2010 09:37:03 -0400
Content-Disposition: inline
In-Reply-To: <4C323BAC.5030101@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 05, 2010 at 03:08:12PM -0500, Eric Sandeen wrote:
> Jan Kara wrote:
> > When journaled quota options are not specified, we do writes
> > to quota files just in data=ordered mode. This actually causes
> > warnings from JBD2 about dirty journaled buffer because ext4_getblk
> > unconditionally treats a block allocated by it as metadata. Since
> > quota actually is filesystem metadata, the easiest way to get rid
> > of the warning is to always treat quota writes as metadata...
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> Where are we at on this one?  I was trawling through my old RH bugs
> today, and have one that this patch will resolve.  Ted, did you
> get comfortable with it?

I've added this to the ext4 patch queue.  (Going my backlog too,
before the merge window opens.  :-)

					- Ted
