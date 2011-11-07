From: Ted Ts'o <tytso@mit.edu>
Subject: Re: quotacheck on 'tune2fs -O quota'
Date: Mon, 7 Nov 2011 16:28:25 -0500
Message-ID: <20111107212825.GI24234@thunk.org>
References: <4EB224A9.8030606@whamcloud.com>
 <CAGr1F2FMvsZ6eLJid4z0RpJcAm5paEfbJwrtFE7iqbr_bA4BTA@mail.gmail.com>
 <20111104090356.GC6205@granier.hd.free.fr>
 <CAGr1F2FQ=MAqd8NiamZ39K9dX8YC_JiaUszFod3tG=CK+W0GGQ@mail.gmail.com>
 <20111107203836.GB3191@granier.hd.free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Aditya Kali <adityakali@google.com>, linux-ext4@vger.kernel.org
To: Johann Lombardi <johann@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:53257 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246Ab1KGV22 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Nov 2011 16:28:28 -0500
Content-Disposition: inline
In-Reply-To: <20111107203836.GB3191@granier.hd.free.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 07, 2011 at 09:38:36PM +0100, Johann Lombardi wrote:
> > I agree it would be useful to allow upgrades using existing quota
> > files. I just didn't have a way of doing this correctly though so I
> > had removed it. But this patch fixes it, so I am all for including it.
> 
> Great, thanks.

It's more than useful, it's mandatory.  It wasn't important for
Aditya's application since he was mainly worried about tracking disk
space usage.  But for anyone who cares about doing quota enforcement,
losing the quota limits when you ran e2fsck is a non-starter.

Just to get this on record, since we discussed this on the weekly
conference call.  I'm currently planning on making quota disabled by
default in e2fsprogs, so that anyone who wants to use quota will have
to use an --enable-quota configure option.  That's because I'm not
completely convinced that quota is fully baked and tested.  After
reviewing Niu's patches, I'll apply them, and that way the quota
feature won't hold up the e2fsprogs 1.42 release.  People who feel
comfortable using it can enable it via --enable-quota, and after we
give it a bit more of a shakedown, we can enable it by default in some
1.42.X maintenance release.

Thanks to Niu and whamcloud for implementing this critically needed
bit of functionality!

					- Ted
