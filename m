From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: Fix waiting and sending of a barrier in
 ext4_sync_file()
Date: Sun, 22 May 2011 17:12:39 -0400
Message-ID: <20110522211239.GB10009@thunk.org>
References: <1305628095-27843-1-git-send-email-jack@suse.cz>
 <1305628095-27843-3-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Edward Goggin <egoggin@vmware.com>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43143 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754124Ab1EVVMo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 22 May 2011 17:12:44 -0400
Content-Disposition: inline
In-Reply-To: <1305628095-27843-3-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 17, 2011 at 12:28:15PM +0200, Jan Kara wrote:
> This code change will cause ext4_sync_file() to unnecessarily issue
> a barrier in data=ordered and data=journal mode with external
> journal but solving this would require ext4 to mess with jbd2
> internals since jbd2 does not know about ext4 data journalling
> modes.

I really don't like this.  I think the following two patches should
address this.  Could you take a look please?

-- Ted
