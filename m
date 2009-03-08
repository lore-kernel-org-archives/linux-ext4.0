From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs: fix libext2fs info page name
Date: Sun, 8 Mar 2009 19:31:19 -0400
Message-ID: <20090308233119.GC5578@mit.edu>
References: <4982331D.9070707@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Jerry James <loganjerry@gmail.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:44176 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753077AbZCIDPp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 8 Mar 2009 23:15:45 -0400
Content-Disposition: inline
In-Reply-To: <4982331D.9070707@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 29, 2009 at 05:52:13PM -0500, Eric Sandeen wrote:
> In Red Hat bug #481620 Jerry reported that the libext2fs info page
> is not accesable via "info libext2fs" but is via "info libext2fs.info"
> and suggested that the following change should fix it.

Thanks, applied.

						- Ted
