From: Theodore Tso <tytso@mit.edu>
Subject: Re: Scripting e2fsck: no errors, but still exit code 1 "FILE
	SYSTEM WAS MODIFIED"
Date: Sun, 18 May 2008 08:28:53 -0400
Message-ID: <20080518122853.GB31413@mit.edu>
References: <483006F1.6080008@tuxes.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Bas van Schaik <bas@tuxes.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:59352 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763492AbYERM3I (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 18 May 2008 08:29:08 -0400
Content-Disposition: inline
In-Reply-To: <483006F1.6080008@tuxes.nl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, May 18, 2008 at 12:37:37PM +0200, Bas van Schaik wrote:
> However, there is a slight
> problem with scripting e2fsck: it seems that e2fsck /always/ exits with
> exit code 1 just because of the fact that the snapshot journal has been
> replayed. Because of this, the script cannot tell whether there is a
> real problem or not and keeps e-mailing me. This is a typical output of
> such an e2fsck run:

Simply replying the journal should not cause e2fsck to have an exit
code of 1.  It must have done something else.  The common one was
clearing the LARGE_FILES feature flag if the filesystem didn't have
one, but that was removed as of 1.40.7.  Can you take a snapshot, run
dumpe2fs, run e2fsck -fy /dev/loop1, and then run dumpe2fs again, and
send me a before and after?

						- Ted
