From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 08/10] debugfs: remove dead code
Date: Tue, 7 Jan 2014 12:25:48 -0500
Message-ID: <20140107172548.GE2822@thunk.org>
References: <1389106394-31898-1-git-send-email-tytso@mit.edu>
 <1389106394-31898-8-git-send-email-tytso@mit.edu>
 <52CC35FF.8000302@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46649 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752388AbaAGRZv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Jan 2014 12:25:51 -0500
Content-Disposition: inline
In-Reply-To: <52CC35FF.8000302@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 07, 2014 at 11:14:39AM -0600, Eric Sandeen wrote:
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> 
> FWIW, Darrick had already sent this as part of
> 
> "[PATCH 1/2] misc: fix resource leaks in e2fsprogs"
> 
> - but I suppose small targeted patches are better.

Whoops, I somehow managed to lose this patch in my inbox.  I see it in
patchwork, though.  I'll have to double check which of the other fixes
in his patch are still needed.

						- Ted
