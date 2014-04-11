From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] ext4: fix shared/002 and 004 fail issue in xfstests
Date: Thu, 10 Apr 2014 22:59:37 -0400
Message-ID: <20140411025937.GB23620@thunk.org>
References: <1397051669-2645-1-git-send-email-linkinjeon@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
	Ashish Sangwan <a.sangwan@samsung.com>
To: Namjae Jeon <linkinjeon@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52730 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892AbaDKC7m (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Apr 2014 22:59:42 -0400
Content-Disposition: inline
In-Reply-To: <1397051669-2645-1-git-send-email-linkinjeon@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 09, 2014 at 10:54:29PM +0900, Namjae Jeon wrote:
> From: Namjae Jeon <namjae.jeon@samsung.com>
> 
> When mounting ext4 with data=journal option, xfstest shared/002 and
> shared/004 are currently failing as checksum computed for testfile
> does not match with the checksum computed in other journal modes.
> In case of data=journal mode, a call to filemap_write_and_wait_range
> will not flush anything to disk as buffers are not marked dirty in
> write_end. In collapse range this call is followed by a call to
> truncate_pagecache_range. Due to this, when checksum is computed,
> a portion of file is re-read from disk which replace valid data with
> NULL bytes and hence the reason for the difference in checksum.
> 
> Calling ext4_force_commit before filemap_write_and_wait_range solves
> the issue as it will mark the buffers dirty during commit transaction
> which can be later synced by a call to filemap_write_and_wait_range.
> 
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>

Thanks, applied.

					- Ted
