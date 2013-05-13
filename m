From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: EXT4 panic at jbd2_journal_put_journal_head() in 3.9+
Date: Sun, 12 May 2013 23:36:55 -0400
Message-ID: <20130513033655.GE25996@thunk.org>
References: <7032562.14371368411664268.JavaMail.weblogic@epml07>
 <CA+8MBb+51dMaYQd-g-T40+UstbxsSbmewSXiUfNDrVouSA3=Zw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: eunb.song@samsung.com, Dmitry Monakhov <dmonakhov@openvz.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Tony Luck <tony.luck@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:47882 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751929Ab3EMDhD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 12 May 2013 23:37:03 -0400
Content-Disposition: inline
In-Reply-To: <CA+8MBb+51dMaYQd-g-T40+UstbxsSbmewSXiUfNDrVouSA3=Zw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, May 12, 2013 at 08:11:59PM -0700, Tony Luck wrote:
> 
> My best guess as to why this commit causes problems is that there are places
> where updates to individual fields in this structure used to be independent
> because they were to whole words.  Now we have bitfileds there are races
> between access to different fields in the same word.

Yeah, except we access the fields while holding a lock.... wait a
minute.  We're using bit_spinlocks().... and am I missing something?

Where are the barrier statements to prevent the CPU or the compiler
from reordering statements around bit_spin_lock()?  But if that's the
problem, I would have expected lots of other things to be broken.

	   	      	       	       	     - Ted
