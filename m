From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 01/35 v3] libext2fs: add
 EXT4_FEATURE_INCOMPAT_INLINE_DATA flag
Date: Tue, 7 Aug 2012 14:25:47 -0400
Message-ID: <20120807182547.GA29781@thunk.org>
References: <1341150538-32047-1-git-send-email-wenqing.lz@taobao.com>
 <1341150538-32047-2-git-send-email-wenqing.lz@taobao.com>
 <20120807182214.GA29423@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43458 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753016Ab2HGSZy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Aug 2012 14:25:54 -0400
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
> INCOMPAT_INLINEDATA to INCOMPAT_INLINE_DATA to the next branch....

Oops, I replied to the wrong patch.  This message should have been
attached to the mail thread for the v4 patch series.  Sorry about
that...

					- Ted
