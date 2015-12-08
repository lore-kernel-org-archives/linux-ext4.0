From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 0/9 v4] ext4: Punch hole and DAX fixes
Date: Mon, 7 Dec 2015 20:08:41 -0500
Message-ID: <20151208010841.GF3094@thunk.org>
References: <1447185059-16166-1-git-send-email-jack@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	dan.j.williams@intel.com, brian.boylston@hpe.com
To: Jan Kara <jack@suse.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:44368 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932114AbbLHBIu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Dec 2015 20:08:50 -0500
Content-Disposition: inline
In-Reply-To: <1447185059-16166-1-git-send-email-jack@suse.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 10, 2015 at 08:50:50PM +0100, Jan Kara wrote:
> Hello,
> 
> Another version of my ext4 fixes. Since previous version I have fixed DAX block
> mapping to really avoid races for parallel page faults so that the test program
> by Brian passes. Note that you'll see ext4/001 failures - xfstests updates were
> submitted. Also note that testing with 1 KB blocksize on ramdisk is broken
> since brd has buggy discard implementation - Jens has a fix queued.

Thanks, I've applied these patches to the ext4 git tree and they are
on the dev branch.

						- Ted
