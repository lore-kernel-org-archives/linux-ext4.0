From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: create nojournal_checksum mount option
Date: Tue, 25 Nov 2014 16:21:58 -0500
Message-ID: <20141125212158.GD28449@thunk.org>
References: <20141021010501.21404.59849.stgit@birch.djwong.org>
 <20141021010507.21404.59996.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51621 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951AbaKYVV7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Nov 2014 16:21:59 -0500
Content-Disposition: inline
In-Reply-To: <20141021010507.21404.59996.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 20, 2014 at 06:05:07PM -0700, Darrick J. Wong wrote:
> Create a mount option to disable journal checksumming (because the
> metadata_csum feature turns it on by default now), and fix remount not
> to allow changing the journal checksumming option, since changing the
> mount options has no effect on the journal.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
