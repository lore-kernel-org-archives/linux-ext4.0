From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] tune2fs: update i_size in ext2fs_file_write()
Date: Tue, 8 Oct 2013 11:45:32 -0400
Message-ID: <20131008154532.GC17896@thunk.org>
References: <5231CDFE.8050206@gmail.com>
 <52537C42.9010808@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adityakali@google.com, linux-ext4@vger.kernel.org,
	yawei.niu@intel.com, andreas.dilger@intel.com
To: Niu Yawei <yawei.niu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:43659 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751948Ab3JHPp5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Oct 2013 11:45:57 -0400
Content-Disposition: inline
In-Reply-To: <52537C42.9010808@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 08, 2013 at 11:30:10AM +0800, Niu Yawei wrote:
> ext2fs_file_write() needs to update i_size on successful write,
> otherwise, ext2fs_file_read() in same open/close cycle will not
> be able to read the just written data.
> 
> This bug result in the the problem of quotacheck triggered on
> 'tune2fs -O quota' failed to write back multiple users/groups
> accounting information.
> 
> Signed-off-by: Niu Yawei <yawei.niu@intel.com>

Applied, thanks.

					- Ted
