From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 1/5] mke2fs: enforce that the cluster size must be less
 that the block size
Date: Tue, 15 Jan 2013 23:22:15 +0800
Message-ID: <20130115152215.GA19209@gmail.com>
References: <20130114211014.GA22642@thunk.org>
 <1358210232-30578-1-git-send-email-tytso@mit.edu>
 <20130115004158.GC24179@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f44.google.com ([209.85.210.44]:39971 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756896Ab3AOPI3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Jan 2013 10:08:29 -0500
Received: by mail-da0-f44.google.com with SMTP id z20so73794dae.3
        for <linux-ext4@vger.kernel.org>; Tue, 15 Jan 2013 07:08:29 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20130115004158.GC24179@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 14, 2013 at 07:41:58PM -0500, Theodore Ts'o wrote:
> On Mon, Jan 14, 2013 at 07:37:08PM -0500, Theodore Ts'o wrote:
> > +		if (fs_param.s_log_cluster_size &&
> > +		    fs_param.s_log_cluster_size < fs_param.s_log_block_size) {
> > +			com_err(program_name, 0,
> > +				_("The cluster size must not be "
> > +				  "smaller than the block size.\n"));
> 
> This would read better: "the cluster size may not be smaller than the
> block size"
Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
Regards,
                                                - Zheng
