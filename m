From: djwong <djwong@us.ibm.com>
Subject: Re: Update of e2fsprogs pu branch and ext4 dev branch
Date: Mon, 30 Apr 2012 09:40:07 -0700
Message-ID: <20120430164007.GE6938@tux1.beaverton.ibm.com>
References: <E1SObU7-0004xb-KU@tytso-glaptop.cam.corp.google.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <gnehzuil.liu@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:42481 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752073Ab2D3QnA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Apr 2012 12:43:00 -0400
Received: from /spool/local
	by e6.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Mon, 30 Apr 2012 12:42:59 -0400
Received: from d01relay03.pok.ibm.com (d01relay03.pok.ibm.com [9.56.227.235])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id D192438C805C
	for <linux-ext4@vger.kernel.org>; Mon, 30 Apr 2012 12:40:12 -0400 (EDT)
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q3UGeCRc107262
	for <linux-ext4@vger.kernel.org>; Mon, 30 Apr 2012 12:40:12 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q3UMB0ir017056
	for <linux-ext4@vger.kernel.org>; Mon, 30 Apr 2012 18:11:04 -0400
Content-Disposition: inline
In-Reply-To: <E1SObU7-0004xb-KU@tytso-glaptop.cam.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Apr 29, 2012 at 05:16:47PM -0400, Theodore Ts'o wrote:
> 
> I have updated the pu ("proposed updates") branch of e2fsprogs to
> include the metadata checksum and inline data patches rebased against
> the lastest changes in the e2fsprogs repository.  Note that these
> patches have not been fully reviewed yet, and are still subject to
> change!  In particular, the metadata checksum patches still have the
> issue with the jbd2 checksuming code breaking 64-bit block numbers, and
> inline data branches are causing a regression test failure.  I've
> integrated them into the pu branch to make it easier for me to review
> and test these changes, and so that other developers can see what is
> going on.
> 
> I also had to make some changes to the last inline data patch so that it
> would apply given the changes which the metadata checksum patch series
> had made to e2fsck/pass2.c.  I am not sure I did all off those changes
> correctly, and I'd invite Darrick and Zheng to take a look at them to
> make sure I didn't really screw something up.

I didn't see anything obviously wrong...

--D
> 
> As I've mentioned, the regression tests mostly pass, but critically
> missing from both patch series are any kind of regression tests.  I
> would really appreciate it if you would consider creating some of
> those.  We may find some interesting bugs as part of the test creation
> and validation process.
> 
> The pu branch is a **rewinding** branch; that is to say, I will be
> periodically rebasing the patches on the pu branch to take into account
> movement in the e2fsprogs master branch.  If you want to make any
> changes to the patches at this point, please fork the following patch
> queue on github, make the changes, and then (a) send the updated patch
> to the mailing list, and (b) push it to github and ask me to pull it
> from your tree.  That will save me a lot of time.  The github repo is
> at:
> 
> 	git://github.com/tytso/e2fsprogs-cksum-patch-queue.git
> 
> and the github page can be found at:
> 
> 	https://github.com/tytso/e2fsprogs-cksum-patch-queue
> 
> I have been using the "guilt" package to manipulate the patch tree, but
> you can also you quilt for the same purpose.
> 
> 
> I have also added the first half of the metadata checksum patches to the
> ext4 development tree.  Again, I've not fully finished reviewing the
> patches, but they pass the regression test in the standard ext4 modes.
> I haven't had a chance to enable metadata checksuming yet, and the jbd2
> patches clearly need some revision (which is why they aren't in the ext4
> patch queue yet).
> 
> The ext4 patch queue is also on github:
> 
> 	git://github.com/tytso/ext4-patch-queue.git
> 	https://github.com/tytso/ext4-patch-queue/commits/master
> 
> The same comment applies for updating the patches that are on the
> ext4-patch-queue.  Please start with the version of the patches in this
> git tree, since I have had to make some changes so they would apply
> cleanly against the latest kernel release.
> 
> There is a comment in the series file which indicates the commit ID of
> e2fsprogs/ext4 the patchsets are currently based upon.  When I rebase
> the patches to take into account newer commits, I will update the commit
> ID in the series file.
> 
> 						- Ted
> 

