From: Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH] mke2fs: restore verbose message for BLKDISCARD
Date: Fri, 08 Mar 2013 13:03:41 -0700
Message-ID: <513A441D.1060706@wwwdotorg.org>
References: <1362515118-30344-1-git-send-email-swarren@wwwdotorg.org> <alpine.LFD.2.00.1303060753500.24359@localhost> <5138EEBD.5000705@wwwdotorg.org> <alpine.LFD.2.00.1303080818510.24359@localhost> <513A1D56.1010402@wwwdotorg.org> <20130308190019.GB12008@thunk.org> <87vc91zp45.fsf@octavius.laptop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>,
	=?windows-1252?Q?Luk=E1=9A_Czerner?= <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
To: Chris Ball <cjb@laptop.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from avon.wwwdotorg.org ([70.85.31.133]:50223 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281Ab3CHUDp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Mar 2013 15:03:45 -0500
In-Reply-To: <87vc91zp45.fsf@octavius.laptop.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 03/08/2013 12:08 PM, Chris Ball wrote:
> Hi,
> 
> On Fri, Mar 08 2013, Theodore Ts'o wrote:
>> I hate to suggest this, but there's so many crappy devices out there
>> that I'm wondering if we need to figure out some way of maintaining a
>> black list of devices that don't handle discard properly.
> 
> Yes, we already do that in the MMC layer.  See e.g.:
> 
> http://git.kernel.org/cgit/linux/kernel/git/cjb/mmc.git/commit/?id=3550ccdb9d8d350e526b809bf3dd92b550a74fe1
> ("mmc: card: Skip secure erase on MoviNAND; causes unrecoverable corruption.")

Unrecoverable sounds scary. Does that just mean data corruption, or a
permanently broken device? mk2e2fs -K followed by e2fsck and mounting
luckily seems to still work OK for me:-)

FWIW, my CID is 45010053454d31364790711c665f3e00, i.e. manufacturer ID
0x45, device name SEM16G.
