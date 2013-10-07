From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 13/31] e2fsprogs: Less critical fixes to use the
 appropriate blk*t types
Date: Mon, 7 Oct 2013 09:59:17 -0400
Message-ID: <20131007135917.GJ4540@thunk.org>
References: <20131001012642.28415.89353.stgit@birch.djwong.org>
 <20131001012805.28415.80896.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:43106 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754335Ab3JGN7U (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Oct 2013 09:59:20 -0400
Content-Disposition: inline
In-Reply-To: <20131001012805.28415.80896.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 30, 2013 at 06:28:05PM -0700, Darrick J. Wong wrote:
> More fixing of places where raw data types (int, long, etc.) stood in for blk_t
> and blk64_t.  Also fix some sites where we should probably be using blk64_t.
> These fixes aren't as critical as the previous patch.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied with the final commit description change:

Author: Darrick J. Wong <darrick.wong@oracle.com>
Date:   Mon Oct 7 09:57:36 2013 -0400

    e2fsprogs: fix inode and block relocation functions to use blk64_t
    
    The inode and block relocation functions aren't currently compiled in
    (so we don't need to worry about breaking ABI compatibility).  They
    were originally intended for use by resize2fs, but we never ended up
    using them, so (wisely) they weren't ever included in libext2fs as an
    exported interface (they're not even compiled by the Makefile).
    
    Fix them so that in case we ever use them, so that in places where raw
    data types (int, long, etc.) stood in for blk_t and blk64_t.  Also fix
    some sites where we should probably be using blk64_t.
    
    Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

					- Ted
