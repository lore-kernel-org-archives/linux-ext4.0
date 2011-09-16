From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 09/25] uuidd: Add missing break to option case statement
Date: Fri, 16 Sep 2011 18:54:17 -0400
Message-ID: <20110916225417.GL16246@thunk.org>
References: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
 <1316206180-6375-10-git-send-email-sandeen@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56160 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755265Ab1IPWyT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Sep 2011 18:54:19 -0400
Content-Disposition: inline
In-Reply-To: <1316206180-6375-10-git-send-email-sandeen@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 16, 2011 at 03:49:24PM -0500, Eric Sandeen wrote:
> Specifying the "-n" option to uuidd would incorrectly
> fall through to the "-p" case, and assign that number to
> the pidfile_path.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Applied, thanks.

Can you do me a favor and make sure this gets fixed in util-linux-ng
as well?

	 			- Ted
