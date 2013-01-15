From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/5] mke2fs: the -g option will now specify the clusters
 per block group
Date: Tue, 15 Jan 2013 14:05:16 -0500
Message-ID: <20130115190516.GB17719@thunk.org>
References: <20130114211014.GA22642@thunk.org>
 <1358210232-30578-1-git-send-email-tytso@mit.edu>
 <1358210232-30578-2-git-send-email-tytso@mit.edu>
 <50F57171.6030701@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	gnehzuil.liu@gmail.com
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43545 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757635Ab3AOTFU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Jan 2013 14:05:20 -0500
Content-Disposition: inline
In-Reply-To: <50F57171.6030701@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 15, 2013 at 09:10:41AM -0600, Eric Sandeen wrote:
> On 1/14/13 6:37 PM, Theodore Ts'o wrote:
> > If bigalloc is enabled, then -g will specify the clusters per block
> > group.  (If bigalloc is not enabled, then a cluster == a block, so the
> > meaning of -g is not changed.)
> 
> This should be clearly documented in the man page as well, I think.

Yes, I'm going to include this change as a part of the Zheng's man
page clean up.

						- Ted
