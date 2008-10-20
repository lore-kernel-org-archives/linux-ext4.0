From: Theodore Tso <tytso@mit.edu>
Subject: Re: status of the ext3/jbd error handling enhancement patches
Date: Mon, 20 Oct 2008 08:41:45 -0400
Message-ID: <20081020124145.GB10698@mit.edu>
References: <48FC081D.60306@hitachi.com> <20081019221331.ddf6b8c2.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	adilger@sun.com, jack@suse.cz, sandeen@redhat.com
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:34253 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750985AbYJTMlx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Oct 2008 08:41:53 -0400
Content-Disposition: inline
In-Reply-To: <20081019221331.ddf6b8c2.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Oct 19, 2008 at 10:13:31PM -0700, Andrew Morton wrote:
> >   #jbd-fix-error-handling-for-checkpoint-io.patch: double-check this
> >   jbd-fix-error-handling-for-checkpoint-io.patch
> >   ext3-add-checks-for-errors-from-jbd.patch
> >   jbd-test-bh_write_eio-to-detect-errors-on-metadata-buffers.patch
> > 
> > They improve filesystem corruption problem and it is needed by
> > mission critical systems.
> > 
> > Could you tell me what is your concern (you commented, "double-check
> > this") ?  Are there something that I can help?  For example, I can
> > provide some SystemTap scripts to help tests.
> 
> I forget my reasons for that - would need to go back and review the
> discussions when the patch was first merged.
> 
> One of the above patches (I forget which) breaks the build because it
> expects the presence of Al Viro's VFS tree, and that hasn't been merged
> yet.  I need to wait and see if that merge will be happening (seems
> unlikely) and if not, rework the patch against mainline.

Strange; I don't recall any of the ext4 variants of the error handling
patches requiring Al's VFS tree.  And I thought all of them have been
merged into Linus's tree at this point.

Kawai-san, could you double check and see if I processed all of your
patches and pushed them to Linus?  I was pretty sure I had...

		    	   	   	     - Ted
