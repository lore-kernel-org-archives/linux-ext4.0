From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 36/34] misc: fix Coverity complaints
Date: Thu, 18 Sep 2014 21:47:58 -0400
Message-ID: <20140919014758.GH26995@thunk.org>
References: <20140913221112.13646.3873.stgit@birch.djwong.org>
 <20140918190902.GH10150@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36722 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924AbaISBsB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Sep 2014 21:48:01 -0400
Content-Disposition: inline
In-Reply-To: <20140918190902.GH10150@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 18, 2014 at 12:09:02PM -0700, Darrick J. Wong wrote:
> Fix a few problems that Coverity picked up with error handling.
> 
> Fixes-Coverity-Bug: 1239278
> Fixes-Coverity-Bug: 1239279
> Fixes-Coverity-Bug: 1239280
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

				- Ted
