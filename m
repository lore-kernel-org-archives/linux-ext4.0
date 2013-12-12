From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 21/74] e4defrag: don't crash if umounts the filesystem
 races with us
Date: Thu, 12 Dec 2013 13:08:07 -0500
Message-ID: <20131212180807.GR13547@thunk.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
 <20131211012040.30655.381.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39419 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750840Ab3LLSIJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Dec 2013 13:08:09 -0500
Content-Disposition: inline
In-Reply-To: <20131211012040.30655.381.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 10, 2013 at 05:20:40PM -0800, Darrick J. Wong wrote:
> If someone umounts the filesystem between statfs64 and the getmntent()
> iteration, we can exit the loop having never set mnt_type, and strcmp
> can crash.  Fix the potential NULL deref.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
