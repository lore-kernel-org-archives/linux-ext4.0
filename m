From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/3] ext4: don't use quota reservation for speculative
	metadata blocks
Date: Mon, 12 Apr 2010 16:03:56 +0200
Message-ID: <20100412140356.GH12238@atrey.karlin.mff.cuni.cz>
References: <4BBCFD10.3030504@redhat.com> <20100412022027.GK1849@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ksp.mff.cuni.cz ([195.113.26.206]:34484 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750888Ab0DLOD5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 Apr 2010 10:03:57 -0400
Content-Disposition: inline
In-Reply-To: <20100412022027.GK1849@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> On Wed, Apr 07, 2010 at 04:45:52PM -0500, Eric Sandeen wrote:
> > Because we can badly over-reserve metadata when we
> > calculate worst-case, it complicates things for quota, since
> > we must reserve and then claim later, retry on EDQUOT, etc.
> > Quota is also a generally smaller pool than fs free blocks,
> > so this over-reservation hurts more, and more often.
> > 
> > I'm of the opinion that it's not the worst thing to allow
> > metadata to push a user slightly over quota.  This simplifies
> > the code and avoids the false quota rejections that result
> > from worst-case speculation.
> 
> This patch series looks good to me in general; Jan, it requires
> relatively minor changes to the quota system, so it would be good to
> get your Acked-by for the first two patches.  Since the changes to the
> ext4 layer are more in-depth, any objections if I carry all three
> patches in the ext4 tree?
  Yes, I'm fine with you carrying the quota patches. I've already sent
my acks.

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
