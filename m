From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 02/25] e2fsprogs: Remove impossible name_len tests.
Date: Fri, 16 Sep 2011 18:52:37 -0400
Message-ID: <20110916225237.GE16246@thunk.org>
References: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
 <1316206180-6375-3-git-send-email-sandeen@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:47622 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755265Ab1IPWwi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Sep 2011 18:52:38 -0400
Content-Disposition: inline
In-Reply-To: <1316206180-6375-3-git-send-email-sandeen@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 16, 2011 at 03:49:17PM -0500, Eric Sandeen wrote:
> The name_len field in ext2_dir_entry is actually comprised of
> the name length in the lower 8 bytes, and the filetype in the
> high 8 bytes.  So in places, we mask name_len with 0xFF to
> get the actual length.
> 
> But once we have masked name_len with 0xFF, there is no point
> in testing whether it is greater than EXT2_NAME_LEN, which
> is 255 - or 0xFF.  So all of these tests are extraneous.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Applied, thanks.

					- Ted
