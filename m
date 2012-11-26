From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [Bug 50981] generic_file_aio_read ?: No locking means DATA
 CORRUPTION read and write on same 4096 page  range
Date: Mon, 26 Nov 2012 08:21:31 -0500
Message-ID: <20121126132131.GA31891@thunk.org>
References: <bug-50981-13602@https.bugzilla.kernel.org/>
 <20121126122608.4F2FC11FB80@bugzilla.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:34799 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754245Ab2KZNVe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 Nov 2012 08:21:34 -0500
Content-Disposition: inline
In-Reply-To: <20121126122608.4F2FC11FB80@bugzilla.kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 26, 2012 at 12:26:08PM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=50981
> 
> Alan <alan@lxorguk.ukuu.org.uk> changed:
> 
>            What    |Removed                     |Added
> ----------------------------------------------------------------------------
>           Component|ext4                        |Other
>          AssignedTo|fs_ext4@kernel-bugs.osdl.or |akpm@linux-foundation.org
>                    |g                           |

Note: now this bug has been removed from linux-ext4, people on the
linux-ext4 mailing list who want to follow this bug will need to
explicitly add themselves to the cc list on the bugzilla.kernel.org.

	       		     	    	 - Ted
