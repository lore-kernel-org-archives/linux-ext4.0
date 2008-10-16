From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: panic on boot at ext4_mb_poll_new_transaction
Date: Thu, 16 Oct 2008 10:40:05 -0500
Message-ID: <48F76055.2090502@redhat.com>
References: <20081016070735.GA28486@csclub.uwaterloo.ca> <20081016143035.GA10825@mit.edu> <48F75164.20500@redhat.com> <20081016152134.GC12962@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Michael Spang <mspang@csclub.uwaterloo.ca>,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:60623 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751226AbYJPPkc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Oct 2008 11:40:32 -0400
In-Reply-To: <20081016152134.GC12962@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:

> Eric, I suspect this patch in the ext4 patch queue should fix things.
> 
>       do_mballoc_init_before_doing_filesystem_recovery
> 
> 							- Ted

Ah, you're right.  I thought I had that in the fedora kernel, so was
looking for something new, but ... nope.  grr.

/me runs off to update.

Thanks,
-Eric
