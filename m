From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: checksums
Date: Tue, 14 May 2013 09:18:30 -0400
Message-ID: <20130514131830.GA19563@thunk.org>
References: <20130514091407.GC2041@belle.intranet.vanheusden.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: folkert <folkert@vanheusden.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48306 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752594Ab3ENNSg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 14 May 2013 09:18:36 -0400
Content-Disposition: inline
In-Reply-To: <20130514091407.GC2041@belle.intranet.vanheusden.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 14, 2013 at 11:14:08AM +0200, folkert wrote:
> 
> Is it possible to "scrub" (check/verify) (the new-) checksums in ext4?

When e2fsck does a full check, it verifies the contents of all of the
metadata blocks, and this includes verifying all of the checksums.

> Also: is it planned to add an option to add checksums to the data as
> well?

That's not currently on the development roadmap; I could imagine
someone deciding to design an extension to ext4 that would do this
probably by storing the checksums in the indirect blocks, but no one
is currently working on it.

Regards,

					- Ted
