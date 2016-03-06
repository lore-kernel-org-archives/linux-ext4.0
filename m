From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/6] debugfs: improve dump_mmp handling
Date: Sun, 6 Mar 2016 18:11:08 -0500
Message-ID: <20160306231108.GB30238@thunk.org>
References: <1457224716-72388-1-git-send-email-adilger@dilger.ca>
 <1457224716-72388-2-git-send-email-adilger@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38278 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751663AbcCFXLK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 6 Mar 2016 18:11:10 -0500
Content-Disposition: inline
In-Reply-To: <1457224716-72388-2-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Mar 05, 2016 at 05:38:32PM -0700, Andreas Dilger wrote:
> If MMP is not enabled on a filesystem (s_mmp_block == 0), print this
> clearly rather than "MMP: block number beyond filesystem range".
> 
> Add an option to "debugfs dump_mmp" to specify the MMP block number
> instead of getting it from the superblock s_mmp_block field.
> 
> Signed-off-by: Andreas Dilger <adilger@dilger.ca>

Thanks, applied.

					- Ted
