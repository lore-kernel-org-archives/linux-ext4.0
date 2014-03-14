From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 14/49] resize2fs: add inline dirs for remapping
Date: Fri, 14 Mar 2014 09:31:41 -0400
Message-ID: <20140314133141.GI8282@thunk.org>
References: <20140311065356.30585.47192.stgit@birch.djwong.org>
 <20140311065527.30585.97471.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41350 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754024AbaCNNbo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 14 Mar 2014 09:31:44 -0400
Content-Disposition: inline
In-Reply-To: <20140311065527.30585.97471.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 10, 2014 at 11:55:27PM -0700, Darrick J. Wong wrote:
> When we're looking for directory blocks for the inode remapping step,
> we need to include inline_data directories in the remap process.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
