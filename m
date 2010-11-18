From: Jan Kara <jack@suse.cz>
Subject: Re: Batched discard for ext3
Date: Fri, 19 Nov 2010 00:41:01 +0100
Message-ID: <20101118234101.GC5004@quack.suse.cz>
References: <alpine.LFD.2.00.1011181512530.15886@dhcp-lab-213.englab.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4 <linux-ext4@vger.kernel.org>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34272 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755887Ab0KRXlC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Nov 2010 18:41:02 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1011181512530.15886@dhcp-lab-213.englab.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi!

On Thu 18-11-10 15:16:06, Lukas Czerner wrote:
> now, when batched discard is in ext4, do you plan to include it into
> ext3 as well ? If yes, I would need to revisit my previous ext3 patches
> since it was a long time from my previous post. Please let me know.
  Ah, I forgot. Thanks for reminder. Please just send me the latest version
and I'll merge patches in the next merge window.

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
