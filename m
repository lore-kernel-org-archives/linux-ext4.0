From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] ext4:Teach ext4_ext_split to caculate extents
 efficiently.
Date: Wed, 25 May 2011 18:02:33 -0400
Message-ID: <20110525220233.GD9520@thunk.org>
References: <1306143057-16962-1-git-send-email-xiaoqiangnk@gmail.com>
 <20110524210721.GD26055@thunk.org>
 <BANLkTimbiL07BQyF8rgoBVh4apY5ZJdiCA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50804 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753241Ab1EYWCf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 May 2011 18:02:35 -0400
Content-Disposition: inline
In-Reply-To: <BANLkTimbiL07BQyF8rgoBVh4apY5ZJdiCA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 25, 2011 at 10:02:37AM +0800, Yongqiang Yang wrote:
> path[i]p_idx is mutated to EXT_MAX_INDEX(path[i].p_hdr) + 1, it is
> meaningless.  ext4_ext_split() is used only by
> ext4_ext_create_new_leaf() which drops the path after ext4_ext_split()
> returns, so the path[i].p_idx is no longer used.
> 
> I had tested the patch with fsx.  I am not sure if this test is
> enough.  If you want more tests, I can do it.

OK, thanks for the explanation.  Sometimes testing doesn't find
problems, so I try to understand the patch and make sure it is sane.
I noticed that your path[i].p_ext and path[i].p_idx were no longer
being updated with your patch; I was able to convince myself that
p_ext didn't matter, but I wasn't entirely sure about p_idx, so that's
why I asked you.

I've added it to the ext4 dev tree.

					- Ted
