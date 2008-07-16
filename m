From: Theodore Tso <tytso@mit.edu>
Subject: Re: Suggestions for a 64bit bitmap api
Date: Wed, 16 Jul 2008 10:51:46 -0400
Message-ID: <20080716145146.GZ8185@mit.edu>
References: <87y742110t.fsf@frosties.localdomain> <20080716134124.GU8185@mit.edu> <87lk012aca.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:50897 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756261AbYGPOvs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Jul 2008 10:51:48 -0400
Content-Disposition: inline
In-Reply-To: <87lk012aca.fsf@frosties.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 16, 2008 at 04:05:25PM +0200, Goswin von Brederlow wrote:
> Theodore Tso <tytso@mit.edu> writes:
> 
> > On Wed, Jul 16, 2008 at 02:12:02PM +0200, Goswin von Brederlow wrote:
> >> 
> >> which api would you prefer?
> >
> > There is a lot of comments about my plan for 64-bit bitmaps in the pu
> > branch of e2fsprogs, in lib/ext2fs/gen_bitmap64.c.
> 
> How/Where can I check out thepu branch?

How much do you know about git?

Short version:

git checkout git://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git e2fsprogs
cd e2fsprogs
git branch pu origin/pu
git checkout pu

To update to a newer pu once you have done the above steps

cd /path/to/checked-out-e2fsprogs-repository
git fetch
git checkout pu
git reset --hard origin/pu

(Note that the "git reset --hard" will blow away any local commits you
might have made; this isn't a substitute for a full-blown git
tutorial.  The reason for the git reset is because the pu branch is
constantly getting rebased.)

A good place to start for explaining the concepts of git (and why git
is so great) is here:

	http://utsl.gen.nz/talks/git-svn/intro.html

The bits about "git svn" won't apply for e2fsprogs, but the concepts
of git are really well explained in the above web page.  For the
"crash course", this is pretty good:

       http://git.or.cz/course/svn.html

Other good starting points for git are:

      http://www.kernel.org/pub/software/scm/git/docs/gittutorial.html
      http://www.kernel.org/pub/software/scm/git/docs/everyday.html

						- Ted

