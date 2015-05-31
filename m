From: "U.Mutlu" <for-gmane@mutluit.com>
Subject: Re: generic question: user-only directory w/o root access
Date: Mon, 1 Jun 2015 00:45:22 +0200
Message-ID: <mkg2u2$ckm$1@ger.gmane.org>
References: <mkfbkb$fo1$1@ger.gmane.org> <20150531185934.GE11642@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53817 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282AbbEaWp3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 31 May 2015 18:45:29 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1YzByy-0005CJ-2w
	for linux-ext4@vger.kernel.org; Mon, 01 Jun 2015 00:45:28 +0200
Received: from ip4d14aa5f.dynamic.kabel-deutschland.de ([77.20.170.95])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Mon, 01 Jun 2015 00:45:28 +0200
Received: from for-gmane by ip4d14aa5f.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Mon, 01 Jun 2015 00:45:28 +0200
In-Reply-To: <20150531185934.GE11642@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Ts'o wrote on 05/31/2015 08:59 PM:
> On Sun, May 31, 2015 at 06:07:38PM +0200, U.Mutlu wrote:
>> how can a non-root user have a directory of his own, without any root access?
>> Is this somehow possible, or will it be made possible with the new ext4 (ext5?)?
>
> You're not going a lot of details about exactly what the use case you
> have in mind; are you talking about a non-root user creating a file
> system which then gets mounted somwhere?  In practice you still need
> root to do the mount, or at the very least to set up the /etc/fstab to
> allow a non-root user to mount a file system at a particular mount
> point.
>
> If it's the latter which you are envisioning, then the root_owner
> extended option to mke2fs(8) may be what you're looking for.
>
> If it isn't please go into a much greater detail about what exactly it
> is you are trying to do, and why.

A private directory (or private mountpoint) for the user only
(or for an application running under that 'user'-account).

The rationale behind this is: there are many system programs,
and other programs running with root rights. The user cannot know
them all and so cannot trust them. This includes also admins and the root user 
itself.

The idea is to have a truly private directory or a private mountpoint
where by default nobody else has access to it, incl. root,
unless the owner grants access to others.

Ideal would be if the content therein were encrypted, as is planned
for the upcoming new ext4-version.

With such a mechanism high-security applications could be realisied.

It seems with FUSE this is possible, but I have yet to find an encrypted
filesystem that gives the above mentioned security. Truecrypt does not give
that security as it itself needs and operates with root rights.
I don't understand what the TC-programmers have done, because they seem not
to have understood what FUSE is and can. They wrote their own cr*p around it
instead of using the FUSE-interface, thereby totally _eliminating_ the good
security mechanism FUSE offers by default.

So, my wish is to mount an encrypted virtual HD to a mountpoint,
and nobody else shall have access to it, especially not root or
any program with root rights.

Does anybody know of such an open-source solution for Linux?

-- 
Thx
Uenal


