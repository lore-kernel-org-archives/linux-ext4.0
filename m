From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 10/49] libext2fs: fix iblocks correctly when expanding an
 inline_data file
Date: Fri, 14 Mar 2014 09:25:46 -0400
Message-ID: <20140314132545.GE8282@thunk.org>
References: <20140311065356.30585.47192.stgit@birch.djwong.org>
 <20140311065502.30585.81788.stgit@birch.djwong.org>
 <5091761D-1733-4150-9999-C63CF142795B@dilger.ca>
 <20140312170133.GA9070@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41330 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753109AbaCNNZs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 14 Mar 2014 09:25:48 -0400
Content-Disposition: inline
In-Reply-To: <20140312170133.GA9070@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 12, 2014 at 10:01:33AM -0700, Darrick J. Wong wrote:
> On Wed, Mar 12, 2014 at 10:38:57AM -0600, Andreas Dilger wrote:
> > I thought it wasn't possible to have inline data and an external xattr block?
> > It doesn't make sense to do it that way compared to the normal inline xattr
> > and external data block. 
> 
> I don't know if you're /supposed/ to be able to do that, but the kernel permits
> me to create an inline data dir and then set a huge xattr on it that forces the
> allocation of an EA block.

I could imagine situations where the file size is very small, and the
xattr size is close to the blocksize, where it would make sense to
allow this (since if we prohibited this, we would need to use two
blocks, one for the data block since the data does't fit in the inode,
and a second data block for the xattr)

Anyway, I've applid the patch, thanks.

					- Ted
