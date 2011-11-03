From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] ext4: fix BUG_ON() in ext4_ext_insert_extent() for .32
 longterm
Date: Thu, 3 Nov 2011 10:42:07 -0700
Message-ID: <20111103174207.GA31834@kroah.com>
References: <1317206703-5604-1-git-send-email-tm@tao.ma>
 <20111027094329.GB31921@thunk.org>
 <20111027115322.GB6379@kroah.com>
 <20111028023607.GA23772@gmail.com>
 <20111028052406.GA21306@kroah.com>
 <20111028084652.GA25104@gmail.com>
 <20111028090759.GA22822@kroah.com>
 <20111028123402.GA26003@gmail.com>
 <20111102210024.GA9949@kroah.com>
 <20111103030643.GA9967@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Ted Ts'o <tytso@mit.edu>, Tao Ma <tm@tao.ma>,
	linux-ext4@vger.kernel.org,
	Xiaoyun Mao <xiaoyun.maoxy@aliyun-inc.com>,
	Yingbin Wang <yingbin.wangyb@aliyun-inc.com>,
	Jia Wan <jia.wanj@
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:44387 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933705Ab1KCR5Y (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Nov 2011 13:57:24 -0400
Content-Disposition: inline
In-Reply-To: <20111103030643.GA9967@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 03, 2011 at 11:06:44AM +0800, Zheng Liu wrote:
> On Wed, Nov 02, 2011 at 02:00:24PM -0700, Greg KH wrote:
> [snip]
> > 
> > Sorry for dragging this out, but what commit id does this correspond to
> > in Linus's tree?  I can't seem to figure it out.
> > 
> > Or does it not correspond to anything?  If so, I need a sentence that
> > says why it doesn't for the patch changelog.
> 
> Hi Greg,
> 
> This patch doesn't apply for upstream because the code has been
> refactored since 3.0.

Thanks for letting me know, I'll go queue this up now.

greg k-h
