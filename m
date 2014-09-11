From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 09/25] misc: zero s_jnl_blocks when removing internal
 journal
Date: Thu, 11 Sep 2014 12:44:31 -0400
Message-ID: <20140911164431.GQ26178@thunk.org>
References: <20140908231135.25904.66591.stgit@birch.djwong.org>
 <20140908231235.25904.40254.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, TR Reardon <thomas_reardon@hotmail.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51489 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755563AbaIKQod (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Sep 2014 12:44:33 -0400
Content-Disposition: inline
In-Reply-To: <20140908231235.25904.40254.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 08, 2014 at 04:12:35PM -0700, Darrick J. Wong wrote:
> When we're removing the internal journal (broken journal, turning it
> off, or adding an external journal), zero s_jnl_blocks so that they
> can't be picked up by accident later.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Cc: TR Reardon <thomas_reardon@hotmail.com>

Applied, thanks.

					- Ted
