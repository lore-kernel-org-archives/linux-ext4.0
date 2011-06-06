From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH RFC 00/30] Ext4 snapshots - core patches
Date: Mon, 6 Jun 2011 16:40:28 -0400
Message-ID: <20110606204028.GD20818@thunk.org>
References: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net>
 <alpine.LFD.2.00.1106061501460.3934@dhcp-27-109.brq.redhat.com>
 <BANLkTimjxkOnX6hvLvU+Xth20ie5FaXq1A@mail.gmail.com>
 <4DECF2D5.7050408@redhat.com>
 <alpine.LFD.2.00.1106061755260.3934@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	"Amir G." <amir73il@users.sourceforge.net>,
	linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:35759 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751425Ab1FFUkd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 6 Jun 2011 16:40:33 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1106061755260.3934@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 06, 2011 at 06:05:24PM +0200, Lukas Czerner wrote:
> 
> Well, we can also start ditching some unused features and tunnables, or
> make it default and remove it from documentation so people will not use
> it and we can get rid of some of the options in the future. For examle 
> 
> orlov
> oldalloc
> bsddf
> minixdf

I tried deprecated bsddf/minixdf, and got a complaint from a user who
said they were using it.  Linus's rule is, "though shalt not break
backwards compatibility", so I have up on it.  Realistically, the
difference between these two is so small it's not really a big deal.

Dropping the old allocator is probably a good idea at this point.  I
very much doubt anyone is using it.

					- Ted
