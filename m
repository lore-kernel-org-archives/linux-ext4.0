From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 01/26] ext4: use io_end for multiple bios
Date: Tue, 4 Jun 2013 12:03:19 -0400
Message-ID: <20130604160319.GB25160@thunk.org>
References: <1369993379-13017-1-git-send-email-jack@suse.cz>
 <1369993379-13017-2-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54718 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754008Ab3FDQD0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Jun 2013 12:03:26 -0400
Content-Disposition: inline
In-Reply-To: <1369993379-13017-2-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 31, 2013 at 11:42:34AM +0200, Jan Kara wrote:
> Change writeback path to create just one io_end structure for the
> extent to which we submit IO and share it among bios writing that
> extent. This prevents needless splitting and joining of unwritten
> extents when they cannot be submitted as a single bio.
> 
> Bugs in ENOMEM handling found by Linux File System Verification project
> (linuxtesting.org) and fixed by Alexey Khoroshilov
> <khoroshilov@ispras.ru>.
> 
> CC: Alexey Khoroshilov <khoroshilov@ispras.ru>
> Signed-off-by: Jan Kara <jack@suse.cz>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Applied, thanks.

				- Ted
