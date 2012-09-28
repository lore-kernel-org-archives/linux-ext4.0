From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 1/3] ext4: add block-based file punching hole support
Date: Fri, 28 Sep 2012 22:25:59 +0800
Message-ID: <20120928142559.GB9473@gmail.com>
References: <1345695941-15053-1-git-send-email-wenqing.lz@taobao.com>
 <1345695941-15053-2-git-send-email-wenqing.lz@taobao.com>
 <20120928131215.GB13352@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Dave Chinner <david@fromorbit.com>,
	Lukas Czerner <lczerner@redhat.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62222 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757898Ab2I1OPT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 28 Sep 2012 10:15:19 -0400
Content-Disposition: inline
In-Reply-To: <20120928131215.GB13352@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 28, 2012 at 09:12:15AM -0400, Theodore Ts'o wrote:
> On Thu, Aug 23, 2012 at 12:25:39PM +0800, Zheng Liu wrote:
> > I run xfstests to do some tests, and I got an error from xfstests #
> > 255.  The failure reason is that block-based file in ext4 cannot
> > support fallocate(2) to allocate an unwritten blocks.  I am not sure
> > whether we should change # 255 in xfstests or not.  So Cc' to Dave
> > Chinner to get some feedbacks.
> 
> Zheng,
> 
> I gave these patches a quick try and I'm seeing many more failures
> than just test #255.  Tests 75, 91, 112, 215, and 263 are also
> failing, and I don't think it's all due to punch being supported w/o
> fallocate support.

Hi Ted,

Thanks for sharing this information with me.  I will look at these
patches after patch series of extent status tree gets stable and submit
to the mailing list.

Regards,
Zheng
