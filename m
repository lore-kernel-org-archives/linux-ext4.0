From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 14/34] misc: use libmagic when libblkid can't identify
 something
Date: Sun, 21 Sep 2014 01:29:02 -0400
Message-ID: <20140921052902.GB16578@thunk.org>
References: <20140913221112.13646.3873.stgit@birch.djwong.org>
 <20140913221246.13646.27212.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39339 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021AbaIUF3E (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 21 Sep 2014 01:29:04 -0400
Content-Disposition: inline
In-Reply-To: <20140913221246.13646.27212.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Sep 13, 2014 at 03:12:46PM -0700, Darrick J. Wong wrote:
> If we're using check_plausibility() to try to identify something that
> obviously isn't an ext* filesystem and libblkid doesn't know what it
> is, try libmagic instead.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
