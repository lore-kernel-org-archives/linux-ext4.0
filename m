From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [GIT PULL] ext4 bugfixes for 3.2-rc5
Date: Thu, 15 Dec 2011 14:08:46 -0500
Message-ID: <20111215190846.GA2709@thunk.org>
References: <E1RauNd-0008W1-02@tytso-glaptop.cam.corp.google.com>
 <CA+55aFw6n=WaDWRn7NqtBei1x0-w1PkH5x6r3iQSSPZvxYvDhQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:35635 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759360Ab1LOTIt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Dec 2011 14:08:49 -0500
Content-Disposition: inline
In-Reply-To: <CA+55aFw6n=WaDWRn7NqtBei1x0-w1PkH5x6r3iQSSPZvxYvDhQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 14, 2011 at 06:50:07PM -0800, Linus Torvalds wrote:
> On Wed, Dec 14, 2011 at 11:20 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> >
> > There is a signed tag tytso-for-linus-20111214 covering these patches,
> > which fix a potential hang, crash (on big endian), and data corruption
> > bugs which show up when using fsx and/or Hugh's kernel compile/mm
> > torture test.
> 
> Ok, since I build my own git versions, I have one that can pull signed
> tags and automatically verifies them and saves the signed tag
> information as part of the commit object.

Cool!  Does it save enough that GPG signature information can be
verified later?  I'm a little fuzzy on what is covered by the
signature which gets verified when you run the command "git verify-tag
tytso-for-linus-20111214".  Better yet, does the new version of git
have a command that will automatically verify the digital signature
found in a merge commit?

And this isn't in 1.7.8 yet, right?  I'd have to build version of git
based on the next branch to play with this new signatury goodness?

      	     	  	    	      - Ted
