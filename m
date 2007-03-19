From: Theodore Tso <tytso@mit.edu>
Subject: Re: e2fsprogs coverity patch <cid-05.diff>
Date: Mon, 19 Mar 2007 08:34:38 -0400
Message-ID: <20070319123438.GE14519@thunk.org>
References: <200702100211.l1A2Bfjd007495@igsi.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, adilger@clusterfs.com,
	wartens2@llnl.gov
To: "Brian D. Behlendorf" <behlendorf1@llnl.gov>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:42148 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965116AbXCSRCy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Mar 2007 13:02:54 -0400
Content-Disposition: inline
In-Reply-To: <200702100211.l1A2Bfjd007495@igsi.llnl.gov>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Feb 09, 2007 at 06:11:41PM -0800, Brian D. Behlendorf wrote:
> array is initially set to NULL, so it is possible that readdir() will return
> NULL and leave array set to NULL. Thus we do need to check if array is NULL or
> check if num != 0.
> 
> Coverity ID: 5: Forward NULL

This wasn't the only bug; it turns out that if /etc/e2fsck.conf or
/etc/mke2fs.conf is an empty directory, then your patch would fix this
segfault, only for it to segfault later in profile_init().  I'll fix
this before I commit.

					- Ted
