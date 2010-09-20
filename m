From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsck: Improve error message when device name
 misspelled
Date: Sun, 19 Sep 2010 22:56:00 -0400
Message-ID: <20100920025600.GC3554@thunk.org>
References: <1283955128-6517-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:57157 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755408Ab0ITC4G (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 19 Sep 2010 22:56:06 -0400
Content-Disposition: inline
In-Reply-To: <1283955128-6517-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 08, 2010 at 04:12:08PM +0200, Jan Kara wrote:
> When a device name is misspelled, we output the full text about specifying
> alternate superblock. This is slightly misleading because when the device
> cannot be open because of ENOENT, this certainly won't help. So just print
> that device does not exist and exit.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Applied, thanks for the patch!

					- Ted
