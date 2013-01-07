From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: e2fsprogs maint branch and metadata_csum option
Date: Mon, 7 Jan 2013 13:53:50 -0500
Message-ID: <20130107185350.GA17250@thunk.org>
References: <20130107180352.GA18255@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42209 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755019Ab3AGSxx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Jan 2013 13:53:53 -0500
Content-Disposition: inline
In-Reply-To: <20130107180352.GA18255@wallace>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 07, 2013 at 01:03:52PM -0500, Eric Whitney wrote:
> In today's concall, I reported an e2fsprogs maint branch test failure I'd
> just seen with Ted's xfstests-bld harness.  When running the
> metadata_csum,64bit scenario, the result was an immediate mkfs failure with
> the following diagnostic: Invalid filesystem option set: metadata_csum,64bit
> 
> The metadata_csum option alone was enough to trigger the error.  However, a
> look at the maint branch code suggests that it doesn't contain the
> metadata_csum support found in the master branch.  I'm guessing my
> expectations about the current state of the maint branch were wrong and that
> we'll pick up the metadata_csum feature on the merge to master?

Yes, the metadata_csum feature will be in the 1.43 release.  I've
deliberately not included that in the maint branch, which is for the
1.42.x maintenance releases.

							- Ted
