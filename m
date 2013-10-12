From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 20/31] e2fsprogs: Add (optional) sparse checking to the
 build
Date: Fri, 11 Oct 2013 23:13:07 -0400
Message-ID: <20131012031307.GB30680@thunk.org>
References: <20131001012642.28415.89353.stgit@birch.djwong.org>
 <20131001012850.28415.63936.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45087 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753964Ab3JLDNM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Oct 2013 23:13:12 -0400
Content-Disposition: inline
In-Reply-To: <20131001012850.28415.63936.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 30, 2013 at 06:28:50PM -0700, Darrick J. Wong wrote:
> Run sparse against source files when building e2fsprogs with 'make C=1'.  If
> instead C=2, it configures basic ext2 types for bitwise checking with sparse,
> which can help find the (many many) spots where conversion errors are
> (possibly) happening.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

						- Ted
