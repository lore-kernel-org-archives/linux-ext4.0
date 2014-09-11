From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 30/25] libext2fs: check ea value offset when loading
Date: Thu, 11 Sep 2014 18:11:29 -0400
Message-ID: <20140911221129.GF17990@thunk.org>
References: <20140908231135.25904.66591.stgit@birch.djwong.org>
 <20140911201744.GV10351@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52190 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbaIKWLa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Sep 2014 18:11:30 -0400
Content-Disposition: inline
In-Reply-To: <20140911201744.GV10351@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 11, 2014 at 01:17:44PM -0700, Darrick J. Wong wrote:
> When reading extended attributes, check e_value_offs to make sure that
> it starts in the value area and not the name area.  The attached test
> case image will crash the kernel if it is mounted and you append more
> than 4096 bytes of data to /a, due to insufficient validation.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

						- Ted
