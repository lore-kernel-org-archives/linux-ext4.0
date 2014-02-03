From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: kernel bug at fs/ext4/resize.c:409
Date: Mon, 3 Feb 2014 13:56:33 -0500
Message-ID: <20140203185633.GA22856@thunk.org>
References: <20140203182634.GA28811@shaniqua>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53829 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686AbaBCS4g (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Feb 2014 13:56:36 -0500
Content-Disposition: inline
In-Reply-To: <20140203182634.GA28811@shaniqua>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 03, 2014 at 01:26:34PM -0500, Jon Bernard wrote:
> Hello all,
> 
> A coworker is seeing the following bug when attempting to resize a root
> volume (during init by calling resizefs) from 1GB to the size of the
> underlying partition size of 20GB.
> 
> If the partition size is changed (to i.e. 10GB), the bug seems to not
> trigger.  I have access to this machine, if there are any experiments
> that would provide more useful information - please let me know.

Here are three questions to start:

1)  What kernel version was this oops coming from?

2)  Could you please send me the output of dumpe2fs of the file system?

3)  Can you reproduce the problem?

						- Ted
