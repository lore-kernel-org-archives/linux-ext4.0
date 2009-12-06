From: tytso@mit.edu
Subject: Re: [Bug 14734] New: BUG: unable to handle kernel NULL pointer
 dereference at 0000000000000808
Date: Sat, 5 Dec 2009 22:03:53 -0500
Message-ID: <20091206030353.GA7618@thunk.org>
References: <bug-14734-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:33815 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757800AbZLFVCI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 6 Dec 2009 16:02:08 -0500
Content-Disposition: inline
In-Reply-To: <bug-14734-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 04, 2009 at 03:39:30PM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> 
> Just let me know what else I should post in addition to the following. I've
> gotten this bug pretty consistently, on 2.6.

Hmm.... there's a strnage fsnotify_clear_marks_by_inode() on the stack
trace which doesn't seem to make any sense and which I can't place.
Are you using the fsnotify feature for some reason (i.e., some
new-fangled proprietnary "linux anti-virus" package or some such?).
If so, does the problem go away if you stop using said package and not
use the fsnotify interface?

Also, do you have to do anything special to trigger it?  Is the "rm"
in the process handle an "rm -rf", or some such?

       	       	      	     	      	   - Ted
