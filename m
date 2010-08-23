From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH] mke2fs: use lazy inode init on some discard-able devices
Date: Mon, 23 Aug 2010 06:49:22 -0400
Message-ID: <D416033E-58F9-46F8-B8B0-546C949CB6BE@mit.edu>
References: <4C6EF67A.5080502@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-7.MIT.EDU ([18.7.68.36]:55013 "EHLO
	dmz-mailsec-scanner-7.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750725Ab0HWKy0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Aug 2010 06:54:26 -0400
In-Reply-To: <4C6EF67A.5080502@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Aug 20, 2010, at 5:41 PM, Eric Sandeen wrote:

> If a device supports discard -and- returns 0s for discarded blocks,
> then we can skip the inode table initialization -and- the inode table
> zeroing at mkfs time, and skip the lazy init as well since they are
> already zeroed out.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

This needs to be configurable in /etc/mke2fs.conf.  Without naming
the manufacturer, I'm aware of at least one device which claims 
that discard works, and will even return zeros --- but after a
power cycle, if the block has not been reallocated, will once again
return the old, pre-discard values that had been stored in that block.

In other words, the discard is not power-cycle persistent...

-- Ted


