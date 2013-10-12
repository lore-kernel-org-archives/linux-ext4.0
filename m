From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH v1 14/22] mke2fs: add inline_data support in mke2fs
Date: Sat, 12 Oct 2013 16:08:46 +0800
Message-ID: <20131012080846.GA6462@gmail.com>
References: <1375436989-18948-1-git-send-email-wenqing.lz@taobao.com>
 <1375436989-18948-15-git-send-email-wenqing.lz@taobao.com>
 <20131012002718.GT6860@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Zheng Liu <wenqing.lz@taobao.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f49.google.com ([209.85.160.49]:58645 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab3JLIGw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 12 Oct 2013 04:06:52 -0400
Received: by mail-pb0-f49.google.com with SMTP id xb4so5222055pbc.36
        for <linux-ext4@vger.kernel.org>; Sat, 12 Oct 2013 01:06:52 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20131012002718.GT6860@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 11, 2013 at 05:27:18PM -0700, Darrick J. Wong wrote:
[...]
> > +	 */
> > +	if ((fs_param.s_feature_incompat & EXT4_FEATURE_INCOMPAT_INLINE_DATA) &&
> > +	    !(fs_param.s_feature_compat & EXT2_FEATURE_COMPAT_EXT_ATTR)) {
> > +		com_err(program_name, 0,
> > +			_("Ext_attr feature not enabled, so inline_data "
> > +			  "feature doesn't be specified"));
> 
> "The inline_data feature requires the ext_attr feature." ?

Ah, I have noticed that now we set xattr handler by default.  So, yes,
inline_data feature doesn't require the ext_attr feature.

Thanks,
                                                - Zheng
