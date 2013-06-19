From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: optimize extent selection for block removal in
 case of hole punch
Date: Wed, 19 Jun 2013 10:06:05 -0400
Message-ID: <20130619140605.GA24194@thunk.org>
References: <519f7ba2.04fc440a.06c2.ffffd589@mx.google.com>
 <20130618154053.GF7359@thunk.org>
 <CAOiN93mMc1zG-YToRxVfbm8iDeeB6roJ_AZKcXJgGpfS+yn9xA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger@dilger.ca, ext4 development <linux-ext4@vger.kernel.org>,
	Ashish Sangwan <a.sangwan@samsung.com>,
	Namjae Jeon <namjae.jeon@samsung.com>
To: Ashish Sangwan <ashishsangwan2@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:59379 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756427Ab3FSOGL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Jun 2013 10:06:11 -0400
Content-Disposition: inline
In-Reply-To: <CAOiN93mMc1zG-YToRxVfbm8iDeeB6roJ_AZKcXJgGpfS+yn9xA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 19, 2013 at 07:15:35PM +0530, Ashish Sangwan wrote:
> On Tue, Jun 18, 2013 at 9:10 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> > On Fri, May 24, 2013 at 08:09:17PM +0530, ashishsangwan2@gmail.com wrote:
> >> From: Ashish Sangwan <a.sangwan@samsung.com>
> >>
> >> Both hole punch and truncate use ext4_ext_rm_leaf for removing
> >> blocks. Currently we choose the last extent as the starting
> >> point for removing blocks: ex = EXT_LAST_EXTENT(eh);
> >> This is OK for truncate but for hole punch we can optimize the
> >> extent selection as the path is already initialized.
> >> We could use this information to select proper starting extent.
> >> The code change in this patch will not affect truncate as for
> >> truncate path[depth].p_ext will always be NULL.
> >>
> >> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> >> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> >
> > Applied, thanks.
> 
> Sorry I cannot see the patch changes in ext4 dev branch.

Sorry, I dropped this patch from the dev branch last night, but I
didn't want to send e-mail about it until I had completed enough
testing to be sure.  It appears that this patch is causing a
regression; xfstests generic/269 and generic/279 to fail in the
nojournal configuration.

The tests are ones which have multiple fsstress threads racing with
dd/ENOSPC hitters, with (#270) and without (#269) quota enabled.  It's
not at all obvious to me why your particular change would make a
difference here, and it may simply be that your optimization is
exposing a timing change and is not the root cause of the failure, but
I'm going to move this to the unstable portion of the patch series
until we do further investigation.

If you could take a look at this, I would appreciate it, but as I
said, this may very well turn out not be the fault of your patch.

Regards,

						- Ted

