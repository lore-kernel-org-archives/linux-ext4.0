From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs: fix configure help text for quota
Date: Wed, 28 Nov 2012 23:03:23 -0500
Message-ID: <20121129040323.GA8029@thunk.org>
References: <50B504C4.6090504@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:35628 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932667Ab2K2ED2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 Nov 2012 23:03:28 -0500
Content-Disposition: inline
In-Reply-To: <50B504C4.6090504@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 27, 2012 at 12:21:56PM -0600, Eric Sandeen wrote:
> It's --enable-quota, not --enable-libquota.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Thanks, applied.

> PS it's still off by default.  Should it be?  What bugs remain?

Yeah, we probably should turn it on.  It's turned on by default in
Debian in the 1.42.x releases.  I don't know of any remaining bugs,
but at the same time, it's not gotten a lot of use to date.

       	   	      	       	      - Ted
