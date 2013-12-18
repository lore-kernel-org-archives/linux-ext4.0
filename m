From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/3] ext4: Retry allocation when inline->extent
 conversion failed
Date: Wed, 18 Dec 2013 00:45:25 -0500
Message-ID: <20131218054525.GA19434@thunk.org>
References: <1386670440-3158-1-git-send-email-jack@suse.cz>
 <1386670440-3158-2-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Akira Fujita <a-fujita@rs.jp.nec.com>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41184 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213Ab3LRFpf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Dec 2013 00:45:35 -0500
Content-Disposition: inline
In-Reply-To: <1386670440-3158-2-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 10, 2013 at 11:13:58AM +0100, Jan Kara wrote:
> Similarly as other ->write_begin functions in ext4, also
> ext4_da_write_inline_data_begin() should retry allocation if the
> conversion failed because of ENOSPC. This avoids returning ENOSPC
> prematurely because of uncommitted block deletions.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
