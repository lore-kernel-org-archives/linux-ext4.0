From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] debugfs: initialize inode to 0 in list_dir_proc() if
 no inode nr
Date: Sun, 25 Sep 2011 00:50:41 -0400
Message-ID: <20110925045041.GA27089@thunk.org>
References: <4E73F982.3020806@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:35392 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736Ab1IYEup (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 25 Sep 2011 00:50:45 -0400
Content-Disposition: inline
In-Reply-To: <4E73F982.3020806@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 16, 2011 at 08:36:02PM -0500, Eric Sandeen wrote:
> If (!ino), the inode will be uninitialized when we print it
> in the PARSE_OPT case.
> 
> So do the same as the LONG_OPT case, and memset it to 0 if
> (!ino).
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Applied, thanks

					- Ted
