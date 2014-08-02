From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 21/37] libext2fs: have UNIX IO manager use pread/pwrite
Date: Sat, 2 Aug 2014 19:16:54 -0400
Message-ID: <20140802231654.GB29146@thunk.org>
References: <20140501231222.31890.82860.stgit@birch.djwong.org>
 <20140501231439.31890.25006.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41805 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008AbaHBXTG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 2 Aug 2014 19:19:06 -0400
Content-Disposition: inline
In-Reply-To: <20140501231439.31890.25006.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 01, 2014 at 04:14:39PM -0700, Darrick J. Wong wrote:
> If pread/pwrite are present, have the UNIX IO manager use them for
> aligned IOs (instead of the current seek -> read/write), thereby
> saving us a (minor) amount of system call overhead.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

						- Ted
