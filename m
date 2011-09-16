From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 06/25] libext2fs: Potential null ptr deref in
 undo_err_handler_init
Date: Fri, 16 Sep 2011 18:53:21 -0400
Message-ID: <20110916225321.GI16246@thunk.org>
References: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
 <1316206180-6375-7-git-send-email-sandeen@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56152 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755265Ab1IPWxW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Sep 2011 18:53:22 -0400
Content-Disposition: inline
In-Reply-To: <1316206180-6375-7-git-send-email-sandeen@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 16, 2011 at 03:49:21PM -0500, Eric Sandeen wrote:
> In the !undo_io_backing_manager case, undo_err_handler_init
> will be passed a null data->real, which will be dereferenced.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Applied, thanks.

				- Ted
