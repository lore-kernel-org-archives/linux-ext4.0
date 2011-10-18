From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Check extent overflow with the right range.
Date: Tue, 18 Oct 2011 11:07:45 -0400
Message-ID: <20111018150745.GA17025@thunk.org>
References: <20111017081036.GN30887@longonot.mountain>
 <1318841128-4540-1-git-send-email-tm@tao.ma>
 <20111017141605.GA25017@thunk.org>
 <4E9CE414.9040706@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57307 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932382Ab1JRPHs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 18 Oct 2011 11:07:48 -0400
Content-Disposition: inline
In-Reply-To: <4E9CE414.9040706@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 18, 2011 at 10:27:32AM +0800, Tao Ma wrote:
> We have met with some corruption, but not sure whether it is related to
> this or not. To be honest, we went through the code and find that this
> may be a possible cause. So if you think it could never happen, we are
> OK to drop this patch.

I have no problem adding sanity checks; it makes for more robust code.
I just wanted to make sure there wasn't a real bug hiding somewhere
that wasn't getting addressed.

Thanks,

					- Ted
