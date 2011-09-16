From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 03/25] fsck: fix -C option parsing
Date: Fri, 16 Sep 2011 18:52:50 -0400
Message-ID: <20110916225250.GF16246@thunk.org>
References: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
 <1316206180-6375-4-git-send-email-sandeen@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56143 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755265Ab1IPWwv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Sep 2011 18:52:51 -0400
Content-Disposition: inline
In-Reply-To: <1316206180-6375-4-git-send-email-sandeen@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 16, 2011 at 03:49:18PM -0500, Eric Sandeen wrote:
> The i++; statement is unreachable; fix same as commit
> f1c2eaac535bd9172a35ce39b6d8f392321f274d in util-linux
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Applied, thanks.

					- Ted
