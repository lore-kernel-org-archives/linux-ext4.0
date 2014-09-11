From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 05/25] mke2fs: allow creation of journal device with
 superblock checksum
Date: Thu, 11 Sep 2014 12:43:46 -0400
Message-ID: <20140911164346.GM26178@thunk.org>
References: <20140908231135.25904.66591.stgit@birch.djwong.org>
 <20140908231208.25904.32508.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, TR Reardon <thomas_reardon@hotmail.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51460 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755154AbaIKQnr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Sep 2014 12:43:47 -0400
Content-Disposition: inline
In-Reply-To: <20140908231208.25904.32508.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 08, 2014 at 04:12:08PM -0700, Darrick J. Wong wrote:
> Enable mke2fs to create an external journal device with a superblock
> checksum.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Cc: TR Reardon <thomas_reardon@hotmail.com>

Applied, thanks.

					- Ted
