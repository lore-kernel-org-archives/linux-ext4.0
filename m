From: Thierry Vignaud <tvignaud@mandriva.com>
Subject: Re: Integrating patches in SLES10 e2fsprogs
Date: Mon, 28 Jan 2008 17:01:36 +0100
Message-ID: <m28x2adjmn.fsf@vador.mandriva.com>
References: <20080124211728.GA24900@webber.adilger.int>
	<n7xir1iq69b.fsf@sor.suse.de> <20080127050543.GC24842@mit.edu>
	<479C9E13.8040209@redhat.com> <20080127202725.GA2545@mit.edu>
	<479D5CB9.5060801@redhat.com> <20080128052415.GA23482@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.mandriva.com ([212.85.150.183]:57924 "EHLO mx1.mandriva.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753418AbYA1QBl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jan 2008 11:01:41 -0500
In-Reply-To: <20080128052415.GA23482@mit.edu> (Theodore Tso's message of "Mon\, 28 Jan 2008 00\:24\:15 -0500")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso <tytso@mit.edu> writes:

> In any case, I've just released e2fsprogs 1.40.6.

which prompts me to note that it's neither on
ftp://ftp.kernel.org/pub/linux/utils/util-linux-ng/v2.13 nor on
http://e2fsprogs.sourceforge.net/

What is supposed to be the current primary source?

> It contains some of obviously correct patches from the Novell and
> Red Hat packages.  More importantly, it includes the "mke2fs -E
> test_fs" feature which will be needed once we push test_fs ext4
> patches to mainline, which I plan to push to Linus in the next day
> or two.
