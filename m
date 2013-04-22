From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/3] e2image: Remove useless exit call
Date: Sun, 21 Apr 2013 23:23:05 -0400
Message-ID: <20130422032305.GB12221@thunk.org>
References: <1363425205-10970-1-git-send-email-tracek@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Tomas Racek <tracek@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43351 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754495Ab3DVDXK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 21 Apr 2013 23:23:10 -0400
Content-Disposition: inline
In-Reply-To: <1363425205-10970-1-git-send-email-tracek@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Mar 16, 2013 at 10:13:23AM +0100, Tomas Racek wrote:
> Exit is called right after the install_image anyway so this one can
> be removed.
> 
> Signed-off-by: Tomas Racek <tracek@redhat.com>

Thanks, applied.

					- Ted
