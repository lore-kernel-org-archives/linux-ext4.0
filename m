From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 04/49] create_inode: move debugfs internal state back to
 debugfs
Date: Tue, 11 Mar 2014 23:31:09 -0400
Message-ID: <20140312033109.GD23182@thunk.org>
References: <20140311065356.30585.47192.stgit@birch.djwong.org>
 <20140311065423.30585.98566.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40213 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752789AbaCLDbM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Mar 2014 23:31:12 -0400
Content-Disposition: inline
In-Reply-To: <20140311065423.30585.98566.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 10, 2014 at 11:54:23PM -0700, Darrick J. Wong wrote:
> Since create_inode.c is shared between debugfs and mke2fs, don't
> spread debugfs internal state into mke2fs.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
