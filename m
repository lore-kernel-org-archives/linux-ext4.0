From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 02/12] libext2fs: automatically enable meta_bg to avoid
 filling up BG 0
Date: Sat, 24 Oct 2015 00:38:06 -0400
Message-ID: <20151024043806.GJ7917@thunk.org>
References: <20151012215629.29065.24418.stgit@birch.djwong.org>
 <20151012215642.29065.18353.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41828 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751692AbbJXKvf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 24 Oct 2015 06:51:35 -0400
Content-Disposition: inline
In-Reply-To: <20151012215642.29065.18353.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 12, 2015 at 02:56:42PM -0700, Darrick J. Wong wrote:
> If during formatting we'd lose more than half of a block group to
> group descriptors and other metadata, enable the meta_bg feature.
> This enables us to create >500T filesystems with default options.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, with the commit description fixed up.

	      	  	 	     	   - Ted
