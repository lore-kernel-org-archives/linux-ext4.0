From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs: Offsets of EAs in inode need not be sorted
Date: Tue, 8 May 2007 01:07:52 -0400
Message-ID: <20070508050751.GE10940@thunk.org>
References: <1176984336.3812.10.camel@garfield>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Kalpak Shah <kalpak@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:47951 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967866AbXEHFJh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 May 2007 01:09:37 -0400
Content-Disposition: inline
In-Reply-To: <1176984336.3812.10.camel@garfield>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Apr 19, 2007 at 05:35:36PM +0530, Kalpak Shah wrote:
> This patch removes a code snippet from check_ea_in_inode() in pass1
> which checks if the EA values in the inode are sorted or not. The
> comments in fs/ext*/xattr.c state that the EA values in the external
> EA block are sorted but those in the inode need not be sorted. I
> have also attached a test image which has unsorted EAs in the
> inodes. The current e2fsck wrongly clears the EAs in the inode.

Applied.

					- Ted
