From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 07/25] e2fsck: handle null fs in print_pathname()
Date: Fri, 16 Sep 2011 18:53:32 -0400
Message-ID: <20110916225332.GJ16246@thunk.org>
References: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
 <1316206180-6375-8-git-send-email-sandeen@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56155 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755265Ab1IPWxe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Sep 2011 18:53:34 -0400
Content-Disposition: inline
In-Reply-To: <1316206180-6375-8-git-send-email-sandeen@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 16, 2011 at 03:49:22PM -0500, Eric Sandeen wrote:
> testing fs for NULL in expand_percent_expression():
> 
> 	e2fsck_ctx = fs ? (e2fsck_t) fs->priv_data : NULL;
> 
> implies that fs could be NULL, but it's passed to print_pathname()
> which defererences it without further testing.
> 
> So make this safe by returning "???" for a nul fs.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Applied, thanks.

					- Ted
