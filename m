From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] mke2fs: fix man page discussion of usage type defaults
Date: Mon, 13 Oct 2014 04:19:54 -0400
Message-ID: <20141013081954.GC9738@thunk.org>
References: <20141002192451.GA2364@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49555 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752842AbaJMIUA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Oct 2014 04:20:00 -0400
Content-Disposition: inline
In-Reply-To: <20141002192451.GA2364@wallace>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 02, 2014 at 03:24:52PM -0400, Eric Whitney wrote:
> The man page description of the file system size thresholds used by
> mke2fs to select a usage type when not otherwise specified by the -T
> switch does not match the code.
> 
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>

Thanks, applied.

					- Ted
