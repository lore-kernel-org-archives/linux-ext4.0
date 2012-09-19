From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC][PATCH 3/8 v2] ext4: initialize extent status tree
Date: Wed, 19 Sep 2012 14:53:38 -0400
Message-ID: <20120919185338.GD28470@thunk.org>
References: <1345615545-26133-1-git-send-email-wenqing.lz@taobao.com>
 <1345615545-26133-4-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Allison Henderson <achender@linux.vnet.ibm.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1345615545-26133-4-git-send-email-wenqing.lz@taobao.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Aug 22, 2012 at 02:05:40PM +0800, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> Let ext4 initialize extent status tree of an inode.
> 
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
> Signed-off-by: Allison Henderson <achender@linux.vnet.ibm.com>
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>

One general comment --- "Signed-off-by" should only be used when
someone actually handles a patch; that is, you add the Signed-off-by
for yourself if you originally wrote the patch, or if you started with
someone else's patch and modified it.

If you merely reviewed the patch, you can request that the patch
author add a "Reviewed-by: " header.

The other footer that you will sometimes see is "Acked-by: ".  This
gets used by subsystem maintainers who approve of a patch, but instead
of their handling the patch, they are going to let the patch flow into
the upstream via some other tree.

So for example, Lukas's invalidate_page_range patch set will require
an "Acked-by: " footer from the XFS, OCFS2, and mm maintainers for
those commits which touch their subsystems.  Once we've gotten an OK
from those folks, then when I accept those patches into the ext4 tree,
I will add my "Signed-off-by: " header since the patches flowed
through my tree.

These are minor points, but Linus will sometimes complain if these
footers aren't used correctly, since Signed-off-by: does have a very
specific legal meaning.  See: http://elinux.org/Developer_Certificate_Of_Origin

In any case, I've changed the Signed-off-by footers for Yongqiang Yang
and Allison Heanderson to be "Reviewed-by: ", in the commit
descriptions, since I believe that should be the more appropriate
footer to be using in this case.  (If you did actually use some code
from Yongqiang or Allison from patches which they had previously sent
with a DCO, then Signed-off-by would be correct.  Let me know if
that's the case....)

Regards,

						- Ted

