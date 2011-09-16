From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 04/25] mke2fs: remove impossible tests for null
 usage_types
Date: Fri, 16 Sep 2011 18:52:59 -0400
Message-ID: <20110916225259.GG16246@thunk.org>
References: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
 <1316206180-6375-5-git-send-email-sandeen@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56146 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755265Ab1IPWxA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Sep 2011 18:53:00 -0400
Content-Disposition: inline
In-Reply-To: <1316206180-6375-5-git-send-email-sandeen@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 16, 2011 at 03:49:19PM -0500, Eric Sandeen wrote:
> parse_fs_type explicitly sets usage_types if it is null,
> so there is no need to test for null later.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Applied, thanks.

					- Ted
