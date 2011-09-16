From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 05/25] libext2:  move buf variable completely under
 ifdef
Date: Fri, 16 Sep 2011 18:53:09 -0400
Message-ID: <20110916225309.GH16246@thunk.org>
References: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
 <1316206180-6375-6-git-send-email-sandeen@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56149 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755265Ab1IPWxK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Sep 2011 18:53:10 -0400
Content-Disposition: inline
In-Reply-To: <1316206180-6375-6-git-send-email-sandeen@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 16, 2011 at 03:49:20PM -0500, Eric Sandeen wrote:
> If !WORDS_BIGENDIAN, it is pointless to test whether buf
> is NULL, because it is initialized to NULL and never changed.
> This makes Coverity complain, so we can just move all handling
> of "buf" under the #ifdef.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Applied, thanks.

					- Ted
