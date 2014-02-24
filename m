From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 56/74] libext2fs: various tweaks to the xattr editor APIs
Date: Sun, 23 Feb 2014 23:10:02 -0500
Message-ID: <20140224041002.GD23946@thunk.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
 <20131211012432.30655.68629.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33260 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751402AbaBXEKE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 23 Feb 2014 23:10:04 -0500
Content-Disposition: inline
In-Reply-To: <20131211012432.30655.68629.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 10, 2013 at 05:24:32PM -0800, Darrick J. Wong wrote:
> A few tweaks to the extended attribute editing APIs:
> 
>  * Use size_t, not unsigned int, in the new extended attribute editing
>    API.
> 
>  * Don't expose the _expand() call since there should be no external
>    users.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
