From: tytso@mit.edu
Subject: Re: [PATCH 2/6 v2] ext4: refactor ext4_fallocate code
Date: Sat, 15 Mar 2014 23:28:08 -0400
Message-ID: <20140316032808.GB31988@thunk.org>
References: <1393355679-11160-1-git-send-email-lczerner@redhat.com>
 <1393355679-11160-3-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	xfs@oss.sgi.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42047 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755739AbaCPD2M (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 15 Mar 2014 23:28:12 -0400
Content-Disposition: inline
In-Reply-To: <1393355679-11160-3-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 25, 2014 at 08:14:35PM +0100, Lukas Czerner wrote:
> Move block allocation out of the ext4_fallocate into separate function
> called ext4_alloc_file_blocks(). This will allow us to use the same
> allocation code for other allocation operations such as zero range which
> is commit in the next patch.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Thanks, applied.

					- Ted
