From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 06/49] libext2fs: support modifying arbitrary extended
 attributes (v5)
Date: Tue, 11 Mar 2014 23:51:05 -0400
Message-ID: <20140312035105.GA11368@thunk.org>
References: <20140311065356.30585.47192.stgit@birch.djwong.org>
 <20140311065436.30585.53528.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40236 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752789AbaCLDvI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Mar 2014 23:51:08 -0400
Content-Disposition: inline
In-Reply-To: <20140311065436.30585.53528.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 10, 2014 at 11:54:36PM -0700, Darrick J. Wong wrote:
> v5: Add magic number checking to the extended attribute editing
> handle; move inline data to the head of the attribute list when
> writing so that inline data ends up in the inode area; and always zero
> the attribute space before writing to ensure that we can delete the
> last xattr.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied (with a slight adjustment to the git commit summary)

		      	       		     - Ted
