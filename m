From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] ext4: fix BUG_ON() in ext4_ext_insert_extent()
Date: Thu, 27 Oct 2011 13:53:22 +0200
Message-ID: <20111027115322.GB6379@kroah.com>
References: <20110927193523.GB3309@thunk.org>
 <1317206703-5604-1-git-send-email-tm@tao.ma>
 <20111027094329.GB31921@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tao Ma <tm@tao.ma>, linux-ext4@vger.kernel.org,
	Xiaoyun Mao <xiaoyun.maoxy@aliyun-inc.com>,
	Yingbin Wang <yingbin.wangyb@aliyun-inc.com>,
	Jia Wan <jia.wanj@aliyun-inc.com>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:37477 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754248Ab1J0MAp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 27 Oct 2011 08:00:45 -0400
Content-Disposition: inline
In-Reply-To: <20111027094329.GB31921@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 27, 2011 at 05:43:29AM -0400, Ted Ts'o wrote:
> On Wed, Sep 28, 2011 at 06:45:03PM +0800, Tao Ma wrote:
> > actually this bug does show up in 2.6.39 and I think stable tree still
> > needs this fix. After some careful test, my colleague has generated
> > the patch. Please considering ack it so that Greg can add it into the
> > stable tree.
> 
> Sorry for the delay, but yes.  This patch would be good for the stable
> tree for 2.6.39 (if Greg is still accepting patches for
> 2.6.39-stable).  It doesn't apply for upstream ext4 since the code has
> been changed/refactored since then, but it's a good fix.

No, .39 has not been maintained for quite some time now, sorry.

greg k-h
