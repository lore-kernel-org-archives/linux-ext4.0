From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsck: journal-replay-only
Date: Mon, 6 Dec 2010 17:27:14 -0500
Message-ID: <20101206222714.GB24607@thunk.org>
References: <201011130009.08641.bs_lists@aakef.fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Bernd Schubert <bs_lists@aakef.fastmail.fm>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:47119 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753138Ab0LFW1Q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 6 Dec 2010 17:27:16 -0500
Content-Disposition: inline
In-Reply-To: <201011130009.08641.bs_lists@aakef.fastmail.fm>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Nov 13, 2010 at 12:09:07AM +0100, Bernd Schubert wrote:
> e2fsck: journal-replay-only
> 
> As recently discussed on linux-ext4@vger.kernel.org add an option to e2fsck
> to allow to replay the journal only. That will allow scripts, such as 
> pacemakers 'Filesystem' RA to first replay the journal and if that sets
> an error state from the journal replay, further check for that error 
> (dumpe2fh -h | grep "Filesystem state:") and if that shows and error
> to refuse to mount. It also allows automatic e2fsck scripts to first
> replay the journal and on a second run after the real pass1 to passX checks
> to test for the return code.
> 
> Signed-off-by: Bernd Schubert <bschubert@ddn.com>

Hi Bernd,

My apologies for the delay.  I've made some slight cleanups to your
patch, and committed it to the maint branch.  It will be in e2fsprogs
1.41.13.

Thanks!!

						- Ted
