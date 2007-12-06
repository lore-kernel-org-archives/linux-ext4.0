From: Andreas Dilger <adilger@sun.com>
Subject: Re: Test script for 64KB blocksize
Date: Thu, 6 Dec 2007 11:35:22 -0700
Message-ID: <20071206183522.GN3604@webber.adilger.int>
References: <20071206142120.GC6396@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:50240 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794AbXLFSfY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Dec 2007 13:35:24 -0500
Content-Disposition: inline
In-Reply-To: <20071206142120.GC6396@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Dec 06, 2007  15:21 +0100, Jan Kara wrote:
>   attached is a test script which verifies that 64KB blocksize works in the
> modified code paths. It creates a filesystem with 64KB blocksize and
> excercises e2image, debugfs (and thus libext2fs) and e2fsck on it. You only
> need to modify paths to e2fsprogs in the first few lines of the script.
>   Also if you don't apply a patch for 2-block lost+found from Andreas, you
> need to disable the first test which would fail otherwise.

This would be well suited to be added to e2fsprogs/tests with what looks
to be relatively few changes.  That would ensure that it runs forever
in the future.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
