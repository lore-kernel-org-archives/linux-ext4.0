From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: introduce ext4_get_group_number()
Date: Tue, 26 Mar 2013 23:44:22 -0400
Message-ID: <20130327034422.GF5861@thunk.org>
References: <1364207051-27037-1-git-send-email-lczerner@redhat.com>
 <1364207051-27037-2-git-send-email-lczerner@redhat.com>
 <20130327031207.GC5861@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56197 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755941Ab3C0Do0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Mar 2013 23:44:26 -0400
Content-Disposition: inline
In-Reply-To: <20130327031207.GC5861@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 26, 2013 at 11:12:07PM -0400, Theodore Ts'o wrote:
> Again, we have the same problem as the previous patch.  I could
> imagine setting a flag which uses the shift-instead-of-div
> optimization, but that will reduce the optimization somewhat.  

Just to be clear, I was thinking that at mount time we could check to
see whether the number of blocks per group == blocksize * 8, and if
so, then set a per-filesystem flag in the sbi structure which we could
then use to optionally use the shift-right optimization.

						- Ted
