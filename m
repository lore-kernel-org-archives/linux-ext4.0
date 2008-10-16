From: Theodore Tso <tytso@mit.edu>
Subject: Re: panic on boot at ext4_mb_poll_new_transaction
Date: Thu, 16 Oct 2008 11:21:34 -0400
Message-ID: <20081016152134.GC12962@mit.edu>
References: <20081016070735.GA28486@csclub.uwaterloo.ca> <20081016143035.GA10825@mit.edu> <48F75164.20500@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Michael Spang <mspang@csclub.uwaterloo.ca>,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:40420 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752306AbYJPPVh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Oct 2008 11:21:37 -0400
Content-Disposition: inline
In-Reply-To: <48F75164.20500@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 16, 2008 at 09:36:20AM -0500, Eric Sandeen wrote:
> >> Let me know if there's anything I can do to rescue it. Otherwise I'll
> >> just reinstall.

Michael,

Do you have a rescue CD with e2fsprogs 1.41.0 or later?  If it's the
problem Aneesh thinks it is (and I agree), running e2fsck in preen
mode should fix the problem.

> Looks similar to https://bugzilla.redhat.com/show_bug.cgi?id=467161,
> which I was just alerted to, and I'm looking into it.

Eric, I suspect this patch in the ext4 patch queue should fix things.

      do_mballoc_init_before_doing_filesystem_recovery

							- Ted
