From: tytso@mit.edu
Subject: Re: [PATCH] ext4: stop issuing discards if not supported by device
Date: Wed, 7 Apr 2010 20:58:12 -0400
Message-ID: <20100408005812.GA23188@thunk.org>
References: <4B97CEAB.1040004@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:32914 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758205Ab0DHA6O (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 Apr 2010 20:58:14 -0400
Content-Disposition: inline
In-Reply-To: <4B97CEAB.1040004@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 10, 2010 at 10:54:03AM -0600, Eric Sandeen wrote:
> Turn off issuance of discard requests if the device does
> not support it - similar to the action we take for barriers.
> This will save a little computation time if a non-discardable
> device is mounted with -o discard, and also makes it obvious
> that it's not doing what was asked at mount time ...
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Added to the ext4 patch queue, thanks.

					- Ted
