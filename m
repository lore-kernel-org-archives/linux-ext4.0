From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/3] mke2fs: reduce the range of cluster-size
Date: Mon, 14 Jan 2013 16:10:14 -0500
Message-ID: <20130114211014.GA22642@thunk.org>
References: <1358068095-9034-1-git-send-email-wenqing.lz@taobao.com>
 <1358068095-9034-2-git-send-email-wenqing.lz@taobao.com>
 <20130114210349.GB8049@thunk.org>
 <74DCD2E2-28B9-4AA0-AE23-177202C49686@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Zheng Liu <gnehzuil.liu@gmail.com>, linux-ext4@vger.kernel.org,
	Zheng Liu <wenqing.lz@taobao.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43342 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757113Ab3ANVKR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Jan 2013 16:10:17 -0500
Content-Disposition: inline
In-Reply-To: <74DCD2E2-28B9-4AA0-AE23-177202C49686@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 14, 2013 at 02:07:43PM -0700, Andreas Dilger wrote:
> > I think the best way of fixing this is to document that the -g option
> > specifies the number of clusters per block if the bigalloc feature is
> > enabled.
> 
> Presumably you mean "the -g option specifies the number of clusters
> _per_group_ if the bigalloc feature is enabled"?

Yes, I meant to say that I want to change the definition of the -g
option such that if the bigalloc feature is enabled, it specifies the
number of clusters per block group.

					- Ted
