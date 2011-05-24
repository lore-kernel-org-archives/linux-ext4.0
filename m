From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/5] jbd2: Pass extra bool parameter in journal
 routines to specify if its ok to fail the journal transaction allocation.
Date: Tue, 24 May 2011 18:56:43 -0400
Message-ID: <20110524225643.GK26055@thunk.org>
References: <BANLkTinNUxt_Bj0JErLVDbh=73JHzzS9=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>
To: Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60766 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757017Ab1EXW4r (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 May 2011 18:56:47 -0400
Content-Disposition: inline
In-Reply-To: <BANLkTinNUxt_Bj0JErLVDbh=73JHzzS9=w@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Apr 24, 2011 at 05:10:41PM -0700, Manish Katiyar wrote:
> Pass extra bool parameter in journal routines to specify if its ok to
> fail the journal transaction allocation. If 'true' is passed
> transaction allocation is done through GFP_KERNEL  and ENOMEM is
> returned else GFP_NOFS is used.
> 
> Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>

Hi Manish,

I really apologize for not having time to follow this patch series.
I've been rather overloaded at the moment.

A couple things.  First of all, when you repost a patch which is part
of patch series, I would really appreciated if you did the following:

*) Resend all of the patches in the patch series, each time.
*) The patches should be in their own mail thread, with either a 0/N
      introductory message which describes what the patch series does
      at a high level --- this is also a good place to put benchmark
      numbers or other high level detail that doesn't belong in the git
      history.  If you don't need a introductory message, then make the
      1/N, 2/N, etc. messages be chained to the first patch in the
      patch series.  This keeps the patch together and easier for
      people to find in their inbox.   If you use git, the commands
      "git format-patch" and "git send-email" will do this for you
      automatically.
*) Please put a short summary of the differences between the
   vN and vN+1 patch after the "---" which separates commit description
   from the rest of the patch.  Maintain this as a change log before the
   diffstat information:
       v4 -> v5   Fix up whitespaces and added reviewed-by: XXXXX
       v3 -> v4   Fixed lock ordering issue pointed out by Eric
       v2 -> v3   Clarified comments in ext4_foobie_bletch()
       v1 -> v2   Pulled out common code and created a helper function,
       	     	     ext4_foobie_bletch()
   (If there is no change in a particular patch; you're just reposting
   because other patches in the patch series changed, that's fine.  Just
   leave the commit log empty for that version, but bump the version
   number so that all of the patches in a reposting of patch series have
   the same version number.)

For a good example of what this might look like, take a look at Amir's
snapshot patches, here:

	 http://thread.gmane.org/gmane.comp.file-systems.ext4/24974

The other thing which I've noticed with these patches is that you made
changes to functions in the jbd2 layer, without also immediately
fixing up all of the callers in the ext4 and ocfs2 file systems.  This
is critically important, because the patches need to be bisectable.
Note what happened just recently with the punch series; it turns out
there was a regression that was introduced between patch 2/5 and 3/5
of that series.  Because the tree was fully buildable and would work
correctly between each patch, this allowed me to use git bisect to
find the problem patch.  If you add an extra parameter to a function,
and then don't fix up the call sites, the kernel won't be buildable
after the first patch.

Finally, try to keep the short description of the commit to less than
72 character.  "jbd2: Pass extra bool parameter in journal routines to
specify if its ok to fail the journal transaction allocation." is just
way too long.

Sorry to dump all of these nit picky things on you at all once, but
because of these issues, it's actually pretty hard to review the rest
of the patches (since it's hard for me to simply find the latest
version of the patches in the mail threads), and I'd have to
completely refactor all of these patches to keep them bisectable, and
that's more work than I'm prepared to take on at this point in the
merge window.  (And in the future, I'm going to be pushing back on
this sort of thing more, just so that I scale better.)

Regards,

						- Ted
