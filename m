From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 08/27] BKL: Remove BKL from ext4 filesystem
Date: Mon, 9 Nov 2009 09:45:01 -0500
Message-ID: <20091109144500.GA11942@mit.edu>
References: <1257156307-24175-1-git-send-email-jblunck@suse.de> <1257156307-24175-9-git-send-email-jblunck@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>,
	linux-kernel@vger.kernel.org, Andreas Dilger <adilger@sun.com>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org
To: Jan Blunck <jblunck@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:36374 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753997AbZKIOpF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Nov 2009 09:45:05 -0500
Content-Disposition: inline
In-Reply-To: <1257156307-24175-9-git-send-email-jblunck@suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 02, 2009 at 11:04:48AM +0100, Jan Blunck wrote:
> The BKL is still used in ext4_put_super(), ext4_fill_super() and
> ext4_remount(). All three calles are protected against concurrent calls by
> the s_umount rw semaphore of struct super_block.
> 
> Therefore the BKL is protecting nothing in this case.
> 
> Signed-off-by: Jan Blunck <jblunck@suse.de>

Acked-by: "Theodore Ts'o" <tytso@mit.edu>

						- Ted
