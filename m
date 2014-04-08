From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [v7] ext4: Add support FALLOC_FL_COLLAPSE_RANGE for fallocate
Date: Tue, 8 Apr 2014 09:40:34 -0400
Message-ID: <20140408134034.GA28822@thunk.org>
References: <1393769538-3784-1-git-send-email-linkinjeon@gmail.com>
 <20140316031745.GA9916@thunk.org>
 <CAKYAXd-EO0pp=wz_Tg+2NEw9Nyu23sKXc-3n-fZUieES3+xt7w@mail.gmail.com>
 <20140402164258.GH6901@thunk.org>
 <20140408105504.GE22917@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Namjae Jeon <linkinjeon@gmail.com>, linux-ext4@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51604 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756227AbaDHNkl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Apr 2014 09:40:41 -0400
Content-Disposition: inline
In-Reply-To: <20140408105504.GE22917@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 08, 2014 at 08:55:04PM +1000, Dave Chinner wrote:
> 
> If you check the xfstests commit history, I think you'll find that
> Namjae wrote the xfstests that triggered the failure you are
> seeing.
> 
> You're just testing more esoteric configurations than most people do
> - same as I do for XFS. We can't expect every developer to test
> their code on every possible configuration before they submit
> it.... ;)

"kvm-xfstests -g smoke" takes about 4-5 hours to run[1], and allows
all of the ext4 developers to run a much wider set of configurations.
The more work they can do, the more I scale.  This is one of the
reasons why I'm pushing the testing automation so heavily.  :-)

	       	      	  	 	    	- Ted

[1] It's even faster if you run kvm-xfstests on a sacrificial ssd, or
if you have a big enough machine to run using a series of 5g ramdisks.
"kvm-xfstests -g auto" takes about 14 hours to run with spinning
platters, so it's much more of a commitment.
