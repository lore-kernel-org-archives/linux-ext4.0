From: Theodore Tso <tytso@mit.edu>
Subject: 64-bit e2fsprogs patch queue
Date: Tue, 3 Feb 2009 10:52:31 -0500
Message-ID: <20090203155231.GP14762@mit.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="8NvZYKFJsRX2Djef"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:57751 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755881AbZBCPwe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Feb 2009 10:52:34 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--8NvZYKFJsRX2Djef
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

For folks who want to follow along with the 64-bit e2fsprogs
integration effort.

						- Ted


--8NvZYKFJsRX2Djef
Content-Type: message/rfc822
Content-Disposition: inline

Return-Path: <tytso@MIT.EDU>
Received: from po14.mit.edu ([unix socket])
	by po14.mit.edu (Cyrus v2.1.5) with LMTP; Tue, 03 Feb 2009 09:37:25 -0500
X-Sieve: CMU Sieve 2.2
Received: from fort-point-station.mit.edu by po14.mit.edu (8.13.6/4.7) id n13EbPMP023305; Tue, 3 Feb 2009 09:37:25 -0500 (EST)
Received: from mit.edu (W92-130-BARRACUDA-2.MIT.EDU [18.7.21.223])
	by fort-point-station.mit.edu (8.13.6/8.9.2) with ESMTP id n13EbHWi023173
	for <tytso@mit.edu>; Tue, 3 Feb 2009 09:37:17 -0500 (EST)
Received: from thunker.thunk.org (THUNK.ORG [69.25.196.29])
	(using TLSv1 with cipher AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mit.edu (Spam Firewall) with ESMTP id 3EAA011E131D
	for <tytso@mit.edu>; Tue,  3 Feb 2009 09:36:53 -0500 (EST)
Received: from root (helo=closure.thunk.org)
	by thunker.thunk.org with local-esmtp   (Exim 4.50 #1 (Debian))
	id 1LUMOS-0000a5-Em; Tue, 03 Feb 2009 09:36:52 -0500
Received: from tytso by closure.thunk.org with local (Exim 4.69)
	(envelope-from <tytso@mit.edu>)
	id 1LUMOR-0008Be-NN; Tue, 03 Feb 2009 09:36:51 -0500
Date: Tue, 3 Feb 2009 09:36:51 -0500
From: Theodore Tso <tytso@MIT.EDU>
To: Valerie Aurora Henson <vaurora@redhat.com>
Subject: Re: Branch to base against?
Message-ID: <20090203143651.GO14762@mit.edu>
References: <20090203072754.GB20654@shell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090203072754.GB20654@shell>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
X-Spam-Score: 0.12
X-Spam-Flag: NO
X-Scanned-By: MIMEDefang 2.42

On Tue, Feb 03, 2009 at 02:27:54AM -0500, Valerie Aurora Henson wrote:
> Hey Ted,
> 
> Eric said something about my 64-bit patches being against the wrong
> branch.  What should I base them against?  My goal is to get some
> subset of the patches into some branch in your repo - I'm happy with
> any branch and any number.

Not your fault; the issue was the "pu" branch hadn't been updated in a
long time, and it had some 64-bit patches that you needed to base your
work on.  So you did the right thing; it was just that the "pu" branch
was based on somethig around the time of e2fpsrogs 1.41.1, and there
had been a lot of other fix-ups that had gone in since then.

I thought you were out due to your shoulder surgery, so I've already
rebased your patches; to see what I've done, take a look at:

	http://github.com/tytso/e2fsprogs-64bit/tree/master
	git://github.com/tytso/e2fsprogs-64bit.git

(This was my excuse to play with github; previously I had used
git.or.cz for the ext4 patch queue).

This is a patch series based off of e2fsprogs 1.41.4.  It includes the
'pu' proposed update patches, plus your patches, rebased against the
latest e2fsprogs development head.

It is a patch series because some of the patches clearly need cleanup
and refactorization.  For example, you had fixed some bugs in Jose's
64-bit_mke2fs_cleanup patch, that should be merged into his patch.
For another, what's up with "0031-temporary-check-about-to-checksum-
conversion.patch"?  :-)

I also suspect there may be places where I've added some old interface
since 1.41.1 that would therefore not be caught in your patches, which
is another reason why the patches will need updating after the
rebasing effort.

So... the way I use this patch set is via a tool called "guilt":

	git://git.kernel.org/pub/scm/linux/kernel/git/jsipek/guilt.git
	http://git.kernel.org/?p=linux/kernel/git/jsipek/guilt.git

Works just like quilt, in that you can use "guilt push", "guilt pop",
etc.  I like it because as you push and pop commits, they are real
commits in git, so I can review them via "git log", and make sure the
commit changelogs make sense.  "git grep" works, "git log -p", "git
log --stat", etc.

If you want to use guilt, after installing it, do:

% cd /usr/projects/e2fsprogs           <---- replace w/ your e2fsprogs repo
% mkdir .git/patches; pushd .git/patches
% git clone git://github.com/tytso/e2fsprogs-64bit.git shared-64bit
% cp /dev/null shared-64bit/status
% popd
% ln -s .git/patches/shared-64bit patches     <---- optional, for convenience
% git checkout -b shared-64bit v1.41.4
% guilt push -a

You can also use quilt if you like, in that case, just drop the
contents of the patch tree repo in the top-level "patches" directory.

If you sign up to github, I'll add you to the access list so you can
also push updates to the patch queue.  That way we can work together
on cleaning up the patch series, and as things are ready at the
beginning of the queue, I'll merge it into mainline and then we can
delete them from the patch series.

This is the workflow that we developed for the ext4 patch queue, and
it worked really well, with Mingming, Eric,and I having access to the
ext4 patch queue for kernel patches.  That way they could queue up
their patches, and afterwards multiple people could edit and refine
the patches so they could be made ready to be pushed into mainline.
IIRC Eric uses guilt, although Mingming prefers to use raw quilt.
Either works.

Sound like a plan?

						- Ted

--8NvZYKFJsRX2Djef--
