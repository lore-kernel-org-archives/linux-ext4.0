From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2 V2] e2fsprogs: reorder flags in chattr(1)
Date: Fri, 4 Jul 2014 23:05:13 -0400
Message-ID: <20140705030513.GE11103@thunk.org>
References: <53A36F0E.6090105@redhat.com>
 <53A36F9D.3010803@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46296 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753943AbaGEDFQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 4 Jul 2014 23:05:16 -0400
Content-Disposition: inline
In-Reply-To: <53A36F9D.3010803@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 19, 2014 at 06:17:49PM -0500, Eric Sandeen wrote:
> The flags described in chattr usage() and the chattr(1) manpage
> were in semi-random order, which makes it hard to ascertain
> which flags might be missing or undocumented, and to locate
> flags within the manpage.
> 
> Re-order the list of flags in alphanumeric order, and do
> the same for the flag descriptions in the body of the manpage.
> 
> There should be no content changes here, just reordering
> for consistency.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Applied, thanks.

					- Ted
