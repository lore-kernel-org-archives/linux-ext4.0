From: tytso@mit.edu
Subject: Re: [PATCH, RFC] ext4: Store basic fs error information in the
 superblock
Date: Thu, 24 Jun 2010 09:17:10 -0400
Message-ID: <20100624131710.GG6843@thunk.org>
References: <1277349714-9697-1-git-send-email-tytso@mit.edu>
 <871vbw8zzi.fsf@dmon-lap.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:41893 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753768Ab0FXNRP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Jun 2010 09:17:15 -0400
Content-Disposition: inline
In-Reply-To: <871vbw8zzi.fsf@dmon-lap.sw.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 24, 2010 at 02:52:01PM +0400, Dmitry Monakhov wrote:
> Excellent choice. s_error_XXX fields finally allow one to detect errors
> in determinant meaner. And most stress test finally will do it after
> umount :).

This was something you could do before simply by testing for the
ERRORS_FS bit.  (You'll see it if you do a dumpe2fs -h on the file
system.)

> Minor question: What snapshot staff is doing in that patch?

Those were fields that were reserved for Amir's Next3 snapshot effort.
I probably should split this patch up, but this was a first pass
effort, and I did it all in one go...

							- Ted
