From: Thierry Vignaud <tvignaud@mandriva.com>
Subject: Re: e2fsprogs-interim scm tree?
Date: Wed, 21 Nov 2007 14:17:38 +0100
Message-ID: <m2ve7vbuvh.fsf@vador.mandriva.com>
References: <alpine.DEB.0.99999.0711200128130.7426@sheep.housecafe.de>
	<20071120031127.GB13125@thunk.org>
	<14319.62.180.231.196.1195554243.squirrel@housecafe.dyndns.org>
	<20071120140420.GC13125@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christian Kujau <lists@nerdbynature.de>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.mandriva.com ([212.85.150.183]:42369 "EHLO mx1.mandriva.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751096AbXKUNnF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 Nov 2007 08:43:05 -0500
In-Reply-To: <20071120140420.GC13125@thunk.org> (Theodore Tso's message of "Tue\, 20 Nov 2007 09\:04\:20 -0500")
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Theodore Tso <tytso@mit.edu> writes:

> Oh, absolutely.  I just don't think it's fair to encourage people to
> use something that might cause them to risk their data unless they
> are going into it with their eyes wide open.  The 'pu' branch gets
> very minimal testing.  I do run the regression test suite(*), so
> it's a bit more than "it builds, ship it!", but essentially almost
> any patch that will apply gets thrown into 'pu', and as I review
> patches and fix up issues, I move them to the 'next' branch, and
> then a little bit later to the 'master' branch.
> 
> (*) With only 3-4 test failures, but at least some of them are tests
> that need to be fixed up, not necessarily outright bugs in the 'pu'
> branch.
> 
> At the moment in the git tree only the 'pu' branch has extents
> support, and to be honest the support in e2fsprogs-interim in terms of
> being able to better detect and fix corrupted filesystems without
> crashing.  (Some of the newer features like uninit groups and flexbg
> isn't in e2fsprogs-interim, though.)  Fixing up the extents support is
> very high on my priority list over the next couple of weeks, but at
> the moment e2fsck on the 'pu' branch will correctly check an ext4
> filesystem with extents that isn't too badly corrupted; a badly
> corrupted one will cause e2fsck to crash.  It will get better, I
> promise you!  :-)

With the pu branch (98ec405d684b41be4ed8c3911dc7796bbacb8c68), I saw
lot of:

Error while reading over extent tree in inode 395164: Corrupt extent header    
Clear inode<y>? yes

Error while reading over extent tree in inode 395165: Corrupt extent header
Clear inode<y>? yes

Error while reading over extent tree in inode 395166: Corrupt extent header
Clear inode<y>? yes

Error while reading over extent tree in inode 395167: Corrupt extent header
Clear inode<y>? yes

Error while reading over extent tree in inode 410957: Corrupt extent header    
Clear inode<y>? yes

 


It's on a ext4 formated a week ago that sees lots of rsync tests.
And indeed, ls reporst some strange inodes:

(...)
-rw-r--r-- 1 tv    64876 2007-11-12 11:37 lang.pm
l????????? ? ?         ?                ? list_modules.pm
(...)

Would it be a kernel issue then?
