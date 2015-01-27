From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 06/54] libext2fs: strengthen i_extra_isize checks when
 reading/writing xattrs
Date: Tue, 27 Jan 2015 11:08:48 -0500
Message-ID: <20150127160848.GF2453@thunk.org>
References: <20150127073533.13308.44994.stgit@birch.djwong.org>
 <20150127073612.13308.90407.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35318 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751614AbbA0QIt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 Jan 2015 11:08:49 -0500
Content-Disposition: inline
In-Reply-To: <20150127073612.13308.90407.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 26, 2015 at 11:36:12PM -0800, Darrick J. Wong wrote:
> Strengthen the i_extra_isize checks to look for obviously too-small
> values before trying to operate on inode EAs.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
