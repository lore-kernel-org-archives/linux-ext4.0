From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v3] ext4: ignore EXT4_INODE_JOURNAL_DATA flag with
 delalloc
Date: Mon, 23 Jan 2012 17:47:09 -0500
Message-ID: <20120123224709.GA18911@thunk.org>
References: <20120119165007.GA32029@thunk.org>
 <1327061459-20610-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43148 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752363Ab2AWXmQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Jan 2012 18:42:16 -0500
Content-Disposition: inline
In-Reply-To: <1327061459-20610-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 20, 2012 at 01:10:59PM +0100, Lukas Czerner wrote:
> Ext4 does not support data journalling with delayed allocation enabled.
> We even do not allow to mount the file system with delayed allocation
> and data journalling enabled, however it can be set via FS_IOC_SETFLAGS
> so we can hit the inode with EXT4_INODE_JOURNAL_DATA set even on file
> system mounted with delayed allocation (default) and that's where
> problem arises....
>
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Thanks, applied.

						- Ted
