From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: respect HAVE_MALLOC_H
Date: Sun, 19 Aug 2012 17:57:44 -0400
Message-ID: <20120819215743.GA25452@thunk.org>
References: <1345328261-3004-1-git-send-email-vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Mike Frysinger <vapier@gentoo.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45723 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717Ab2HSV5q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 19 Aug 2012 17:57:46 -0400
Content-Disposition: inline
In-Reply-To: <1345328261-3004-1-git-send-email-vapier@gentoo.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Aug 18, 2012 at 12:17:41PM -0000, Mike Frysinger wrote:
> Most places respect this define, but this one doesn't.
> 
> Reported-by: Dmitri Bogomolov <4glitch@gmail.com>
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Applied to the maint branch, thanks.

					- Ted
