From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] tests: for mktemp the exes must be the final characters
 of the name
Date: Mon, 9 Jun 2014 10:49:01 -0400
Message-ID: <20140609144901.GE8418@thunk.org>
References: <1401884926-31722-1-git-send-email-bensberg@justemail.net>
 <850D72EC-599B-458C-BBE1-22E6A0F74E92@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Benno Schulenberg <bensberg@justemail.net>,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57570 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932348AbaFIOtF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Jun 2014 10:49:05 -0400
Content-Disposition: inline
In-Reply-To: <850D72EC-599B-458C-BBE1-22E6A0F74E92@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 04, 2014 at 04:31:21PM -0600, Andreas Dilger wrote:
> 
> I also notice that there are occasional e2fsprogs-tmp.XXXXXX files left
> behind in /tmp after testing, and it would be nice if they contained the
> test name so they can be found if there is a problem.

I looked into this and it was caused by bugs in the mmp tests.  They
were setting TMPFILE without using mktemp, and overriding the TMPFILE
already set up by the test infrastructure.

The other reason why we have left-over temp files is caused by someone
interrupting the "make check" run.

						- Ted


