From: Thierry Vignaud <tvignaud@mandriva.com>
Subject: Re: Integrating patches in SLES10 e2fsprogs
Date: Mon, 28 Jan 2008 17:06:47 +0100
Message-ID: <m24pcydje0.fsf@vador.mandriva.com>
References: <20080124211728.GA24900@webber.adilger.int>
	<n7xir1iq69b.fsf@sor.suse.de> <20080127050543.GC24842@mit.edu>
	<479C9E13.8040209@redhat.com> <20080127202725.GA2545@mit.edu>
	<479D5CB9.5060801@redhat.com> <20080128052415.GA23482@mit.edu>
	<m28x2adjmn.fsf@vador.mandriva.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.mandriva.com ([212.85.150.183]:58964 "EHLO mx1.mandriva.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586AbYA1QGy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jan 2008 11:06:54 -0500
In-Reply-To: <m28x2adjmn.fsf@vador.mandriva.com> (Thierry Vignaud's message of "Mon\, 28 Jan 2008 17\:01\:36 +0100")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thierry Vignaud <tvignaud@mandriva.com> writes:

> > In any case, I've just released e2fsprogs 1.40.6.
> 
> which prompts me to note that it's neither on
> ftp://ftp.kernel.org/pub/linux/utils/util-linux-ng/v2.13 nor on
> http://e2fsprogs.sourceforge.net/
> 
> What is supposed to be the current primary source?

Worse, http://git.kernel.org/?p=fs/ext2/e2fsprogs.git;a=summary hasn't
any tag for neither 1.40.5 nor 1.40.6 in primary branch (only maint
shows 1.40.5)

You could be more user-friendly to use, distro packagers &
maintainers :-(
