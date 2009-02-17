From: Greg KH <greg@kroah.com>
Subject: Re: [stable] [cebbert@redhat.com: Re: Ext4 tree backports for
	2.6.27.13 and 2.6.28.2]
Date: Mon, 16 Feb 2009 19:15:21 -0800
Message-ID: <20090217031521.GB8343@kroah.com>
References: <20090216230104.GG23758@mini-me.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Tso <tytso@mit.edu>, stable@kernel.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:35475 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750859AbZBQDXs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Feb 2009 22:23:48 -0500
Content-Disposition: inline
In-Reply-To: <20090216230104.GG23758@mini-me.lan>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 16, 2009 at 06:01:04PM -0500, Theodore Tso wrote:
> Hi,
> 
> Can you please include the patches found in the for-stable and
> for-stable-2.6.27 branches at:
> 
> 	  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git
> 
> into the next 2.6.28.y and 2.6.27.y kernels, respectively?
> 
> Or do you need me to send them in e-mail format via git
> format-patch/git send-email?  I can do that too if you prefer that.

Yes, please do that, it makes it much easier for our scripts to handle
them that way.

thanks,

greg k-h
