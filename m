From: tytso@mit.edu
Subject: Re: [PATCH 2/2] ext4: make "norecovery" an alias for "noload"
Date: Thu, 19 Nov 2009 14:32:22 -0500
Message-ID: <20091119193222.GD2099@thunk.org>
References: <4B01D66D.4050001@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:37204 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754026AbZKSUcy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Nov 2009 15:32:54 -0500
Content-Disposition: inline
In-Reply-To: <4B01D66D.4050001@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 16, 2009 at 04:47:09PM -0600, Eric Sandeen wrote:
> Users on the list recently complained about differences across
> filesystems w.r.t. how to mount without a journal replay.
> 
> In the discussion it was noted that xfs's "norecovery" option is
> perhaps more descriptively accurate than "noload," so let's make
> that an alias for ext4.
> 
> Also show this status in /proc/mounts
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Queued, thanks.

I made a minor change to Documentation/filesystems/ext4.txt to make
"norecovery" be the first option, since we seem to be treating it as
the canonical option name in ext4_show_options().

				- Ted
