From: Linus Torvalds <torvalds@osdl.org>
Subject: Re: Updated ext4/jbd2 patches based on 2.6.19-rc1
Date: Fri, 6 Oct 2006 09:11:48 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0610060908380.3952@g5.osdl.org>
References: <1160072610.8508.12.camel@kleikamp.austin.ibm.com>
 <20061005131939.ccd1fd48.akpm@osdl.org>  <Pine.LNX.4.64.0610051619540.3952@g5.osdl.org>
 <1160139032.8658.17.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Andrew Morton <akpm@osdl.org>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:43235 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751562AbWJFQLx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Oct 2006 12:11:53 -0400
To: Dave Kleikamp <shaggy@austin.ibm.com>
In-Reply-To: <1160139032.8658.17.camel@kleikamp.austin.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



On Fri, 6 Oct 2006, Dave Kleikamp wrote:
> On Thu, 2006-10-05 at 16:25 -0700, Linus Torvalds wrote:
> 
> We haven't been using git to manage ext4 so far, although in hindsight
> it probably would have made things easier.  I'm assuming that you're
> just suggesting this for educational purposes and that git will handle
> the patches that Andrew picked up into -mm just fine.

Well, also that even if you're not using git, what any random person can 
do is to actually just import the current state into git, and do the 
simple "git diff -C" thing to get the nicer diff.

One of the advantages about git is that "intent" doesn't matter. Git only 
tracks cold, hard data. So if you copied a file, git doesn't care one whit 
whether you _tell_ it that you copied it or not: it will purely look at 
the end result, and say "you copied it" if the file looks the same.

> I could re-generate the patches that do the copies from git, but I don't
> believe it will be that beneficial at this point.

The only advantage (but I'd argue that it's a real one, and very possibly 
worth it) is that when this gets sent to me (or anybody else) by email, it 
can be sent in a format that is actually readable, instead of sending it 
as a huge patch that doesn't actually talk about what it does..

		Linus
