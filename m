From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: don't pass entire map to check_eofblocks_fl
Date: Mon, 10 Jan 2011 13:13:02 -0500
Message-ID: <20110110181302.GE3128@thunk.org>
References: <4D2B47FB.1040909@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:50261 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753358Ab1AJSNG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 10 Jan 2011 13:13:06 -0500
Content-Disposition: inline
In-Reply-To: <4D2B47FB.1040909@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 10, 2011 at 11:55:07AM -0600, Eric Sandeen wrote:
> 
> Since check_eofblocks_fl() only uses the m_lblk portion of
> the map structure, we may as well pass that directly, rather
> than passing the entire map, which IMHO obfuscates what
> parameters check_eofblocks_fl() cares about.  Not a big
> deal, but seems tidier and less confusing, to me.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Thanks, added to the ext4 patch queue.

						- Ted
