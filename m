From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 04/54] libext2fs: initialize i_extra_isize when writing
 EAs
Date: Tue, 27 Jan 2015 11:02:12 -0500
Message-ID: <20150127160212.GD2453@thunk.org>
References: <20150127073533.13308.44994.stgit@birch.djwong.org>
 <20150127073559.13308.75577.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35287 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751614AbbA0QCN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 Jan 2015 11:02:13 -0500
Content-Disposition: inline
In-Reply-To: <20150127073559.13308.75577.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 26, 2015 at 11:35:59PM -0800, Darrick J. Wong wrote:
> If i_extra_isize is zero when we try to write extended attributes,
> we'll end up writing the EA magic into the i_extra_isize field, which
> causes a subsequent crash on big endian systems (when we try to write
> 0xEA02 bytes past the inode!).  Therefore when the field is zero, set
> i_extra_isize to the desired extra_isize size, zero those bytes, and
> write the EAs after the end of the extended inode.
> 
> v2: Don't bother if we have 128b inodes, and ensure that the value
> is 32b-aligned so that the EA magic starts on a 32b boundary.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

						- Ted
