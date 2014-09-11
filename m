From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 00/25] e2fsprogs Summer 2014 patchbomb, part 5.2
Date: Thu, 11 Sep 2014 18:52:23 -0400
Message-ID: <20140911225223.GJ17990@thunk.org>
References: <20140908231135.25904.66591.stgit@birch.djwong.org>
 <20140911223347.GH17990@thunk.org>
 <20140911225022.GA10351@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52289 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752186AbaIKWwZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Sep 2014 18:52:25 -0400
Content-Disposition: inline
In-Reply-To: <20140911225022.GA10351@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 11, 2014 at 03:50:22PM -0700, Darrick J. Wong wrote:
> 
> Looks like most everything landed ok except for:
> 
> Yikes, make check explodes:

Hmm, works for me.  Could you make sure you've done a "make clean" and
also a "git clean"?  In particular, make sure you don't have a
leftover file in debugfs/jfs_user.h....

							- Ted
