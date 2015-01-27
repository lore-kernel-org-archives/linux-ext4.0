From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 03/54] debugfs: fix crash in ea_set argument handling
Date: Tue, 27 Jan 2015 10:58:40 -0500
Message-ID: <20150127155840.GC2453@thunk.org>
References: <20150127073533.13308.44994.stgit@birch.djwong.org>
 <20150127073553.13308.85045.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35276 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758507AbbA0P6l (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 Jan 2015 10:58:41 -0500
Content-Disposition: inline
In-Reply-To: <20150127073553.13308.85045.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 26, 2015 at 11:35:53PM -0800, Darrick J. Wong wrote:
> Fix an incorrect check in ea_set that would crash debugfs if someone
> runs 'ea_set / foo.bar' (i.e. with no value argument)
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
