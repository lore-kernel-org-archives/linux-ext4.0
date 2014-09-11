From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 29/25] e2fsck: expand root dir if linking l+f fails
Date: Thu, 11 Sep 2014 18:10:03 -0400
Message-ID: <20140911221003.GE17990@thunk.org>
References: <20140908231135.25904.66591.stgit@birch.djwong.org>
 <20140911194804.GU10351@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52183 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220AbaIKWKF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Sep 2014 18:10:05 -0400
Content-Disposition: inline
In-Reply-To: <20140911194804.GU10351@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 11, 2014 at 12:48:04PM -0700, Darrick J. Wong wrote:
> If there isn't space in the root directory to add the lost+found
> entry, try expanding the root directory before failing the fsck.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
