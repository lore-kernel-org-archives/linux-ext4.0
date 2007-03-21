From: Theodore Tso <tytso@mit.edu>
Subject: Re: e2fsprogs coverity patch <cid-11.diff>
Date: Wed, 21 Mar 2007 14:54:45 -0400
Message-ID: <20070321185445.GA17405@thunk.org>
References: <200702100211.l1A2B9wF007009@igsi.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, adilger@clusterfs.com,
	wartens2@llnl.gov
To: "Brian D. Behlendorf" <behlendorf1@llnl.gov>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:37405 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933584AbXCUSyx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 Mar 2007 14:54:53 -0400
Content-Disposition: inline
In-Reply-To: <200702100211.l1A2B9wF007009@igsi.llnl.gov>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Feb 09, 2007 at 06:11:09PM -0800, Brian D. Behlendorf wrote:
> Add an extra byte to EXT2_NAME_LEN in the static allocation for the
> required trailing null.  This allows filenames up to the maximum
> length of EXT2_NAME_LEN withover an overrun.
> 
> Coverity ID: 11: Overrun Static
> 
> -	thislen = ((dirent->name_len & 0xFF) < EXT2_NAME_LEN) ?
> +	thislen = ((dirent->name_len & 0xFF) <= EXT2_NAME_LEN) ?
>  		(dirent->name_len & 0xFF) : EXT2_NAME_LEN;

This change is largely meaningless/unnecessary, since if
*dirent->name_len & 0xFF) is equal to EXT2_NAME_LEN it doesn't matter
which path is chosen; was there a reason for the change.

					- Ted
