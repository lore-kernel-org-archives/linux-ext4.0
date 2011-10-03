From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs: include headers for open() in ext2fs.h
Date: Mon, 3 Oct 2011 13:18:01 -0400
Message-ID: <20111003171801.GF6684@thunk.org>
References: <4E89E0D2.5040607@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33942 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756956Ab1JCRSC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Oct 2011 13:18:02 -0400
Content-Disposition: inline
In-Reply-To: <4E89E0D2.5040607@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 03, 2011 at 11:20:34AM -0500, Eric Sandeen wrote:
> ext2fs.h now calls open() so it should include the headers needed
> for this system call as well.
> 
> Addresses-RH-Bugzilla: 742147
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Applied, thanks.

				- Ted
