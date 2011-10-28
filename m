From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] ext4: fix BUG_ON() in ext4_ext_insert_extent()
Date: Fri, 28 Oct 2011 07:24:06 +0200
Message-ID: <20111028052406.GA21306@kroah.com>
References: <20110927193523.GB3309@thunk.org>
 <1317206703-5604-1-git-send-email-tm@tao.ma>
 <20111027094329.GB31921@thunk.org>
 <20111027115322.GB6379@kroah.com>
 <20111028023607.GA23772@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Ted Ts'o <tytso@mit.edu>, Tao Ma <tm@tao.ma>,
	linux-ext4@vger.kernel.org,
	Xiaoyun Mao <xiaoyun.maoxy@aliyun-inc.com>,
	Yingbin Wang <yingbin.wangyb@aliyun-inc.com>,
	Jia Wan <jia.wanj@
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:34456 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750826Ab1J1F2I (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 28 Oct 2011 01:28:08 -0400
Content-Disposition: inline
In-Reply-To: <20111028023607.GA23772@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 28, 2011 at 10:36:08AM +0800, Zheng Liu wrote:
> On Thu, Oct 27, 2011 at 01:53:22PM +0200, Greg KH wrote:
> > On Thu, Oct 27, 2011 at 05:43:29AM -0400, Ted Ts'o wrote:
> > > On Wed, Sep 28, 2011 at 06:45:03PM +0800, Tao Ma wrote:
> > > > actually this bug does show up in 2.6.39 and I think stable tree still
> > > > needs this fix. After some careful test, my colleague has generated
> > > > the patch. Please considering ack it so that Greg can add it into the
> > > > stable tree.
> > > 
> > > Sorry for the delay, but yes.  This patch would be good for the stable
> > > tree for 2.6.39 (if Greg is still accepting patches for
> > > 2.6.39-stable).  It doesn't apply for upstream ext4 since the code has
> > > been changed/refactored since then, but it's a good fix.
> > 
> > No, .39 has not been maintained for quite some time now, sorry.
> Hi Greg,
> 
> Thank you for your attention. Actually this bug is between from .32 to
> .39. Please considering to apply this patch to other stable or longterm
> trees.

Ah, ok, that makes sense, can you provide me a patch that will apply to
the .32 and .33-longterm kernels?

thanks,

greg k-h
