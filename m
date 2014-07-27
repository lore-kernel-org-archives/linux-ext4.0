From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Question: errors=continue behaviour for failed external journal
 device
Date: Sat, 26 Jul 2014 21:07:27 -0400
Message-ID: <20140727010727.GX6725@thunk.org>
References: <loom.20140727T010632-633@post.gmane.org>
 <20140727000733.GV6725@thunk.org>
 <53D44925.4000903@dobrotescu.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Vlad Dobrotescu <vlad@dobrotescu.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58952 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227AbaG0BH3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 26 Jul 2014 21:07:29 -0400
Content-Disposition: inline
In-Reply-To: <53D44925.4000903@dobrotescu.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jul 26, 2014 at 08:34:45PM -0400, Vlad Dobrotescu wrote:
> 
> Thanks for the quick and detailed answer. If I understand it correctly,
> the errors= option has nothing to do with journaling, but only with FS
> consistency issues (which can be caused by a vanished journal,

The errors= option has to do with how the system will react when it
discovered a file system inconsistency (for example, while deleting a
file, it discovers that the blocks it is trying to free are already
freed, etc.)  errors=continue is the "don't worry, be happy" option
--- and this can sometimes work out, it's much like ignoring a late
mortgage payment notice from the bank.  Most of the time, sooner or
later, it catches up to you.  :-)

> by other events), while the mounting itself fails in the absence of the
> device specified for external journaling, with no fall-back alternative.

Your question about what happens if the journal is missing is much
like the question, "suppose as I have a RAID 0 setup, and I'm missing
one of the disks --- what can we do"?  Basically, nothing.  In a
desperation scenario, there are ways you can forcibly tell the system
to pretend that there is no journal, just like you can pretend that
the system should ignore 20% of a missing RAID 0 array and have the
LVM replace the missing disk with zero blocks --- but results are very
likely to lead to data loss.

Cheers,

					- Ted
