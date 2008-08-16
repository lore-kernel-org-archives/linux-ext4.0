From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH, RFC] ext4: flex_bg ialloc, don't pick "best_flex" with
	0 inodes
Date: Sat, 16 Aug 2008 11:25:41 -0400
Message-ID: <20080816152541.GB8422@mit.edu>
References: <48A5FCA6.5070902@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	"Jose R. Santos" <jrs@us.ibm.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:41723 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751768AbYHPPZp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 16 Aug 2008 11:25:45 -0400
Content-Disposition: inline
In-Reply-To: <48A5FCA6.5070902@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 15, 2008 at 05:01:10PM -0500, Eric Sandeen wrote:
> It seems like adjusting the following test is a better plan;
> for starters I do not see that best_flex can ever be < 0, so

Given that ext4_group_t is an unsigned long, that's certainly true.
:-)

> that test is replaced, and if the current "best" flex group
> has no inodes free, and the current one does have room,
> it is promoted to the next "best."

Looks good to me.  I've added it to the patch queue.

> Signed-of-by: Eric Sandeen <sandeen@redhat.com>

(forgot an 'f' :-)

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

					- Ted
