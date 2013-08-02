From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [Bug 60676] New: Stat system call gives permission denied to
 root for links under a sticky bit
Date: Thu, 1 Aug 2013 20:44:26 -0400
Message-ID: <20130802004426.GF12830@thunk.org>
References: <bug-60676-13602@https.bugzilla.kernel.org/>
 <20130801182116.GA32574@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: bugzilla-daemon@bugzilla.kernel.org, linux-ext4@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37901 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022Ab3HBAoe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 1 Aug 2013 20:44:34 -0400
Content-Disposition: inline
In-Reply-To: <20130801182116.GA32574@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 01, 2013 at 11:21:16AM -0700, Christoph Hellwig wrote:
> Try reverting 800179c9b8a1e796e441674776d11cd4c05d61d7

Or just do:

echo 0 > /proc/sys/fs/protected_hardlinks
echo 0 > /proc/sys/fs/protected_symlinks

(or put the equivalent in /etc/sysctl.conf).

There is a **very** detailed description of the design decision behind
this change (which went in as of 3.6) in the commit description.  See:

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=800179c9b8a1e796e441674776d11cd4c05d61d7

In any case, it's "working as designed".

						- Ted
