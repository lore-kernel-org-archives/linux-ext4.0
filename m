From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 5/5] libext2fs: avoid 32-bit overflow in
 ext2fs_initialize with a 512M cluster size
Date: Tue, 15 Jan 2013 23:36:20 +0800
Message-ID: <20130115153620.GF19209@gmail.com>
References: <20130114211014.GA22642@thunk.org>
 <1358210232-30578-1-git-send-email-tytso@mit.edu>
 <1358210232-30578-5-git-send-email-tytso@mit.edu>
 <20130115153331.GE19209@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Ts'o <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:64544 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756238Ab3AOPWd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Jan 2013 10:22:33 -0500
Received: by mail-pa0-f46.google.com with SMTP id bh2so162671pad.5
        for <linux-ext4@vger.kernel.org>; Tue, 15 Jan 2013 07:22:33 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20130115153331.GE19209@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 15, 2013 at 11:33:31PM +0800, Zheng Liu wrote:
> On Mon, Jan 14, 2013 at 07:37:12PM -0500, Theodore Ts'o wrote:
> > If the user attemps to create a 512MB cluster, we need to adjust the
> > defaults to avoid a 32-bit overflow of s_blocks_per_group.  Also check
> > to make sure that the caller of ext2fs_initialize() has not given a
> > value of s_clusters_per_group that would result in an overflow of
> > s_blocks_per_group.
> > 
> > Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> 
> The patch itself looks good to me.  Feel free to add:
> Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>

Sorry, forgot to say that '-C' option in manpage will need to be modified
from 256MB to 512MB if this patch is applied.

Thanks,
                                                - Zheng
