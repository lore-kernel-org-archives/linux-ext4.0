From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [V4] misc: copy extended attributes in populate_fs
Date: Sun, 27 Jul 2014 21:29:09 -0400
Message-ID: <20140728012909.GA19632@thunk.org>
References: <1405010678-993-1-git-send-email-ross.burton@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, darrick.wong@oracle.com
To: Ross Burton <ross.burton@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:59696 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243AbaG1B3P (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 27 Jul 2014 21:29:15 -0400
Content-Disposition: inline
In-Reply-To: <1405010678-993-1-git-send-email-ross.burton@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 10, 2014 at 05:44:38PM +0100, Ross Burton wrote:
> When creating a file system using a source directory, also copy any extended
> attributes that have been set.
> 
> Signed-off-by: Ross Burton <ross.burton@intel.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, after I added configure tests to test for the Linux-specific
system calls, and to add a fallback in case we are compiling on a
non-Linux system.

					- Ted
