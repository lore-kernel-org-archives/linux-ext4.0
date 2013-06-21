From: Ryan Lortie <desrt@desrt.ca>
Subject: Re: ext4 file replace guarantees
Date: Fri, 21 Jun 2013 08:43:16 -0400
Message-ID: <1371818596.20553.140661246775057.0F7160F3@webmail.messagingengine.com>
References: <1371764058.18527.140661246414097.671B4999@webmail.messagingengine.com>
 <20130621005937.GB10730@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:41957 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161330Ab3FUMnR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Jun 2013 08:43:17 -0400
In-Reply-To: <20130621005937.GB10730@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

hi Ted,

Thanks for the quick reply.

On Thu, Jun 20, 2013, at 20:59, Theodore Ts'o wrote:
> It's not _guaranteed_ safe.  It significantly reduces the chances of
> data loss in case of a crash, but it's possible for the transaction
> containing the rename to close before the blocks are written back.

I think you need to update the documentation.  Specifically, this:

"avoids the                     "zero-length" problem that can happen
when a system crashes before the delayed allocation                     
 blocks are forced to disk"

makes it sound like the replace-by-rename-without-fsync problem has been
solved.  This is the statement that caused me to remove the extra
fsync() we had in GLib.

Probably "avoids" should be replaced with "significantly reduces the
chances of", as you write in your mail here.

Note that "significantly reduces the chances of" is not good enough to
prevent about a dozen reports of lost data that I alone have heard about
in the past few days...

https://bugzilla.gnome.org/show_bug.cgi?id=701560#c30
https://plus.google.com/113426423446646532879/posts/Mqepf8STJEK?cfem=1
https://bugzilla.redhat.com/show_bug.cgi?id=975521
https://bugzilla.gnome.org/show_bug.cgi?id=702574
https://bugzilla.gnome.org/show_bug.cgi?id=702394

and many "me too" cases from IRC, including reports from two Debian
users.

So I think that the "significantly reduces the chances of" statement
itself is even suspect...

It would be great if the docs would just said "If you want safety with
ext4, it's going to be slow.  Please always call fsync()." instead of
making it sound like I'll probably be mostly OKish if I don't.

> You'll have to make your own decision about how likely this
> combination is to happen.  The failure scenario would probably be
> something like the user who plays tux racer all the time, and uses
> crappy proprietary drivers that crash the system every single time an
> OpenGL application exits.  If they think that's normal, and are
> willing to live with the crap proprietary drivers, and they are also
> the sort of people who carefully position all of their windows to be
> precisely just so, and if the !@#!?! desktop libraries are still
> bogusly rewriting the entire contents of every single registry file,
> regardless of whether the application changed anything --- then
> eventually, said user will whine about how the hours she spent
> obsessively setting up their window layout got lost after Tux Racer
> creashed their system *again*.

Dude....



Thanks again.
