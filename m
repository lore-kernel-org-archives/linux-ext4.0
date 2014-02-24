From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 47/74] resize2fs: during shrink, don't free in-use bg
 data clusters
Date: Sun, 23 Feb 2014 20:39:13 -0500
Message-ID: <20140224013912.GA23946@thunk.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
 <20131211012333.30655.80931.stgit@birch.djwong.org>
 <20131216050147.GJ28536@thunk.org>
 <20131216201056.GI10143@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33215 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976AbaBXBjR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 23 Feb 2014 20:39:17 -0500
Content-Disposition: inline
In-Reply-To: <20131216201056.GI10143@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 16, 2013 at 12:10:56PM -0800, Darrick J. Wong wrote:
> Yep, that makes sense.  How about something like this?
> 
> ---
> resize2fs: during shrink, don't free in-use bg data clusters
> 
> When freeing a group's metadata blocks, be careful not to free
> clusters belonging to other groups!
> 
> v2: Remove unnecessary parameters, per Ted's suggestion.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
