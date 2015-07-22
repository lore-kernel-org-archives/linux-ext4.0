From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Reject mount an ext2 filesystem with journal
 options
Date: Tue, 21 Jul 2015 23:58:47 -0400
Message-ID: <20150722035847.GE2944@thunk.org>
References: <1435334609-23192-1-git-send-email-cmaiolino@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Carlos Maiolino <cmaiolino@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51616 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932537AbbGVD6t (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 21 Jul 2015 23:58:49 -0400
Content-Disposition: inline
In-Reply-To: <1435334609-23192-1-git-send-email-cmaiolino@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 26, 2015 at 01:03:29PM -0300, Carlos Maiolino wrote:
> There is no reason to allow ext2 filesystems be mounted with journal mount
> options. So, this patch adds them to the MOPT_NO_EXT2 mount options list.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

Applied, thanks.

					- Ted
