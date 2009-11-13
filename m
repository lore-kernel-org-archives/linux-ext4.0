From: Theodore Tso <tytso@mit.edu>
Subject: Re: Ext4 on SSD Intel X25-M
Date: Fri, 13 Nov 2009 09:13:53 -0500
Message-ID: <20091113141353.GA21183@mit.edu>
References: <4AFC14D6.7080700@diamondcut.com.br> <20091112153017.GA32122@mit.edu> <87fx8itzzo.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Renato S. Yamane" <yamane@diamondcut.com.br>,
	linux-ext4@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:53565 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753377AbZKMONz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Nov 2009 09:13:55 -0500
Content-Disposition: inline
In-Reply-To: <87fx8itzzo.fsf@basil.nowhere.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 13, 2009 at 12:39:55PM +0100, Andi Kleen wrote:
> Theodore Tso <tytso@mit.edu> writes:
> >
> > I have done a few things to reduce needless disk utilization, such as
> > using tmpfs for /tmp and configuring firefox to place its cache in
> > /tmp,
> 
> OT, but these two together seems rather pointless, could as well
> keep it in its own memory then when it's in memory anyways. That will
> be faster.

Well, technically it's not the same, since tmpfs is swappable --- but
in my case where I have 4GB of memory in my laptop and swap is
disabled (and perhaps for most users), you're right, it's probably
better to increase firefox's memory cache and disable it's disk cache
entirely.

						- Ted
