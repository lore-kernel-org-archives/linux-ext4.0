From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 59/74] debugfs: dump all extended attributes
Date: Sun, 23 Feb 2014 23:10:37 -0500
Message-ID: <20140224041037.GG23946@thunk.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
 <20131211012452.30655.26956.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33272 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751538AbaBXEKj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 23 Feb 2014 23:10:39 -0500
Content-Disposition: inline
In-Reply-To: <20131211012452.30655.26956.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 10, 2013 at 05:24:52PM -0800, Darrick J. Wong wrote:
> Use the new extended attribute APIs to display all extended attributes
> (current code does not look in the EA block) and display full names
> (current code ignores name index too).
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

						- Ted
