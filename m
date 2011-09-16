From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 15/25] filefrag: Fix uninitialized "expected" value
Date: Fri, 16 Sep 2011 18:56:41 -0400
Message-ID: <20110916225641.GR16246@thunk.org>
References: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
 <1316206180-6375-16-git-send-email-sandeen@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56179 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756038Ab1IPW4m (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Sep 2011 18:56:42 -0400
Content-Disposition: inline
In-Reply-To: <1316206180-6375-16-git-send-email-sandeen@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 16, 2011 at 03:49:30PM -0500, Eric Sandeen wrote:
> The "count" variable is only ever set if FIBMAP is used,
> due to the -B switch, or a fiemap failure.  However,
> we use it unconditionally to calculate "expected" for
> extN files, so we can end up printing garbage.
> 
> Initialize count to 0, and unless we go through the FIBMAP
> path, expected will be 0 as well, and in that case do not
> print the message.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Applied, thanks.

					- Ted
