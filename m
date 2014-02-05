From: Christoph Hellwig <hch@infradead.org>
Subject: Re: ext4 stops responding, need help debugging (kernel oops 5 in
 utf8s_to_utf16s)
Date: Wed, 5 Feb 2014 04:13:01 -0800
Message-ID: <20140205121301.GA25674@infradead.org>
References: <52F2241A.3010804@lenzw.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lenz Weber <mail@lenzw.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52996 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbaBEMNE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Feb 2014 07:13:04 -0500
Content-Disposition: inline
In-Reply-To: <52F2241A.3010804@lenzw.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 05, 2014 at 12:44:26PM +0100, Lenz Weber wrote:
> Hello everyone,
> I have a NAS with an ext4 filesystem that I access using NFSv4. From
> time to time (about once in a month), the the ext4 driver crashes and I
> can't access the file system in any way until I reboot.
> 
> As I have no further experience in filesystems, maybe you can help me.
> The system is currently in "blocked" state, so I can do any experiments
> you ask me to if you need more data.
> 
> For starters, I am attaching a dmesg output, maybe this already gives
> you an idea on what might be wrong.

This is one of the Qnap trees which has horrible hacks all over the VFS
and filesystems for per-process case insensitive support and some backup
functionality using directory hardlinks.  I doubt it's supportable by
anyone including Qnap themselves.

