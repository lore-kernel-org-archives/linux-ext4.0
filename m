From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH][e2fsprogs] add -E option to mke2fs usage information
Date: Mon, 15 Oct 2007 17:00:49 -0400
Message-ID: <20071015210049.GB18006@thunk.org>
References: <471376DF.5010705@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Coly Li <coyli@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:34922 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756919AbXJOVB1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Oct 2007 17:01:27 -0400
Content-Disposition: inline
In-Reply-To: <471376DF.5010705@suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Oct 15, 2007 at 10:19:11PM +0800, Coly Li wrote:
> -E option is missed from usage information of mke2fs. This patch adds -E option to usage
> information, and names -E|-R as extended-option.
> Now the usage information can be consistent with mke2fs.8.in.

Please fill comments to 80 columns; thanks!!

I checked this into the maint branch, but I just changed the message
to use -E only.  The use of -R is deprecated, but supported for
backwards compatibility; so there's no point putting it in the usage
message.

							- Ted
