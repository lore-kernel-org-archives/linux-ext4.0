From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 01/27] e2fuzz: fix pwrite64/pwrite usage
Date: Sun, 24 Aug 2014 19:56:05 -0400
Message-ID: <20140824235605.GH6236@thunk.org>
References: <20140816234550.11171.61585.stgit@birch.djwong.org>
 <20140816234557.11171.51119.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47057 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753466AbaHXX4J (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 24 Aug 2014 19:56:09 -0400
Content-Disposition: inline
In-Reply-To: <20140816234557.11171.51119.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Aug 16, 2014 at 04:45:57PM -0700, Darrick J. Wong wrote:
> Select pwrite64 or pwrite depending on what autoconf finds.  This
> makes e2fuzz find a suitable pwrite variant regardless of platform.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
