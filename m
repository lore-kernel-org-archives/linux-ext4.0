From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Documenatation: remove acl and user_xattr mount
 options
Date: Sat, 8 Oct 2011 14:02:05 -0400
Message-ID: <20111008180205.GF7948@thunk.org>
References: <1309274477-451-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50183 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753264Ab1JHSCL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 8 Oct 2011 14:02:11 -0400
Content-Disposition: inline
In-Reply-To: <1309274477-451-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 28, 2011 at 05:21:17PM +0200, Lukas Czerner wrote:
> Acl and user_xattr mount options are no longer needed since those
> features are enabled by default if configured in (seee commit
> ea6633369458992241599c9d9ebadffaeddec164). We can not easily
> deprecate mount options itself (since it is probably too early),
> but we can remove it from documentation first.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Applied, thanks.

					- Ted
