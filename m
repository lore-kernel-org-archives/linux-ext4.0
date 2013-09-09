From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 6/6] resize2fs: Convert fs to and from 64bit mode
Date: Mon, 9 Sep 2013 13:47:22 -0400
Message-ID: <20130909174722.GA403@thunk.org>
References: <20130829004344.3190.28053.stgit@blackbox.djwong.org>
 <20130829004423.3190.78720.stgit@blackbox.djwong.org>
 <20130909172944.GA4547@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57135 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755207Ab3IIRr0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Sep 2013 13:47:26 -0400
Content-Disposition: inline
In-Reply-To: <20130909172944.GA4547@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 09, 2013 at 10:29:44AM -0700, Darrick J. Wong wrote:
> Found some bugs in this; I'll repost the series (without the patches Ted just
> merged) in a few days.

Patches 1 and 2 were merged into the maint branch.  I will review and
merge patches 3-5 into the 1.43 branches (master/next), and I'll hold
off on patch #6.

Cheers,

						- Ted
