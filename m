From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 1/3] ext4: Properly initialize the buffer_head state
Date: Mon, 11 May 2009 07:31:06 -0400
Message-ID: <20090511113106.GE29082@mit.edu>
References: <1241692770-22547-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <4A02FC3A.9000806@redhat.com> <20090510235741.GA3980@mit.edu> <20090511092443.GA6459@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, cmm@us.ibm.com,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:43818 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409AbZEKLbJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 May 2009 07:31:09 -0400
Content-Disposition: inline
In-Reply-To: <20090511092443.GA6459@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 11, 2009 at 02:54:43PM +0530, Aneesh Kumar K.V wrote:
> On Sun, May 10, 2009 at 07:57:41PM -0400, Theodore Tso wrote:
> > On Thu, May 07, 2009 at 10:20:26AM -0500, Eric Sandeen wrote:
> > > Aneesh Kumar K.V wrote:
> > > > These buffer_heads are allocated on stack and are
> > > > used only to make get_blocks calls. So we can set the
> > > > b_state to 0
> > > > 
> > > > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> > > 
> > > I'd noticed this too, thanks for fixing up.
> > 
> > Is this just a clean-up, or does this fix a bug?  It wasn't obvious
> > the patch description.  (I'm not a big fan of Ingo's 'Impact: '
> > header, but it is good to make sure the patch description explains the
> > impact of a patch.)
> 
> If you are taking patch 3/3 you would need this patch. But otherwise you
> can drop this. The fix is actually in patch 2/3.

OK, thanks.  And these patches are orthogonal to these patches in the
patch queue, right?

      fix-sub-block-zeroing-for-unwritten-extents
      use-a-fake-block-number-for-delalloc-bh

So it looks like we probably want to push these two, plus patch 2/3.
I'm also very much concerned about your for-2.6.31 patch.  It is
complex, so we probably want wait, but it looks like we have a real
bug which these patches will just expose.  And your 2/3 patch isn't
going to fix that, right, since these are orthogonal problems.

(Again, if you expect patches to supercede existing ones in the ext4
patchwork or which are in the patch queue, please tell me.  Sometimes
it really isn't obvious....)

						- Ted

