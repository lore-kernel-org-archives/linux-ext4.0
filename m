From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: EXT4-fs (dm-1): Couldn't remount RDWR because of unprocessed
 orphan inode list
Date: Fri, 16 Sep 2011 15:04:55 +0300
Message-ID: <CAOQ4uxgvUsV7Qee6URzWvAkoV5VwLQWVLJWQ3VEpyVh3qbJXVA@mail.gmail.com>
References: <alpine.DEB.2.01.1109021346290.9183@trent.utfs.org>
	<4E66478E.90102@redhat.com>
	<alpine.DEB.2.01.1109060923340.9183@trent.utfs.org>
	<4E664DFD.80308@redhat.com>
	<20110908185139.GA2393@quack.suse.cz>
	<alpine.DEB.2.01.1109091809180.9183@trent.utfs.org>
	<20110910200414.GA6709@quack.suse.cz>
	<alpine.DEB.2.01.1109122150060.9183@trent.utfs.org>
	<alpine.DEB.2.01.1109152044090.5628@trent.utfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@redhat.com>,
	linux-ext4@vger.kernel.org, mszeredi@suse.cz,
	Al Viro <viro@zeniv.linux.org.uk>
To: Christian Kujau <lists@nerdbynature.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f180.google.com ([74.125.82.180]:34193 "EHLO
	mail-wy0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab1IPME4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 16 Sep 2011 08:04:56 -0400
Received: by wyj26 with SMTP id 26so4656710wyj.11
        for <linux-ext4@vger.kernel.org>; Fri, 16 Sep 2011 05:04:55 -0700 (PDT)
In-Reply-To: <alpine.DEB.2.01.1109152044090.5628@trent.utfs.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 16, 2011 at 6:49 AM, Christian Kujau <lists@nerdbynature.de=
> wrote:
> On Mon, 12 Sep 2011 at 21:52, Christian Kujau wrote:
>> On Sat, 10 Sep 2011 at 22:04, Jan Kara wrote:
>> > On Fri 09-09-11 18:11:26, Christian Kujau wrote:
>> > > On Thu, 8 Sep 2011 at 20:51, Jan Kara wrote:
>> > > > There's race where VFS remount code can race with unlink and r=
esult will
>> > > > be unlinked file in orphan list on read-only filesystem. Chris=
tian seems to
>> > > > be hitting this race. Miklos Szeredi has patches
>> > > > (http://lkml.indiana.edu/hypermail/linux/kernel/1108.3/00169.h=
tml) to
>> > > > mostly close this hole but they're waiting for Al to find time=
 to look at
>> > > > them / merge them AFAIK.
>> > >
>> > > While these patches are still pending review, are they "dangerou=
s" to
>> > > apply? If not, I'd like to volunteer as a tester :-)
>> > =A0 As far as I saw them, they should be pretty safe. So feel free=
 to test
>> > them.
>>
>> I've applied them to -rc5. It might take a few days untile the messa=
ge
>> occurs. Or, until "nothing happens", since I have the patches applie=
d :-)
>
> With Miklos' patches applied to -rc5, this happend again just now :-(
>
>> Meanwhile I'm trying to reproduce this issue on an x86 machine, but
>> haven't succeeded yet.
>
> After a ~3k remounts with constantly reading from the filesystem in
> question[0], I still was NOT able to reproduce this on an x86 VM :(
>
> Any ideas?
>

This is just a shot in the dark, but are you using Ubuntu on your
production machine by any chance?
The reason I am asking is becasue I have been getting failures to
umount fs, while running xfstests on ext4
with Ubuntu for a long time and nobody else seems to share this problem=
=2E

I always suspected Ubuntu has some service that keeps open handles on
mounted fs, but I never got
to examine this.

Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
