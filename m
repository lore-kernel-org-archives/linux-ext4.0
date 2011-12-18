From: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: 3.2.0-rc5 NULL dereference BUG
Date: Sun, 18 Dec 2011 19:32:38 +0800
Message-ID: <20111218113237.GA1359@localhost>
References: <20111218055359.GA17182@localhost>
 <20111218063054.GA4979@localhost>
 <CAGBYx2bxdnkXcZF+A1iOvnsW=xdtDJR7Fx3Rz-HWeWH5n0ByKg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:14167 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751538Ab1LRLmm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 18 Dec 2011 06:42:42 -0500
Content-Disposition: inline
In-Reply-To: <CAGBYx2bxdnkXcZF+A1iOvnsW=xdtDJR7Fx3Rz-HWeWH5n0ByKg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Yongqiang,

Thanks for the quick fix!

On Sun, Dec 18, 2011 at 03:17:18PM +0800, Yongqiang Yang wrote:
> Hi Fengguang,
> 
> Could you try the patch [ext4: do not reference pa_inode from group_pa]?

It works! You can add my tested-by and CC stable.

Thanks,
Fengguang
