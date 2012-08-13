From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 01/35 v3] libext2fs: add
 EXT4_FEATURE_INCOMPAT_INLINE_DATA flag
Date: Mon, 13 Aug 2012 15:44:04 +0800
Message-ID: <20120813074404.GA21093@gmail.com>
References: <1341150538-32047-1-git-send-email-wenqing.lz@taobao.com>
 <1341150538-32047-2-git-send-email-wenqing.lz@taobao.com>
 <20120807182214.GA29423@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34715 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797Ab2HMHfN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Aug 2012 03:35:13 -0400
Received: by pbbrr13 with SMTP id rr13so6830053pbb.19
        for <linux-ext4@vger.kernel.org>; Mon, 13 Aug 2012 00:35:12 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20120807182214.GA29423@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 07, 2012 at 02:22:14PM -0400, Theodore Ts'o wrote:
> On Sun, Jul 01, 2012 at 09:48:24PM +0800, Zheng Liu wrote:
> > From: Zheng Liu <wenqing.lz@taobao.com>
> > 
> > Add EXT4_FEATURE_INCOMPAT_INLINE_DATA flag to support inline
> > data feature.
> > 
> > Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> 
> I've pulled in the part of this patch which renames
> INCOMPAT_INLINEDATA to INCOMPAT_INLINE_DATA to the next branch.
> 
> As far as actually adding this feature to
> EXT2_LIB_FEATURE_INCOMPAT_SUPP, I have two comments.  In general, it's
> best to add this to the patch series at the very end, so that if
> someone is bisecting e2fsprogs, there's no chance that they end up
> with the feature only partially supported.
> 
> If the development of the patch is going to take a long time, what I
> have done in the past is to add the feature to
> EXT2_LIB_SOFTSUPP_INCOMPAT and EXt2_LIB_SOFTSUPP_RO_COMPAT.  This
> allows dumpe2fs and debugfs to recognize the file system, which is
> handy for debugging and development.  But it doesn't allow e2fsck to
> try to check or repair file systems with the feature enabled, since
> usually e2fsck support is one of the last things to be coded up.
> 
> Then when we're ready to turn on the feature and fully support things,
> we'll have a patch which adds the feature to
> EXT2_LIB_FEATURE_INCOMPAT_SUPP, and remove it from the SOFTSUPP mask.

Thanks for teaching me. :-)

Regards,
Zheng
