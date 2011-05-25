From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/3] jbd2 : Fix journal start by passing a parameter to
 specify if the caller can deal with ENOMEM
Date: Wed, 25 May 2011 10:13:33 +0200
Message-ID: <20110525081333.GB4427@quack.suse.cz>
References: <4DDCAF18.8030809@gmail.com>
 <20110525074457.GA4427@quack.suse.cz>
 <4DDCB3FA.2070009@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, tytso@mit.edu, linux-ext4@vger.kernel.org
To: Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48141 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932114Ab1EYINf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 May 2011 04:13:35 -0400
Content-Disposition: inline
In-Reply-To: <4DDCB3FA.2070009@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 25-05-11 00:47:06, Manish Katiyar wrote:
> On 05/25/2011 12:44 AM, Jan Kara wrote:
> > This patch is OK as such but as I wrote in a reply to a later patch in
> > the series, you also need to pass 'errok' to start_this_handle() instead of
> > gfp_mask as well. Then in start_this_handle() you can use 'errok' to decide
> > whether we should retry the allocation or not instead of gfp_mask. And just
> > call kzalloc in start_this_handle() with GFP_NOFS... Thanks.
> 
> Hi Jan,
> 
>    ok.. I will do it as a separate patch.
  Well, patch 2/3 does not really make too much sense without it (errok
parameter isn't used) so there's no reason to do it as a separate patch.
Just add it to this patch please.

Also Ted asked you to send patches in one mail thread - that is the second
and further patches are a reply to the first patch. Git makes this easy to
do via 'git send-email' but it's not so easy to use for development when
you need to change patches in the middle of the series. But TopGit
(http://repo.or.cz/w/topgit.git?a=blob;f=README) can make this task easier
for you (or I personaly just use two shell scripts on top of git itself).

Finally, the patch header like:
Hi Jan,

Posting this as a new mail for Ted's convenience. I have incorporated your
feedback from the last patch
(http://comments.gmane.org/gmane.comp.file-systems.ext4/24547) and updated
the patch.



a) Add a new API ext4_journal_start_failok for callers who are
  ok to handle ENOMEM cases.
b) Update ext4 routines with the new API which can fail.


Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
---
Isn't really useful. You don't really want the greeing and the first
paragraph to end up in git history forever, do you? And Ted doesn't want to
edit emails by hand to remove unnecessary stuff either. So it should rather
have looked like:
a) Add a new API ext4_journal_start_failok for callers who are
  ok to handle ENOMEM cases.
b) Update ext4 routines with the new API which can fail.
---
Posting this as a new mail for Ted's convenience. I have incorporated Jan's
feedback from the last patch
(http://comments.gmane.org/gmane.comp.file-systems.ext4/24547) and updated
the patch.
<diffstat here>

Then, one can just run 'git am' on the mailbox and it will automatically
remove stuff below --- and include the patch into git. Much faster when you
have to handle tons of patches...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
