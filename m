From: Theodore Tso <tytso@thunk.org>
Subject: Re: [PATCH] fix check_mntent_file() to pass mode for open(O_CREAT)
Date: Sat, 1 Dec 2007 07:11:19 -0500
Message-ID: <20071201121119.GE28558@thunk.org>
References: <20071109012015.GA14612@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:48412 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751814AbXLARfd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 1 Dec 2007 12:35:33 -0500
Content-Disposition: inline
In-Reply-To: <20071109012015.GA14612@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 08, 2007 at 06:20:15PM -0700, Andreas Dilger wrote:
> On my FC8 install, ismounted.c fails to build because open(O_CREAT) is
> used without passing a mode.  The following trivial patch fixes it.
> 
> Signed-off-by: Andreas Dilger <adilger@dilger.ca>

Thanks, applied.

						- Ted
