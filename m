From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: ext4_ext_migrate should use NULL not 0
Date: Thu, 30 Dec 2010 08:07:24 -0500
Message-ID: <20101230130724.GM10149@thunk.org>
References: <20101208191610.12168.28421.stgit@paris.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Paris <eparis@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:38593 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754506Ab0L3NHb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 30 Dec 2010 08:07:31 -0500
Content-Disposition: inline
In-Reply-To: <20101208191610.12168.28421.stgit@paris.rdu.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 08, 2010 at 02:16:10PM -0500, Eric Paris wrote:
> ext4_ext_migrate() calls ext4_new_inode() and passes 0 instead of a pointer
> to a struct qstr.  This patch uses NULL, to make it obvious to the caller
> that this was a pointer.
> 
> Signed-off-by: Eric Paris <eparis@redhat.com>

Thanks, applied to the ext4 patch tree.

						- Ted
