From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: e2fsck not fixing all corruptions on the first run?
Date: Thu, 13 Mar 2008 22:59:55 +0100 (CET)
Message-ID: <alpine.DEB.1.00.0803132255230.7433@sheep.housecafe.de>
References: <alpine.DEB.1.00.0803131923420.7433@sheep.housecafe.de> <20080313205426.GD28728@mit.edu> <alpine.DEB.1.00.0803132219590.7433@sheep.housecafe.de> <20080313214731.GE28728@mit.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns2.g-housing.de ([81.169.133.75]:60109 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757233AbYCMV76 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Mar 2008 17:59:58 -0400
In-Reply-To: <20080313214731.GE28728@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 13 Mar 2008, Theodore Tso wrote:
> Oh, right.  Sorry, I missed that.  I think I know what's going on.
> The problem is we're not supporting long symlinks which are in extents
> format.  That's something which we changed, but we're going to change
> back (since we need it to support filesystems with > 2**32 blocks).

When you say "changed", you mean the on-disk format changed? If so, I 
could (should?) just mkfs again, since ext4 is in flux anyway and nobody 
said the on-disk format was frozen. IOW, I don't know if it's wise to put 
in quirks just because of some old test-environment. When ext4 is 
(offically) released, everybody will have the "right" format and e2fsck 
will work as expected, no?

thanks,
C.
-- 
BOFH excuse #441:

Hash table has woodworm
