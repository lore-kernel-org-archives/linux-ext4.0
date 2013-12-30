From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: debugfs: restore and tweak original error messaging
Date: Mon, 30 Dec 2013 16:45:21 -0500
Message-ID: <20131230214521.GA5693@thunk.org>
References: <20131230034754.GA3599@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:44593 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755518Ab3L3VsY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Dec 2013 16:48:24 -0500
Content-Disposition: inline
In-Reply-To: <20131230034754.GA3599@wallace>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Dec 29, 2013 at 10:47:54PM -0500, Eric Whitney wrote:
> In response to reviewer comments, commit fe56188b07 included changes
> that modified some of the code used to output error messages when
> checking user-supplied block numbers.  These changes converted calls
> to parse_ulonglong() to calls to strtoblk().  Because strtoblk() calls
> parse_ulonglong(), and both output error messages, two redundant and
> relatively generic messages were output on each error.
> 
> Fix this by removing the error message output from strtoblk(), and
> extending it to accept an optional error message argument that it
> supplies in lieu of a default to parse_ulonglong().  Also, revert to
> the more descriptive original error messages with mods per reviewer
> comments, and fix an error message in do_replace_node().
> 
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>

Applied to the maint branch, thanks!!

						- Ted
