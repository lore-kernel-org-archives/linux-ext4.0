From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Making it easier for end users to use ext4
Date: Mon, 14 Jul 2008 15:24:05 -0400
Message-ID: <E1KITeX-0001PV-Pv@closure.thunk.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:36597 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753324AbYGNTYH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Jul 2008 15:24:07 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


So I got a comment on my recent blog posting about using ext4 that
Googling ext4 results in a lot of ancient status reports and not a lot
of good information about how to get started with ext4.  The comment was
fair, so I took a few minutes to update this web page:

      http://ext4.wiki.kernel.org/index.php/Ext4_Howto

with some getting started information.

Eric, when you have a chance, could you take a quick peek at the Fedora
Core section of that page and update it appropriately.  It would
probably be a good idea to include the yum repository with the latest
1.41 e2fsprogs RPM's, etc.  One other thought is if we start encouraging
people to use ext4 on FC9, whether it might be a good idea to take all
of the patches to ext4 since 2.6.25, add them to the patch queue, and
then back port the resulting stack of patches to 2.6.25 so that FC9
users who are interested in testing ext4 would get the benefit of the
latest ext4 code, and also so any bug reports we get would also be
against the latest code.  Alternatively, the repository could just
simply include 2.6.26 plus the latest ext4 patch set, whichever would be
easier.

If other ext4 developers have a chance, it would be a good idea to go
through the http://ext4.wiki.kernel.org site, and do some grooming of
the site.  Some of the pages like the FAQ, which were originally
targetted primarily at ext4 developers, may need to have some of the
more developer-centric content moved to other pages now that we will
start having more users coming to look at that site.  And of course,
there is some very badly out-of-date information on that site as well!

      	      	   	 	     		     - Ted
