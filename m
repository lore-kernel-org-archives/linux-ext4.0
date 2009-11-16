From: Theodore Tso <tytso@mit.edu>
Subject: Re: Ext4 on SSD Intel X25-M
Date: Mon, 16 Nov 2009 13:40:03 -0500
Message-ID: <20091116184003.GA12268@mit.edu>
References: <4AFC14D6.7080700@diamondcut.com.br> <20091112153017.GA32122@mit.edu> <878wea84lq.fsf@mid.deneb.enyo.de> <4B006F8A.8000606@diamondcut.com.br> <878we7v651.fsf@mid.deneb.enyo.de> <4B00730F.5060503@redhat.com> <4B0076AD.9020008@diamondcut.com.br> <20091115221146.GH4323@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
	Florian Weimer <fw@deneb.enyo.de>
To: "Renato S. Yamane" <yamane@diamondcut.com.br>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:33077 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752181AbZKPSkF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Nov 2009 13:40:05 -0500
Content-Disposition: inline
In-Reply-To: <20091115221146.GH4323@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Nov 15, 2009 at 05:11:46PM -0500, Theodore Tso wrote:
> If you've only had the disk for a short while, then the initial writes
> to install your system is probably biasing your results.  So far you
> have approximately 19GB of disk writes.  I'm guessing that at least
> 3-4GB is from the initial installation of software on your system.

I just did a default Ubuntu Karmic x86_64 install, and it writes a
approximately ten and a half GB to the root partition.  It also (for
no explicable reason) apparently zero's out the swap partition, which
(a) takes a long time, and (b) results in useless, pointless writes to
the SSD.  Someone should complain to Ubuntu about that...  the
workaround is to not configure swap during the Ubuntu install process,
and to manually configure it yourself later.

(Or to not use swap at all, if you have enough memory in your system.)

In any case, given that means that only 8.5GB worth of data was
written to your system, so over 30 days, your usage levels is
averaging to 0.283 GB per calendar day.

						- Ted
