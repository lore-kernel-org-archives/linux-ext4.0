From: Chris Ball <cjb@laptop.org>
Subject: Re: [PATCH] mke2fs: restore verbose message for BLKDISCARD
Date: Fri, 08 Mar 2013 14:08:10 -0500
Message-ID: <87vc91zp45.fsf@octavius.laptop.org>
References: <1362515118-30344-1-git-send-email-swarren@wwwdotorg.org>
	<alpine.LFD.2.00.1303060753500.24359@localhost>
	<5138EEBD.5000705@wwwdotorg.org>
	<alpine.LFD.2.00.1303080818510.24359@localhost>
	<513A1D56.1010402@wwwdotorg.org> <20130308190019.GB12008@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Stephen Warren <swarren@wwwdotorg.org>,
	=?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from void.printf.net ([89.145.121.20]:52275 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750840Ab3CHTIX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 8 Mar 2013 14:08:23 -0500
In-Reply-To: <20130308190019.GB12008@thunk.org> (Theodore Ts'o's message of
	"Fri, 8 Mar 2013 14:00:19 -0500")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

On Fri, Mar 08 2013, Theodore Ts'o wrote:
> I hate to suggest this, but there's so many crappy devices out there
> that I'm wondering if we need to figure out some way of maintaining a
> black list of devices that don't handle discard properly.

Yes, we already do that in the MMC layer.  See e.g.:

http://git.kernel.org/cgit/linux/kernel/git/cjb/mmc.git/commit/?id=3550ccdb9d8d350e526b809bf3dd92b550a74fe1
("mmc: card: Skip secure erase on MoviNAND; causes unrecoverable corruption.")

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
