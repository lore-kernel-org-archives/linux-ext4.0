From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] fix awful goto: in ext4_mb_new_blocks()
Date: Thu, 8 Nov 2012 11:18:43 -0500
Message-ID: <20121108161843.GA19977@thunk.org>
References: <50930BC0.6040101@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60090 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756680Ab2KHWVC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Nov 2012 17:21:02 -0500
Content-Disposition: inline
In-Reply-To: <50930BC0.6040101@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 01, 2012 at 06:54:40PM -0500, Eric Sandeen wrote:
> I think the whole function could be made prettier, but
> that goto really took the cake for too-clever-by-half.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Thanks, applied.

					- Ted
