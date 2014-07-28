From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Question: errors=continue behaviour for failed external journal
 device
Date: Mon, 28 Jul 2014 11:00:26 -0400
Message-ID: <20140728150026.GA17378@thunk.org>
References: <loom.20140727T010632-633@post.gmane.org>
 <20140727000733.GV6725@thunk.org>
 <alpine.LFD.2.00.1407281107530.2077@localhost.localdomain>
 <20140728131742.GP6725@thunk.org>
 <alpine.LFD.2.00.1407281522110.2077@localhost.localdomain>
 <53D65099.6010901@dobrotescu.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org
To: Vlad Dobrotescu <vlad@dobrotescu.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:60760 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752900AbaG1PAa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jul 2014 11:00:30 -0400
Content-Disposition: inline
In-Reply-To: <53D65099.6010901@dobrotescu.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 28, 2014 at 09:31:05AM -0400, Vlad Dobrotescu wrote:
> If you are talking about changes, wouldn't "read-only" be a better fall-back
> alternative for a failed or missing external journal?

For a missing external journal, we simply wouldn't allow the mount to
succeed at all.

The discussion here was about what to do if we detect some kind of
inconsistency in a mounted file system.

Cheers,

					- Ted
