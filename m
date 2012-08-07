From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 01/35 v3] libext2fs: add
 EXT4_FEATURE_INCOMPAT_INLINE_DATA flag
Date: Tue, 7 Aug 2012 14:22:14 -0400
Message-ID: <20120807182214.GA29423@thunk.org>
References: <1341150538-32047-1-git-send-email-wenqing.lz@taobao.com>
 <1341150538-32047-2-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43454 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753016Ab2HGSWS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Aug 2012 14:22:18 -0400
Content-Disposition: inline
In-Reply-To: <1341150538-32047-2-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jul 01, 2012 at 09:48:24PM +0800, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> Add EXT4_FEATURE_INCOMPAT_INLINE_DATA flag to support inline
> data feature.
> 
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>

I've pulled in the part of this patch which renames
INCOMPAT_INLINEDATA to INCOMPAT_INLINE_DATA to the next branch.

As far as actually adding this feature to
EXT2_LIB_FEATURE_INCOMPAT_SUPP, I have two comments.  In general, it's
best to add this to the patch series at the very end, so that if
someone is bisecting e2fsprogs, there's no chance that they end up
with the feature only partially supported.

If the development of the patch is going to take a long time, what I
have done in the past is to add the feature to
EXT2_LIB_SOFTSUPP_INCOMPAT and EXt2_LIB_SOFTSUPP_RO_COMPAT.  This
allows dumpe2fs and debugfs to recognize the file system, which is
handy for debugging and development.  But it doesn't allow e2fsck to
try to check or repair file systems with the feature enabled, since
usually e2fsck support is one of the last things to be coded up.

Then when we're ready to turn on the feature and fully support things,
we'll have a patch which adds the feature to
EXT2_LIB_FEATURE_INCOMPAT_SUPP, and remove it from the SOFTSUPP mask.

				    	      - Ted
