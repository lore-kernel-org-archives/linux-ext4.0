From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] ext4: check EA value offset when loading
Date: Tue, 16 Sep 2014 14:41:16 -0400
Message-ID: <20140916184116.GJ6205@thunk.org>
References: <20140914173252.31996.86784.stgit@birch.djwong.org>
 <20140914173259.31996.39833.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:60314 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754221AbaIPSlU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Sep 2014 14:41:20 -0400
Content-Disposition: inline
In-Reply-To: <20140914173259.31996.39833.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Sep 14, 2014 at 10:32:59AM -0700, Darrick J. Wong wrote:
> When loading extended attributes, check each entry's value offset to
> make sure it doesn't collide with the entries.
> 
> Without this check it is easy to crash the kernel by mounting a
> malicious FS containing a file with an EA wherein e_value_offs = 0 and
> e_value_size > 0 and then deleting the EA, which corrupts the name
> list.
> 
> (See the f_ea_value_crash test's FS image in e2fsprogs for an example.)
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
