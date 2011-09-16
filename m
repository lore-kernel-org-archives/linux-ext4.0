From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 10/25] freefrag: fix up getopt case statement
Date: Fri, 16 Sep 2011 18:54:30 -0400
Message-ID: <20110916225429.GM16246@thunk.org>
References: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
 <1316206180-6375-11-git-send-email-sandeen@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56164 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755621Ab1IPWyb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Sep 2011 18:54:31 -0400
Content-Disposition: inline
In-Reply-To: <1316206180-6375-11-git-send-email-sandeen@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 16, 2011 at 03:49:25PM -0500, Eric Sandeen wrote:
> There is no need to print out a "bad option" message; getopt
> does that for us, and in fact will change "c" to "?" so
> it's not even useful.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Applied, thanks.

					- Ted
