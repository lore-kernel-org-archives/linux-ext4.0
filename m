From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/8] ext4: store checksum seed in superblock
Date: Sat, 17 Oct 2015 22:14:37 -0400
Message-ID: <20151018021437.GH2678@thunk.org>
References: <20151012215416.28872.8160.stgit@birch.djwong.org>
 <20151012215444.28872.23113.stgit@birch.djwong.org>
 <20151018011946.GF2678@thunk.org>
 <20151018012326.GS10390@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56573 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752440AbbJRCOj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 17 Oct 2015 22:14:39 -0400
Content-Disposition: inline
In-Reply-To: <20151018012326.GS10390@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Oct 17, 2015 at 06:23:26PM -0700, Darrick J. Wong wrote:
> > +	__le32	s_checksum_seed;	/* crc32c(uuid) if csum_seed set */
> > +	__le32	s_reserved[98];		/* Padding to the end of the block */
> 
> I think this is the only change from the previous patch?  Looks good to me!

Correct.

					- Ted
