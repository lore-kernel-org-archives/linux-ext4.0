From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 21/25] tests: test e2fsck recovery of corrupt descriptor
 blocks
Date: Thu, 11 Sep 2014 14:18:48 -0400
Message-ID: <20140911181848.GA8366@thunk.org>
References: <20140908231135.25904.66591.stgit@birch.djwong.org>
 <20140908231355.25904.14661.stgit@birch.djwong.org>
 <20140910011529.GG10351@birch.djwong.org>
 <20140911173337.GM10351@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51680 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752949AbaIKSSw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Sep 2014 14:18:52 -0400
Content-Disposition: inline
In-Reply-To: <20140911173337.GM10351@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 11, 2014 at 10:33:37AM -0700, Darrick J. Wong wrote:
> I guess that my interpretation was incorrect; see Jan Kara's reply to "jbd2:
> restart replay without revokes if journal block csum fails".  This test is
> of course still broken, but the patchbomb is fine up through patch #20.

Is patch #22 ok?

					- Ted
