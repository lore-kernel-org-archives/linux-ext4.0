From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] properly show journal checksum/async options
Date: Sat, 20 Sep 2008 18:06:47 -0400
Message-ID: <20080920220647.GA9088@mit.edu>
References: <48CD7FC3.4050807@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:51245 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751510AbYITXKa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 20 Sep 2008 19:10:30 -0400
Content-Disposition: inline
In-Reply-To: <48CD7FC3.4050807@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Sep 14, 2008 at 02:18:59PM -0700, Eric Sandeen wrote:
> The journal_checksum option is not being displayed in
> /proc/mounts ... add this to the show_options() output, but
> only if journal_async_commit is not specified, as that enables
> journal_checksum internally.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Acked-by: "Theodore Ts'o" <tytso@mit.edu>

I'll add it to the patch queue, probably combined with a patch to add
journal_sync_commit, and with a patch to make journal_async_commit the
default.

> (Aside: this reminds me that we only show non-default options
> in show_options; has there been any discussion of whether
> these should be defaults?)

Good point, thanks for raising the question.

The reason why journal_async_commit wasn't turned on by default
originally was because e2fsck didn't have support for journal
checksums before e2fsprogs 1.41.0.  At this point, it seems like
turning on async_commit is the obvious (and performant) thing to do;
any objections?

	    				- Ted
