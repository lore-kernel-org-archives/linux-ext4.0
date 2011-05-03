From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [Bug 34302] New: Errors from kjournald
Date: Tue, 3 May 2011 11:01:48 -0400
Message-ID: <20110503150148.GB6462@thunk.org>
References: <bug-34302-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50972 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740Ab1ECPBv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 May 2011 11:01:51 -0400
Content-Disposition: inline
In-Reply-To: <bug-34302-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

You've given us a bunch of stack dumps, but not the explanation of why
kernel dumped them.  There should have been a few more informative
messages before the stack dumps in your syslog.  I'm going to guess it
was a soft lockup warning message, perhaps?

						 - Ted
