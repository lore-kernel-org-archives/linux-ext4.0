From: Theodore Tso <tytso@mit.edu>
Subject: Re: e2fsprogs coverity patch <cid-04.diff>
Date: Mon, 19 Mar 2007 08:32:34 -0400
Message-ID: <20070319123234.GD14519@thunk.org>
References: <200702100211.l1A2BZvu007411@igsi.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, adilger@clusterfs.com,
	wartens2@llnl.gov
To: "Brian D. Behlendorf" <behlendorf1@llnl.gov>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:42150 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965058AbXCSRCy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Mar 2007 13:02:54 -0400
Content-Disposition: inline
In-Reply-To: <200702100211.l1A2BZvu007411@igsi.llnl.gov>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Feb 09, 2007 at 06:11:35PM -0800, Brian D. Behlendorf wrote:
> This check is unnecessary since fs_type is guaranteed to be set earlier in the
> function.
> 
> Coverity ID: 4: Deadcode

The code was actually supposed to be "dead", so in order to restore
the old behavior (from before support for /etc/mke2fs.conf was added)
I needed to move the setting of fs_type of "journal" earlier in the
function.

							- Ted
