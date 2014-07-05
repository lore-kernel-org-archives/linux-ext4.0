From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs: add mount options to ext4.5
Date: Fri, 4 Jul 2014 23:09:58 -0400
Message-ID: <20140705030958.GG11103@thunk.org>
References: <5398BDE0.2040602@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Karel Zak <kzak@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46308 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753943AbaGEDKA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 4 Jul 2014 23:10:00 -0400
Content-Disposition: inline
In-Reply-To: <5398BDE0.2040602@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 11, 2014 at 03:36:48PM -0500, Eric Sandeen wrote:
> This is a straight cut and paste from the util-linux
> mount manpage to ext4.5 (with commented-out lines
> removed).
> 
> It's pretty much impossible for util-linux to keep up
> with every filesystem out there, and Karel has more than
> once expressed a wish that mount options move into fs-specific
> manpages.
> 
> So, here we go.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Thanks, applied.

					- Ted
