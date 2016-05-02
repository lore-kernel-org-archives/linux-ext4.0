From: Greg KH <greg@kroah.com>
Subject: Re: Backport commit 5e1021f2b6dff
Date: Mon, 2 May 2016 11:50:01 -0700
Message-ID: <20160502185001.GC18236@kroah.com>
References: <20160414133056.GC22053@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: stable@vger.kernel.org, linux-ext4@vger.kernel.org,
	Ted Tso <tytso@mit.edu>,
	Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:43356 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754835AbcEBSuE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 May 2016 14:50:04 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailout.nyi.internal (Postfix) with ESMTP id 1F58C21092
	for <linux-ext4@vger.kernel.org>; Mon,  2 May 2016 14:50:04 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20160414133056.GC22053@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 14, 2016 at 03:30:56PM +0200, Jan Kara wrote:
> Hello,
> 
> I'd like to ask for commit 5e1021f2b6dff (ext4: fix NULL pointer dereference
> in ext4_mark_inode_dirty()) to be pulled into stable kernels as far as
> easily possible (the problem is there at least since 3.0 kernel) since I've
> got report of kernel crashes due to this bug on accidental USB disk
> removal. Thanks!

Applied to 4.4, 4.5, and 3.14-stable trees, thanks.

greg k-h
