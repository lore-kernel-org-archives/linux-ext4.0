From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 03/19] e2fsck: use root dir for lost+found when really
 desperate
Date: Mon, 4 Aug 2014 22:06:47 -0400
Message-ID: <20140805020647.GD5263@thunk.org>
References: <20140801181139.12496.14390.stgit@birch.djwong.org>
 <20140801181159.12496.97356.stgit@birch.djwong.org>
 <20140803022553.GC24826@thunk.org>
 <20140805005858.GU8628@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:44518 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723AbaHECGu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 4 Aug 2014 22:06:50 -0400
Content-Disposition: inline
In-Reply-To: <20140805005858.GU8628@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 04, 2014 at 05:58:58PM -0700, Darrick J. Wong wrote:
> 
> I don't see this in the tree on kernel.org, but I'm sending you a patch to
> change it to a fix_problem anyway.

It's there; on the next branch:

http://git.kernel.org/cgit/fs/ext2/e2fsprogs.git/commit/?h=next&id=0991896720917b467e573a5fae38539d950d0617

I hadn't bumped up the master branch just yet, since I usually like to
give a few days lag before master gets promoted:

http://git.kernel.org/cgit/fs/ext2/e2fsprogs.git/log/?h=next

Cheers,

						- Ted
