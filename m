From: Theodore Ts'o <tytso@mit.edu>
Subject: Reporting project quota usage?
Date: Wed, 16 Mar 2016 01:29:06 -0400
Message-ID: <20160316052906.GA23610@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.cz, adilger@dilger.ca, linux-ext4@vger.kernel.org
To: pkuelelixi@gmail.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49520 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752226AbcCPF3L (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Mar 2016 01:29:11 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Am I missing something, or do we currently don't have a way to report
project quota usage with ext4?  The support doesn't appear to be in
quota tools, and xfs_quota doesn't work without changes because it
only tries to operate on XFS file systems.

Thanks,

						- Ted
