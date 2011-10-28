From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH] ext4: fix BUG_ON() in ext4_ext_insert_extent()
Date: Fri, 28 Oct 2011 10:36:08 +0800
Message-ID: <20111028023607.GA23772@gmail.com>
References: <20110927193523.GB3309@thunk.org>
 <1317206703-5604-1-git-send-email-tm@tao.ma>
 <20111027094329.GB31921@thunk.org>
 <20111027115322.GB6379@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Ts'o <tytso@mit.edu>, Tao Ma <tm@tao.ma>,
	linux-ext4@vger.kernel.org,
	Xiaoyun Mao <xiaoyun.maoxy@aliyun-inc.com>,
	Yingbin Wang <yingbin.wangyb@aliyun-inc.com>,
	Jia Wan <jia.wanj@aliyun-inc.com>
To: Greg KH <greg@kroah.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38619 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853Ab1J1CfE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 27 Oct 2011 22:35:04 -0400
Received: by iaby12 with SMTP id y12so3563968iab.19
        for <linux-ext4@vger.kernel.org>; Thu, 27 Oct 2011 19:35:03 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20111027115322.GB6379@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 27, 2011 at 01:53:22PM +0200, Greg KH wrote:
> On Thu, Oct 27, 2011 at 05:43:29AM -0400, Ted Ts'o wrote:
> > On Wed, Sep 28, 2011 at 06:45:03PM +0800, Tao Ma wrote:
> > > actually this bug does show up in 2.6.39 and I think stable tree still
> > > needs this fix. After some careful test, my colleague has generated
> > > the patch. Please considering ack it so that Greg can add it into the
> > > stable tree.
> > 
> > Sorry for the delay, but yes.  This patch would be good for the stable
> > tree for 2.6.39 (if Greg is still accepting patches for
> > 2.6.39-stable).  It doesn't apply for upstream ext4 since the code has
> > been changed/refactored since then, but it's a good fix.
> 
> No, .39 has not been maintained for quite some time now, sorry.
Hi Greg,

Thank you for your attention. Actually this bug is between from .32 to
.39. Please considering to apply this patch to other stable or longterm
trees.

regards,
Zheng
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
