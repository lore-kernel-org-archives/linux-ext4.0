From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [RESEND] [PATCH 2/2 v2] e2fsck: Do not forget to discard last
 block group
Date: Mon, 27 Feb 2012 08:39:38 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1202270807030.5597@dhcp-27-109.brq.redhat.com>
References: <1330072490-26833-1-git-send-email-lczerner@redhat.com> <1330072490-26833-2-git-send-email-lczerner@redhat.com> <4F47A2BC.50307@ubuntu.com> <alpine.LFD.2.00.1202241550520.13074@dhcp-27-109.brq.redhat.com> <4F47B32B.5020006@ubuntu.com>
 <alpine.LFD.2.00.1202241710190.13074@dhcp-27-109.brq.redhat.com> <4F47BF60.2080303@ubuntu.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	tytso@mit.edu, sandeen@redhat.com
To: Phillip Susi <psusi@ubuntu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47999 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189Ab2B0Hjp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Feb 2012 02:39:45 -0500
In-Reply-To: <4F47BF60.2080303@ubuntu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 24 Feb 2012, Phillip Susi wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 2/24/2012 11:13 AM, Lukas Czerner wrote:
> > It does not work that way, uinit is never set back. If it has been 
> > formated without discard it is user choice, moving the image to
> > the thinly provisioned device, or ssd with dd is really bad idea
> > anyway. That said, UNINIT means that it has not been used and hence
> > there should be nothing to reclaim.
> 
> I could have sworn that e2fsck set it back when the block group became
> free again, since there is once again no need to parse the bitmap and
> you can just assume it's empty without having to read it.  I certainly
> have e2defrag doing this.  If fsck and the kernel currently don't do
> this, they should.
> 
> Whether it is a bad idea or not, people do move filesystems around and
> have existing systems formatted before mke2fs would issue discards, so
> it is a good idea to discard unused areas regardless of whether or not
> they are uninitialized.

I think that no one would ever install their file system on thinly
provisioned storage just with dd. That's just stupid.

> 
> My understanding of uninitialized is that it was added as an
> optimization meaning "there's nothing here, so you can skip/ignore
> this" rather than "this has _never_ been used, so you can rely on it
> containing all zeros and being discarded".

I have never said anything about the block group containing zeros. You
do not even have this guarantee when using discard command.

> 
> Indeed, a quick test filling a block device with random data and
> running mke2fs on it leaves the random data in the uninitialized block
> bitmaps rather than writing all zeros.

I am not really sure how this is relevant to the e2fsck doing discard. I
just said that *if* the block group is market as UNINIT, then it was not
used by the file system from the time of mke2fs, hence there should be
nothing to reclaim.

Yes, I am aware of the fact that UNINIT flag is used as a optimization
and it means that there is nothing. In current implementation it
also means that there was nothing since mke2fs. I agree that we might
actually good to set that flag again if the group is entirely unused.

However this would only make sense to do in kernel, because in e2fsck it
would not actually speed up anything until the next e2fsck call. But by
that time the groups might be initialized again. To do this in kernel we
would have to check whether the group is actually empty when freeing
blocks, or freeing inodes. That code is not there, and I am not sure if
it is worth the hassle (it might be), so I think that this patch is fine
as it is.

Thanks!
-Lukas

> 
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v2.0.17 (MingW32)
> Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
> 
> iQEcBAEBAgAGBQJPR79fAAoJEJrBOlT6nu75K8QH/RJoNQPm+rGtmv1cmWPusuNb
> pb/6hRmOhsIUClaMn2diinGgH7HQbZ9FqsSx0mZmWq52T/21korGk3fyVe/nfL9m
> h4xFYJLNEdsSCJE7mcpUu5BMxCwlYEcybHu7xobVtqHlF671zjszj/xCGBgQIEwD
> 3tRu8JXc/grnrya0CxDXd5kenM6oQviEmkproYUjG21XW+2DKjgHD1w6lbcHZHw5
> 5fvWVwFOMy9OgagcBzAxo43E7oZoPCD6o54HT8As7FoBfUSt9Z4GLMe3ULH4SbpP
> KKuRiumOnBW9fz7I3jRDkVpJ+9MxWqpUL4SA79sDreYfOBAa6m7cOaR+PHr8sTM=
> =8u4o
> -----END PGP SIGNATURE-----
> 
