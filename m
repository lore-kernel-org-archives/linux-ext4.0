From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [E2FSPROGS, RFC] New mke2fs types parsing
Date: Thu, 21 Feb 2008 08:35:54 -0500
Message-ID: <20080221133554.GD14614@mit.edu>
References: <E1JRpaN-0000Bs-4N@closure.thunk.org> <47BC76A9.307@redhat.com> <20080220222019.GG30305@mit.edu> <20080221085221.GV3029@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:39804 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751041AbYBUNgp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Feb 2008 08:36:45 -0500
Content-Disposition: inline
In-Reply-To: <20080221085221.GV3029@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 21, 2008 at 01:52:21AM -0700, Andreas Dilger wrote:
> On Feb 20, 2008  17:20 -0500, Theodore Ts'o wrote:
> > There are only three things which mke2fs will do, in my design:
> 
> This should all go into the mke2fs man page...

It will be documented; as I said, this was a request for comments
about the overall design, before I finish polishing it and adding man
page documentation, etc.  The patch was very much an interim patch,
including lots and lots of debugging printf's.  :-)

> 
> > [fs_types]
> > 	ext3 = {
> > 		features = has_journal
> > 	}
> > 	ext4 = {
> > 		features = extents,flex_bg
> > 		inode_size = 256
> > 	}
> 
> Presumably the ext4 feature should also have features = has_journal?
> If this is the default for ext4, why would it need to be given for ext3?
> 
> We should also add "dir_nlink,flexbg" while we are in there.

Yes, of course.  This was an example, not what I plan to check in.
(And it's flex_bg, not flexbg; we also need to add the uninit_groups
flags, etc.)

The other thing which I've been considering is some what to make the
feature list displayed by dumpe2fs a bit easier to understand.  One
thought is to bundle a number of features into things like std_ext2,
std_ext3, std_ext4, etc., with an option to display the full set for
someone who wants a more verbose/explicit description.  The one caveat
here is that once a bundle is defined, we don't ever want to change it
so that when someone e-mail's a dumpe2fs output as part of a bug
report, there is no question about what a feature bundle means; it
can't be e2fsprogs version dependent.

     		       	      	       	   	- Ted
