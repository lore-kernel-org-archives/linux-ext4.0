From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 55/54] e2fsck: actually fix inline_data flags problems
 when user says to do so
Date: Sun, 29 Mar 2015 00:05:10 -0400
Message-ID: <20150329040510.GF19097@thunk.org>
References: <20150127073533.13308.44994.stgit@birch.djwong.org>
 <20150319214449.GJ11031@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38585 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775AbbC2EFN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 29 Mar 2015 00:05:13 -0400
Content-Disposition: inline
In-Reply-To: <20150319214449.GJ11031@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 19, 2015 at 02:44:49PM -0700, Darrick J. Wong wrote:
> fix_problem() returning 1 means to fix the fs error, so do that.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
