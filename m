From: Ted Ts'o <tytso@mit.edu>
Subject: Re: mkfs.ext4 vs. e2fsck discard oddities
Date: Thu, 1 Mar 2012 09:38:34 -0500
Message-ID: <20120301143834.GA30578@thunk.org>
References: <4F4D1020.5060204@redhat.com>
 <alpine.LFD.2.00.1202290801510.4926@dhcp-27-109.brq.redhat.com>
 <34CA4C93-194F-45F3-9A94-E181A7DFEBCE@mit.edu>
 <alpine.LFD.2.00.1203010804410.6491@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40050 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750734Ab2CAOih (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 1 Mar 2012 09:38:37 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1203010804410.6491@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 01, 2012 at 08:12:44AM +0100, Lukas Czerner wrote:
> 
> actually mke2fs does discard block by default. It has been like that
> since the beginning. Back then we only had '-K' argument to 'keep'
> blocks and do not attempt to discard. Nowadays user can do '-E
> nodiscard', but it is users choice.

Ah, you're right.  The defaults had changed back and forth a couple of
times over time and I had lost track of how things had been settled
for mke2fs (which is different from e2fsck).  At least at one point it
was _not_ the default, and in fact the man page was out of sync with
the behavior of the mke2fs.

The point remains the same, though, if the file system was created
with mke2fs -E nodiscard, how do you undo that decision if there's no
way to force the discard of BLOCK_UNINIT blocks?

						- Ted
