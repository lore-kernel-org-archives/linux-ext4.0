From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: e2fsprogs - possible regression between 1.42.7 and 1.42.8
Date: Mon, 29 Jul 2013 10:40:33 -0400
Message-ID: <20130729144033.GA11816@thunk.org>
References: <20130729083941.GG28871@pcnci.linuxbox.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37012 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756350Ab3G2PYz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Jul 2013 11:24:55 -0400
Content-Disposition: inline
In-Reply-To: <20130729083941.GG28871@pcnci.linuxbox.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 29, 2013 at 10:39:41AM +0200, Nikola Ciprich wrote:
> 
> trying to compile latest e2fsprogs and running check under RHEL6-compatible
> distro (centos) fails:
> 
> r_1024_small_bg: ext2 1024 blocksize with small block groups: failed
> r_ext4_small_bg: ext4 1024 blocksize with small block groups: failed
> 
> dunno whether this is known issue... will bisect help?

What platform are you running this on?  X86?  I generally do a full
regression test run before I do an e2fsprogs release, so it may very
well be something which might be platform or compiler specific.

Can you send me the r_1024_small_bg.failed and r_ext4_small_bg.failed
files?

Thanks,

						- Ted
