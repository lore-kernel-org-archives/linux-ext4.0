From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] jbd2: Clear dirty bit in
	jbd2_journal_get_create_access() and __dispose_buffer()
Date: Mon, 13 Jul 2009 16:21:17 -0400
Message-ID: <20090713202117.GA408@mit.edu>
References: <1247513698-6415-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:56558 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756984AbZGMUVZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Jul 2009 16:21:25 -0400
Content-Disposition: inline
In-Reply-To: <1247513698-6415-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 13, 2009 at 09:34:58PM +0200, Jan Kara wrote:
> 
>   Ted, this is the new fix I was talking about and should replace the fix
> "jbd2: Clear dirty bit in jbd2_journal_get_create_access()". It makes sence to
> fold it into the patch "jbd2: Fix a race between checkpointing code and
> journal_get_write_access()" which is what I did for JBD but that's upto you.

Thanks, that's what I've done in the ext4 patch queue; I've folded
this patch into "jbd2: Fix a race between checkpointing code and
journal_get_write_access()".

						- Ted
