From: Ted Ts'o <tytso@mit.edu>
Subject: Re: e2fsprogs git master branch
Date: Sun, 6 Feb 2011 20:54:22 -0500
Message-ID: <20110207015422.GH10402@thunk.org>
References: <831EA70A-C209-480B-B9C0-17B12995295A@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:55168 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754237Ab1BGBye (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 6 Feb 2011 20:54:34 -0500
Content-Disposition: inline
In-Reply-To: <831EA70A-C209-480B-B9C0-17B12995295A@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 04, 2011 at 03:40:27PM -0700, Andreas Dilger wrote:
> Ted,
> I was going to port some of the Lustre patches to the master branch
> of e2fsprogs (where I thought 1.42 would be derived from, with the
> >16TB changes).  However, it looks like master is only up-to-date
> with v1.41.12 (as per version.h and the RELEASE-NOTES files), and
> not 1.41.14.

Um, I just checked e2fsprogs.git on git.kernel.org, and the master
branch is in fact up to date with respect to 1.41.14...

See: 

http://git.kernel.org/?p=fs/ext2/e2fsprogs.git;a=shortlog;h=refs/heads/master

So it sounds like your master branch is out of date....

      	     	       	      	     	    - Ted
