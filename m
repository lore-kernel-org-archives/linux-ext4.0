From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 10/10 v5] ext4: remove bogus wait for unwritten extents
 in ext4_ind_direct_IO
Date: Fri, 15 Feb 2013 15:14:06 +0800
Message-ID: <20130215071406.GF26945@gmail.com>
References: <1360313046-9876-1-git-send-email-wenqing.lz@taobao.com>
 <1360313046-9876-11-git-send-email-wenqing.lz@taobao.com>
 <20130212125819.GE19583@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>,
	Theodore Ts'o <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:61821 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683Ab3BOG7e (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Feb 2013 01:59:34 -0500
Received: by mail-da0-f46.google.com with SMTP id p5so1377070dak.5
        for <linux-ext4@vger.kernel.org>; Thu, 14 Feb 2013 22:59:34 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20130212125819.GE19583@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 12, 2013 at 01:58:19PM +0100, Jan Kara wrote:
> On Fri 08-02-13 16:44:06, Zheng Liu wrote:
> > From: Zheng Liu <wenqing.lz@taobao.com>
> > 
> > After converting unwritten extents from extent status tree in end_io, we
> > can safely remove this bogus wait and don't worry about read stale data
> > because we always try to lookup a block mapping in extent status tree
> > firstly and unwritten extents in the tree has been converted at this
> > time.
>   But you have to make sure the extent for the range really is in the
> status tree (you didn't in the previous patch I think) and cannot be
> reclaimed until the conversion is performed on disk.

Thanks for pointing out.  I will fix this problem.

Regards,
                                                - Zheng
