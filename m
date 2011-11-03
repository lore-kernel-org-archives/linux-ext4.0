From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH] ext4: fix BUG_ON() in ext4_ext_insert_extent() for .32
 longterm
Date: Thu, 3 Nov 2011 11:06:44 +0800
Message-ID: <20111103030643.GA9967@gmail.com>
References: <20110927193523.GB3309@thunk.org>
 <1317206703-5604-1-git-send-email-tm@tao.ma>
 <20111027094329.GB31921@thunk.org>
 <20111027115322.GB6379@kroah.com>
 <20111028023607.GA23772@gmail.com>
 <20111028052406.GA21306@kroah.com>
 <20111028084652.GA25104@gmail.com>
 <20111028090759.GA22822@kroah.com>
 <20111028123402.GA26003@gmail.com>
 <20111102210024.GA9949@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Ts'o <tytso@mit.edu>, Tao Ma <tm@tao.ma>,
	linux-ext4@vger.kernel.org,
	Xiaoyun Mao <xiaoyun.maoxy@aliyun-inc.com>,
	Yingbin Wang <yingbin.wangyb@aliyun-inc.com>,
	Jia Wan <jia.wanj@aliyun-inc.com>
To: Greg KH <greg@kroah.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48582 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754670Ab1KCDFZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Nov 2011 23:05:25 -0400
Received: by iage36 with SMTP id e36so828259iag.19
        for <linux-ext4@vger.kernel.org>; Wed, 02 Nov 2011 20:05:24 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20111102210024.GA9949@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 02, 2011 at 02:00:24PM -0700, Greg KH wrote:
[snip]
> 
> Sorry for dragging this out, but what commit id does this correspond to
> in Linus's tree?  I can't seem to figure it out.
> 
> Or does it not correspond to anything?  If so, I need a sentence that
> says why it doesn't for the patch changelog.

Hi Greg,

This patch doesn't apply for upstream because the code has been
refactored since 3.0.

Regards,
Zheng

> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
