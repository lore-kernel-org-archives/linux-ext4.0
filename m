From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/4] ext4: validate external journal superblock checksum
Date: Thu, 11 Sep 2014 11:47:27 -0400
Message-ID: <20140911154727.GE26178@thunk.org>
References: <20140911002818.10109.51772.stgit@birch.djwong.org>
 <20140911002831.10109.84707.stgit@birch.djwong.org>
 <20140911132554.GC30901@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51271 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756601AbaIKPr3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Sep 2014 11:47:29 -0400
Content-Disposition: inline
In-Reply-To: <20140911132554.GC30901@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 11, 2014 at 03:25:54PM +0200, Jan Kara wrote:
> On Wed 10-09-14 17:28:32, Darrick J. Wong wrote:
> > If the external journal device has metadata_csum enabled, verify
> > that the superblock checksum matches the block before we try to
> > mount.
>   Looks good. You can add:
> Reviewed-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
