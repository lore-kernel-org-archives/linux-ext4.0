From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix ext4_dirty_inode() compile warning
Date: Fri, 2 Oct 2009 21:09:01 -0400
Message-ID: <20091003010901.GB11365@mit.edu>
References: <6601abe90910020922g4e6a59e7mcc4eeda5cd7b4d1f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:54052 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756063AbZJCBI6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 2 Oct 2009 21:08:58 -0400
Content-Disposition: inline
In-Reply-To: <6601abe90910020922g4e6a59e7mcc4eeda5cd7b4d1f@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 02, 2009 at 09:22:18AM -0700, Curt Wohlgemuth wrote:
> Hi Ted:
> 
> Apparently my patch for
> 
>    ext4: Make sure ext4_dirty_inode() updates the inode in no journal mode
> 
> didn't play well if CONFIG_JBD_DEBUG wasn't defined.
> 
> Here are two patches that fix it.  I don't know if the jbd_debug() call has
> any importance or not; you can choose which is better perhaps?

I chose the first one, with a slightly elaborated commit message.

Thanks,

							- Ted
