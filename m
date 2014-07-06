From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: tune2fs: update journal super block when changing UUID for fs.
Date: Sat, 5 Jul 2014 22:49:45 -0400
Message-ID: <20140706024945.GA25768@thunk.org>
References: <1403965786-14561-1-git-send-email-a3at.mail@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, chintzung@gmail.com
To: Azat Khuzhin <a3at.mail@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47194 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751674AbaGFCtt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 5 Jul 2014 22:49:49 -0400
Content-Disposition: inline
In-Reply-To: <1403965786-14561-1-git-send-email-a3at.mail@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jun 28, 2014 at 06:29:46PM +0400, Azat Khuzhin wrote:
> 
> Here is the RFC patch for this, I'm not sure about the check for *is this 
> journal device or not*, so I will glad to see some comments. Thanks.

The way you tell whether or not you've opened the journal device is as
follows:

	if (fs->super->s_feature_incompat & EXT3_FEATURE_INCOMPAT_JOURNAL_DEV) {
	   ...

That is to say, the journal device has a ext2/3/4 superblock, but with
a special incompat flag which indicates that it is an external journal
--- and which also prevents the kernel from trying to mount the
external journal device as a normal ext4 file system.

Regards,

					- Ted
