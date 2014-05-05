From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: info about filesystem errors in /sys/fs/ext4/... ?
Date: Mon, 05 May 2014 09:53:25 -0500
Message-ID: <5367A5E5.10809@redhat.com>
References: <20140505070823.GM3017@pcnci.linuxbox.cz> <alpine.LFD.2.00.1405051253400.2223@localhost.localdomain> <20140505115919.GB18305@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
	linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>,
	=?UTF-8?B?THVrw6HFoSBDemVybmVy?= <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32533 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932448AbaEEOxx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 May 2014 10:53:53 -0400
In-Reply-To: <20140505115919.GB18305@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 5/5/14, 6:59 AM, Theodore Ts'o wrote:
> On Mon, May 05, 2014 at 01:03:17PM +0200, Luk=C3=A1=C5=A1 Czerner wro=
te:
>>
>> However we might to go a step further, because I do not
>> really like the idea of allowing to mount the file system with
>> errors by default. It does not really make sense to me and I wonder
>> whether someone actually intend to do it this way.
>=20
> We would need to make an exception for the root file system, of
> course.  And I've been receiving patches from folks who want to allow
> e2fsck to be able to fix a mounted, read-only /usr partition, since
> systemd is forcing folks to have to mount /usr read-only before it
> will start, which means /usr needs to be mounted before e2fsck gets
> started by systemd.

I hope these patches make it to the list, if you're considering them.

I don't really know why fsck would need to treat filesystems differentl=
y
based on where they are mounted; either we can repair a readonly fs
or not, right?  And if it's done, then the filesystem needs to be immed=
iately
unmounted & remounted[1], or the system rebooted...

-Eric

[1] and I suppose if it can be unmounted & mounted then there was no
good reason to repair it while mounted RO...


--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
