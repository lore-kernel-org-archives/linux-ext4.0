From: Ted Ts'o <tytso@mit.edu>
Subject: Re: GIT PULL] ext4 updates for 3.5
Date: Fri, 1 Jun 2012 13:43:36 -0400
Message-ID: <20120601174336.GA15778@thunk.org>
References: <E1SaTSI-0005UV-4B@tytso-glaptop.cam.corp.google.com>
 <CA+55aFwk8oYx8EKWdT=5cMTLK7RDz8GQdGmHk2KXwcCq+Bb8PA@mail.gmail.com>
 <CA+55aFwwfMTN=WGQGmFO7DYeBUOGA7V4_6XueQS4JAzeykwn3Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:47055 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759261Ab2FARnk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 1 Jun 2012 13:43:40 -0400
Content-Disposition: inline
In-Reply-To: <CA+55aFwwfMTN=WGQGmFO7DYeBUOGA7V4_6XueQS4JAzeykwn3Q@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 01, 2012 at 10:19:33AM -0700, Linus Torvalds wrote:
> So pulling 'ext4_for_linus' instead of 'dev' will get me the same
> commits you asked me to pull, with the added tag information that your
> pull request containes.

So I should do "git request-pull origin git://... ext4_for_linus" next
time, right?

Sorry about that.  I thought it had included the reference to tag
automatically since the text of the tag showed in the request-pull
text.

> Now I just wonder why your pull request said 'dev' at all.

Because that was the name of the branch head that I used; sorry about
that.

							- Ted
