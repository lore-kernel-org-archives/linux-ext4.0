From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] libext2fs: fix return value
Date: Sat, 4 May 2013 22:52:56 -0400
Message-ID: <20130505025256.GA26201@thunk.org>
References: <1367643954-31340-1-git-send-email-vapier@gentoo.org>
 <20130504235503.GC5948@thunk.org>
 <201305042058.55976.vapier@gentoo.org>
 <3CC14044-0A69-48EA-90C7-CF173F6A8A42@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mike Frysinger <vapier@gentoo.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46373 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751041Ab3EECxG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 4 May 2013 22:53:06 -0400
Content-Disposition: inline
In-Reply-To: <3CC14044-0A69-48EA-90C7-CF173F6A8A42@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, May 04, 2013 at 08:40:21PM -0600, Andreas Dilger wrote:
> > ok, the use of "master" and "next" is weird.  i was using the normal "master" 
> > branch which is apparently out of date.
> 
> I'd have to agree. It would be great if master was merged from maint more often so that patches would apply to either.

Sorry, I merge maint into next, but sometimes I forget to bump master
up.

Fixed now.

						- Ted
