From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix shared/002 and 004 fail issue in xfstests
Date: Mon, 7 Apr 2014 12:25:13 -0400
Message-ID: <20140407162513.GA9242@thunk.org>
References: <1396881675-7272-1-git-send-email-linkinjeon@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
	Ashish Sangwan <a.sangwan@samsung.com>
To: Namjae Jeon <linkinjeon@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51172 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753057AbaDGQZY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Apr 2014 12:25:24 -0400
Content-Disposition: inline
In-Reply-To: <1396881675-7272-1-git-send-email-linkinjeon@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 07, 2014 at 11:41:15PM +0900, Namjae Jeon wrote:
> From: Namjae Jeon <namjae.jeon@samsung.com>
> 
> When mounting ext4 with data=journal option, shared/002 and 004 are
> failed on xfstests. Calling ext4_force_commit before
> filemap_write_and_wait_range is needed to flush all data into journal
> on this case.

Hi Namjae,

Thanks for working for this!

Could you include in your commit description of why adding a call to
ext4_force_commit() is necessary to avoid the problem, and what wa
going wrong in the data=journal case?

Thanks,

					- Ted
