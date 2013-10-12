From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH v1 14/22] mke2fs: add inline_data support in mke2fs
Date: Sat, 12 Oct 2013 16:31:17 +0800
Message-ID: <20131012083117.GD6462@gmail.com>
References: <1375436989-18948-1-git-send-email-wenqing.lz@taobao.com>
 <1375436989-18948-15-git-send-email-wenqing.lz@taobao.com>
 <20131012002718.GT6860@birch.djwong.org>
 <20131012080846.GA6462@gmail.com>
 <20131012081825.GB14971@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Zheng Liu <wenqing.lz@taobao.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:48097 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab3JLI3X (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 12 Oct 2013 04:29:23 -0400
Received: by mail-pa0-f50.google.com with SMTP id fb1so5459330pad.9
        for <linux-ext4@vger.kernel.org>; Sat, 12 Oct 2013 01:29:23 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20131012081825.GB14971@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Oct 12, 2013 at 01:18:25AM -0700, Darrick J. Wong wrote:
> On Sat, Oct 12, 2013 at 04:08:46PM +0800, Zheng Liu wrote:
> > On Fri, Oct 11, 2013 at 05:27:18PM -0700, Darrick J. Wong wrote:
> > [...]
> > > > +	 */
> > > > +	if ((fs_param.s_feature_incompat & EXT4_FEATURE_INCOMPAT_INLINE_DATA) &&
> > > > +	    !(fs_param.s_feature_compat & EXT2_FEATURE_COMPAT_EXT_ATTR)) {
> > > > +		com_err(program_name, 0,
> > > > +			_("Ext_attr feature not enabled, so inline_data "
> > > > +			  "feature doesn't be specified"));
> > > 
> > > "The inline_data feature requires the ext_attr feature." ?
> > 
> > Ah, I have noticed that now we set xattr handler by default.  So, yes,
> > inline_data feature doesn't require the ext_attr feature.
> 
> I think you /do/ still need this check, just in case someone tries to mkfs -O
> ^ext_attr,inline_data.  Defaults can be overridden.

I have tested this ('mkfs -O ^ext_attr,inline_data') just a minute ago,
and it seems that it works well.  BTW, when we use setfattr(1) to set
xattr in a ext4 file system without ext_attr feature, this feature will
be enabled in ext4_xattr_update_super_block().

                                                - Zheng
