From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: e2fsck (git) on ext4: unsupported feature(s): huge_file
Date: Wed, 9 Apr 2008 00:40:07 +0200 (CEST)
Message-ID: <alpine.DEB.1.10.0804090032480.3869@sheep.housecafe.de>
References: <47FBB24D.90807@yahoo.de> <47FBBB59.3020506@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: supersud501 <supersud501@yahoo.de>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns2.g-housing.de ([81.169.133.75]:43214 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751758AbYDHWkQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Apr 2008 18:40:16 -0400
In-Reply-To: <47FBBB59.3020506@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 8 Apr 2008, Eric Sandeen wrote:
> Oh, and for what it's worth, fsck support for ext4 is incomplete, even
> in git.

"Incomplete", but usable I may add. I've had a few (I/O related) crashes 
and ext4 told me that running e2fsck was recommended. I did several times 
and it went ok.

> That accounts for lots of the "dev" part in "ext4dev."

Yeah, I won't argue with that statement :)

my 2 cents...
C.
-- 
BOFH excuse #24:

network packets travelling uphill (use a carrier pigeon)
