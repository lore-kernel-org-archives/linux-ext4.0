From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 1/2] fs-writeback: Add helper function to start
	writeback  if idle
Date: Fri, 18 Dec 2009 12:44:27 +0100
Message-ID: <20091218114427.GQ4489@kernel.dk>
References: <4B22D029.5090304@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:50955 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751367AbZLRLo2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Dec 2009 06:44:28 -0500
Content-Disposition: inline
In-Reply-To: <4B22D029.5090304@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 11 2009, Eric Sandeen wrote:
> ext4, at least, would like to start pushing on writeback if it starts
> to get close to ENOSPC when reserving worst-case blocks for delalloc
> writes.  Writing out delalloc data will convert those worst-case
> predictions into usually smaller actual usage, freeing up space
> before we hit ENOSPC based on this speculation.
> 
> Thanks to Jens for the suggestion for the helper function,
> & the naming help.
> 
> I've made the helper return status on whether writeback was
> started even though I don't plan to use it in the ext4 patch;
> it seems like it would be potentially useful to test this
> in some cases.

Eric, how do you want to merge these? I can easily take this first one
through any branch, but I suppose the ext4 one should go through the
proper ext4 channels.

-- 
Jens Axboe

