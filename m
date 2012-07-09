From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Use proper csum calculation in ext4_rename.
Date: Mon, 9 Jul 2012 10:07:51 -0400
Message-ID: <20120709140751.GA3649@thunk.org>
References: <1340379514-2838-1-git-send-email-tm@tao.ma>
 <20120703170153.GC2342@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tao Ma <tm@tao.ma>, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:37995 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753705Ab2GIOH7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Jul 2012 10:07:59 -0400
Content-Disposition: inline
In-Reply-To: <20120703170153.GC2342@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 03, 2012 at 10:01:53AM -0700, Darrick J. Wong wrote:
> On Fri, Jun 22, 2012 at 11:38:34PM +0800, Tao Ma wrote:
> > From: Tao Ma <boyu.mt@taobao.com>
> > 
> > In ext4_rename, when the old name is a dir, we need to
> > change ".." to its new parent and journal the change, so
> > with metadata_csum enabled, we have to re-calc the csum.
> > 
> > As the first block of the dir can be either a htree root
> > or a normal directory block and we have different csum
> > calculation for these 2 types, we have to choose the right
> > one in ext4_rename.
> > 
> > btw, it is found by xfstests 013.
> 
> Good catch!
> 
> Acked-by: Darrick J. Wong <djwong@us.ibm.com>

Thanks, applied.

						- Ted
