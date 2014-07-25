From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 17/24] e2fsck: reserve blocks for root/lost+found
 directory repair
Date: Fri, 25 Jul 2014 08:12:53 -0400
Message-ID: <20140725121253.GH1865@thunk.org>
References: <20140718225200.31374.85411.stgit@birch.djwong.org>
 <20140718225422.31374.22565.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56219 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750926AbaGYMM4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Jul 2014 08:12:56 -0400
Content-Disposition: inline
In-Reply-To: <20140718225422.31374.22565.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 18, 2014 at 03:54:22PM -0700, Darrick J. Wong wrote:
> If we think we're going to need to repair either the root directory or
> the lost+found directory, reserve a block at the end of pass 1 to
> reduce the likelihood of an e2fsck abort while reconstructing
> root/lost+found during pass 3.

Can you say more about when this situation arises?  The only thing I
can think of is if there are a large number of blocks that need to be
cloned during passes 1b/c/d?

						- Ted
