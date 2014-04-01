From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: Remove unneeded test of ret variable
Date: Tue, 1 Apr 2014 01:00:09 -0400
Message-ID: <20140401050009.GN4911@thunk.org>
References: <1396257094-10386-1-git-send-email-lczerner@redhat.com>
 <1396257094-10386-2-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, dan.carpenter@oracle.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48154 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709AbaDAFAN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Apr 2014 01:00:13 -0400
Content-Disposition: inline
In-Reply-To: <1396257094-10386-2-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 31, 2014 at 11:11:34AM +0200, Lukas Czerner wrote:
> Currently in ext4_fallocate() and ext4_zero_range() we're testing ret
> variable along with new_size. However in ext4_fallocate() we just tested
> ret before and in ext4_zero_range() if will always be zero when we get
> there so there is no need to test it in both cases.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Thanks, applied.

					- Ted
