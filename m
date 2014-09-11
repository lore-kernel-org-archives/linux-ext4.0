From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 07/25] tune2fs: explicitly disallow tuning of journal
 devices
Date: Thu, 11 Sep 2014 12:44:08 -0400
Message-ID: <20140911164408.GO26178@thunk.org>
References: <20140908231135.25904.66591.stgit@birch.djwong.org>
 <20140908231221.25904.95895.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, TR Reardon <thomas_reardon@hotmail.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51474 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755845AbaIKQoK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Sep 2014 12:44:10 -0400
Content-Disposition: inline
In-Reply-To: <20140908231221.25904.95895.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 08, 2014 at 04:12:21PM -0700, Darrick J. Wong wrote:
> Spit out a more specific error if someone tries to modify an
> external journal device.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reported-by: TR Reardon <thomas_reardon@hotmail.com>

Applied, thanks.

					- Ted
