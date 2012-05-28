From: Ted Ts'o <tytso@mit.edu>
Subject: Re: libquota: add a quotactl prototype
Date: Mon, 28 May 2012 10:20:32 -0400
Message-ID: <20120528142032.GA1578@thunk.org>
References: <1337715689-7116-1-git-send-email-vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, adilger@whamcloud.com
To: Mike Frysinger <vapier@gentoo.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45957 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754938Ab2E1OUf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 May 2012 10:20:35 -0400
Content-Disposition: inline
In-Reply-To: <1337715689-7116-1-git-send-email-vapier@gentoo.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 22, 2012 at 09:41:29AM -0000, Mike Frysinger wrote:
> The commit 0df8a27bbaf51b55c0e8c3a533ef4c2ff9d79c9f removed the system
> quota.h include, but in doing so, added the problem:
> mkquota.c:55:2: warning: implicit declaration of function 'quotactl'
> 
> Since we're maintaining a copy of quota.h, add a proper func prototype.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Thanks, applied.

						- Ted
