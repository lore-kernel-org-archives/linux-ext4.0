From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 08/49] e2fsck: don't rehash inline directories
Date: Thu, 13 Mar 2014 08:13:48 -0400
Message-ID: <20140313121348.GA11752@thunk.org>
References: <20140311065356.30585.47192.stgit@birch.djwong.org>
 <20140311065449.30585.54020.stgit@birch.djwong.org>
 <20140313035248.GC13367@thunk.org>
 <20140313053848.GD9070@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40955 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753568AbaCMOHo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Mar 2014 10:07:44 -0400
Content-Disposition: inline
In-Reply-To: <20140313053848.GD9070@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 12, 2014 at 10:38:48PM -0700, Darrick J. Wong wrote:
> Probably we ought to fix up rehash.c to be able to compress directory entries
> too.  The only reason I kicked them here was that somehow an inline data dir
> would end up on the rehash list, causing the block iteration to fail and e2fsck
> stops cold.

Sure, this would be a nice to have, but I'll take this patch for now
so at least we don't crash out.

Cheers,

					- Ted
