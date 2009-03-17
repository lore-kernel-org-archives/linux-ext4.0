From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH V3] fix bb_prealloc_list corruption due to wrong group
	locking
Date: Mon, 16 Mar 2009 23:30:42 -0400
Message-ID: <20090317033042.GC15989@mit.edu>
References: <49BAD6D9.3010505@redhat.com> <49BE82A9.4000407@redhat.com> <49BE8C30.5030901@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:57292 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751883AbZCQDap (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Mar 2009 23:30:45 -0400
Content-Disposition: inline
In-Reply-To: <49BE8C30.5030901@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 16, 2009 at 12:28:16PM -0500, Eric Sandeen wrote:
> This is for Red Hat bug 490026,
> EXT4 panic, list corruption in ext4_mb_new_inode_pa

Thanks, applied to the ext4 tree.

						- Ted

