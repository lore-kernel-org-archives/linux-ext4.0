From: tytso@mit.edu
Subject: Re: [PATCH 0/3] ext4: don't use quota reservation for speculative
 metadata blocks
Date: Sun, 11 Apr 2010 22:20:27 -0400
Message-ID: <20100412022027.GK1849@thunk.org>
References: <4BBCFD10.3030504@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:54147 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751784Ab0DLCUa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 11 Apr 2010 22:20:30 -0400
Content-Disposition: inline
In-Reply-To: <4BBCFD10.3030504@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 07, 2010 at 04:45:52PM -0500, Eric Sandeen wrote:
> Because we can badly over-reserve metadata when we
> calculate worst-case, it complicates things for quota, since
> we must reserve and then claim later, retry on EDQUOT, etc.
> Quota is also a generally smaller pool than fs free blocks,
> so this over-reservation hurts more, and more often.
> 
> I'm of the opinion that it's not the worst thing to allow
> metadata to push a user slightly over quota.  This simplifies
> the code and avoids the false quota rejections that result
> from worst-case speculation.

This patch series looks good to me in general; Jan, it requires
relatively minor changes to the quota system, so it would be good to
get your Acked-by for the first two patches.  Since the changes to the
ext4 layer are more in-depth, any objections if I carry all three
patches in the ext4 tree?

					- Ted
