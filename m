From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] mke2fs: remove quota docs if not configured in
Date: Mon, 14 Oct 2013 09:01:39 -0400
Message-ID: <20131014130139.GG9609@thunk.org>
References: <50B504C4.6090504@redhat.com>
 <50B50804.6020309@redhat.com>
 <50B6F707.60308@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Bert.Deknuydt@esat.kuleuven.be
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45871 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756028Ab3JNNBr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Oct 2013 09:01:47 -0400
Content-Disposition: inline
In-Reply-To: <50B6F707.60308@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 28, 2012 at 11:47:51PM -0600, Eric Sandeen wrote:
> If quota isn't turned on with --enable-quota, then comment
> quota documentation out of the mke2fs manpage.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Applied, thanks.

					- Ted
