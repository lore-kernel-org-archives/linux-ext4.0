From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: e2fsck not fixing all corruptions on the first run?
Date: Fri, 14 Mar 2008 08:17:02 +0100 (CET)
Message-ID: <alpine.DEB.1.00.0803140815520.7433@sheep.housecafe.de>
References: <alpine.DEB.1.00.0803131923420.7433@sheep.housecafe.de> <20080313205426.GD28728@mit.edu> <alpine.DEB.1.00.0803132219590.7433@sheep.housecafe.de> <20080313214731.GE28728@mit.edu> <alpine.DEB.1.00.0803132255230.7433@sheep.housecafe.de>
 <20080313221657.GJ28728@mit.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns2.g-housing.de ([81.169.133.75]:58994 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751491AbYCNHRG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 14 Mar 2008 03:17:06 -0400
In-Reply-To: <20080313221657.GJ28728@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 13 Mar 2008, Theodore Tso wrote:
> Technically, I guess you could say the on-disk format changed, but as
> I mentioned, it's going to change back to the original format.  It's
> not a big deal.  The question is for long symlinks, where the symlink
> can't fit in the 60 bytes in the i_block[] array, whether the block
> number should be encoded as a single integer as i_block[0], as it is
> under ext3, or whether it should be encoded as an extents structure.

Thanks again for the explanation (and for the fix, I shall try it soon)!

Christian.
-- 
BOFH excuse #399:

We are a 100% Microsoft Shop.
