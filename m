From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: [PATCH v2] xfstests: add support for ext4dev FSTYP
Date: Fri, 3 Jun 2011 07:59:25 +0300
Message-ID: <BANLkTikiE1v6r7sYKSsR_pgqM-dJzQKrzQ@mail.gmail.com>
References: <1306933012-8666-1-git-send-email-amir73il@users.sourceforge.net>
	<20110601232804.GL32466@dastard>
	<BANLkTi=sV5=PyZvNSd=DGNW-V84=27d7Yw@mail.gmail.com>
	<BANLkTimbPWfOJKq6er4mnSYNPcx6VHLcrw@mail.gmail.com>
	<BANLkTimKV3LxugkW6_cE5vutjcmatESXuw@mail.gmail.com>
	<4DE7A557.9040608@redhat.com>
	<7D3F86FA-5AA9-49B0-9AFE-F597E83C07B4@dilger.ca>
	<20110603003610.GD16306@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger@dilger.ca>,
	Eric Sandeen <sandeen@redhat.com>,
	Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	sergey57@gmail.com, Amir Goldstein <amir73il@users.sf.net>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36868 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890Ab1FCE71 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Jun 2011 00:59:27 -0400
In-Reply-To: <20110603003610.GD16306@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 3, 2011 at 3:36 AM, Ted Ts'o <tytso@mit.edu> wrote:
> On Thu, Jun 02, 2011 at 11:22:53AM -0600, Andreas Dilger wrote:
>> On 2011-06-02, at 8:59 AM, Eric Sandeen wrote:
>> > I don't really mind adding ext4dev to FSTYP case statements, it
>> > -is- something which blkid could, in theory, still return, and
>> > making xfstests cope with that and try to invoke fsck -t ext4dev
>> > doesn't bother me too much. =A0It is sadly an fs type embedded int=
o
>> > a few tools.
>>
>> I'm perfectly OK with using ext4dev as a filesystem type that allows=
 testing
>> changes to ext4 on a system that is already running ext4 as the root=
 fs.
>
> My take on this is that way too much time has been spent this subject=
=2E

No doubt.

> Being able to use ext4dev is useful, and given that we have all of
> this support in our existing system tools, why not use it to make ext=
4
> development more efficient/easy? =A0As a bonus you can build the ext4=
dev
> as a module, and that means you the compile/edit/debug cycle can be
> much faster since you can avoid doing a reboot, for those
> circumstances where using KVM is not possible/convenient. =A0Personal=
ly,
> I normally use KVM these days, but I can imagine situations where
> using ext4dev would be a better way to go. =A0For example, I'd probab=
ly
> use KVM on my laptop, but for testing on production servers in a data
> center, I'd probably use ext4dev, for a variety of local deployment
> considerations that's not worth going into here.
>
> That being said, whether or not we modify xfstests seems to be a moot
> point. =A0In order for me to do my bigalloc development, I've been
> patching common.rc so that "/sbin/mkfs.$FSTYP" --> "mkfs.$FSTYP" and
> "/sbin/fsck -t $FSTYP" --> "fsck.$FSTYP". =A0It's a 3 line change. =A0=
Not
> a big deal. =A0I've been making this change using /bin/ed after
> installing xfstests. =A0So if the XFS folks want to veto this change =
---
> who cares? =A0It's not hard to make the change locally in order to ma=
ke
> xfstests.
>
> On the other hand, given that xfstests is using "mkfs.$FSTYP", I don'=
t
> see why it's so important that it clings to "fsck -t $FSTYP" instead
> of using "fsck.$FSTYP". =A0There's no real benefit to calling the fsc=
k
> driver; it's just an extra fork and exec, and xfstests is being
> inconsistent by insisting on the use of the fsck driver, but not usin=
g
> the mkfs driver.
>
> But that being said, hacking xfstests is not hard, and if Dave and/or
> Eric feels strongly about resisting this change, it's not worth a lot
> of time, one way or another....
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0- Ted
>

I blame only myself for not presenting the case correctly.
I made it sound like I am trying to push my own private hack upstream.
Actually, all 10 people involved in snapshot development clone my xfste=
sts
tree from github, so we have no real need for the upstream change.
The reason I was pushing upstream is because I found this feature
so useful, I thought other developers may enjoy it as well.

Anyone on on this thread not having used ext4dev by next LSF
can come to me to claim his beer ;-)

Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
