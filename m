From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 15/14] libext2fs: remove unnecessary undo file flush calls
Date: Wed, 10 Jun 2015 20:13:57 -0400
Message-ID: <20150611001357.GJ24181@thunk.org>
References: <20150514002108.10785.85860.stgit@birch.djwong.org>
 <20150518211700.GJ30577@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58976 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752193AbbFKCnY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Jun 2015 22:43:24 -0400
Content-Disposition: inline
In-Reply-To: <20150518211700.GJ30577@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 18, 2015 at 02:17:00PM -0700, Darrick J. Wong wrote:
> Remove all flushes of the undo file except for the one that happens just
> prior to the file being closed; it seems that the arbitrary flushes
> aren't sufficiently useful.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

						- Ted
