From: Theodore Tso <tytso@mit.edu>
Subject: Re: Integrating patches in SLES10 e2fsprogs
Date: Mon, 28 Jan 2008 12:00:04 -0500
Message-ID: <20080128170004.GD17752@mit.edu>
References: <20080124211728.GA24900@webber.adilger.int> <n7xir1iq69b.fsf@sor.suse.de> <20080127050543.GC24842@mit.edu> <479C9E13.8040209@redhat.com> <20080127202725.GA2545@mit.edu> <479D5CB9.5060801@redhat.com> <20080128052415.GA23482@mit.edu> <m28x2adjmn.fsf@vador.mandriva.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Thierry Vignaud <tvignaud@mandriva.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:42658 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754459AbYA1RAL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Jan 2008 12:00:11 -0500
Content-Disposition: inline
In-Reply-To: <m28x2adjmn.fsf@vador.mandriva.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 28, 2008 at 05:01:36PM +0100, Thierry Vignaud wrote:
> Theodore Tso <tytso@mit.edu> writes:
> 
> > In any case, I've just released e2fsprogs 1.40.6.

Oops, typo, that should have read 1.40.5.

> 
> which prompts me to note that it's neither on
> ftp://ftp.kernel.org/pub/linux/utils/util-linux-ng/v2.13 nor on
> http://e2fsprogs.sourceforge.net/

I don't know why people would think it's at
/pub/linux/utils/util-linux-ng, but it is at e2fsprogs.sf.net, and
I've just uploaded 1.40.5 to /pub/linux/kernel/people/tytso/e2fsprogs
on master.kernel.org, so it should be at ftp.kernel.org very shortly.
(Sorry, didn't get to that last night.)

> What is supposed to be the current primary source?

Well, for the absolutely *latest*, the git trees are at:

	git://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
	http://git.kernel.org/?p=fs/ext2/e2fsprogs.git;a=summary
or
	git://repo.or.cz/e2fsprogs.git
	http://repo.or.cz/w/e2fsprogs.git

For the release tarballs, they can be downloaded at e2fsprogs's
SourceForge page, or at

	ftp.kernel.org:/pub/linux/kernel/people/tytso/e2fsprogs

Regards,

					- Ted
