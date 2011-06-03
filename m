From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH v2] xfstests: add support for ext4dev FSTYP
Date: Thu, 02 Jun 2011 22:26:05 -0500
Message-ID: <4DE8544D.30800@redhat.com>
References: <1306933012-8666-1-git-send-email-amir73il@users.sourceforge.net> <20110601232804.GL32466@dastard> <BANLkTi=sV5=PyZvNSd=DGNW-V84=27d7Yw@mail.gmail.com> <BANLkTimbPWfOJKq6er4mnSYNPcx6VHLcrw@mail.gmail.com> <BANLkTimKV3LxugkW6_cE5vutjcmatESXuw@mail.gmail.com> <4DE7A557.9040608@redhat.com> <7D3F86FA-5AA9-49B0-9AFE-F597E83C07B4@dilger.ca> <20110603003610.GD16306@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@dilger.ca>,
	"Amir G." <amir73il@users.sourceforge.net>,
	Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	sergey57@gmail.com, Amir Goldstein <amir73il@users.sf.net>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60430 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751701Ab1FCD0Z (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 2 Jun 2011 23:26:25 -0400
In-Reply-To: <20110603003610.GD16306@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 6/2/11 7:36 PM, Ted Ts'o wrote:
> On Thu, Jun 02, 2011 at 11:22:53AM -0600, Andreas Dilger wrote:
>> On 2011-06-02, at 8:59 AM, Eric Sandeen wrote:
>>> I don't really mind adding ext4dev to FSTYP case statements, it
>>> -is- something which blkid could, in theory, still return, and
>>> making xfstests cope with that and try to invoke fsck -t ext4dev
>>> doesn't bother me too much.  It is sadly an fs type embedded into
>>> a few tools.
>>
>> I'm perfectly OK with using ext4dev as a filesystem type that allows testing
>> changes to ext4 on a system that is already running ext4 as the root fs.
> 
> My take on this is that way too much time has been spent this subject.
> Being able to use ext4dev is useful, and given that we have all of
> this support in our existing system tools, why not use it to make ext4
> development more efficient/easy?  As a bonus you can build the ext4dev
> as a module, and that means you the compile/edit/debug cycle can be
> much faster since you can avoid doing a reboot, for those
> circumstances where using KVM is not possible/convenient.  Personally,
> I normally use KVM these days, but I can imagine situations where
> using ext4dev would be a better way to go.  For example, I'd probably
> use KVM on my laptop, but for testing on production servers in a data
> center, I'd probably use ext4dev, for a variety of local deployment
> considerations that's not worth going into here.
> 
> That being said, whether or not we modify xfstests seems to be a moot
> point.  In order for me to do my bigalloc development, I've been
> patching common.rc so that "/sbin/mkfs.$FSTYP" --> "mkfs.$FSTYP" and
> "/sbin/fsck -t $FSTYP" --> "fsck.$FSTYP".  It's a 3 line change.  Not
> a big deal.  I've been making this change using /bin/ed after
> installing xfstests.  So if the XFS folks want to veto this change ---
> who cares?  It's not hard to make the change locally in order to make
> xfstests.
> 
> On the other hand, given that xfstests is using "mkfs.$FSTYP", I don't
> see why it's so important that it clings to "fsck -t $FSTYP" instead
> of using "fsck.$FSTYP".  There's no real benefit to calling the fsck
> driver; it's just an extra fork and exec, and xfstests is being
> inconsistent by insisting on the use of the fsck driver, but not using
> the mkfs driver.
> 
> But that being said, hacking xfstests is not hard, and if Dave and/or
> Eric feels strongly about resisting this change, it's not worth a lot
> of time, one way or another....

I think we just want to make sure we understand the reasons for a change.

Every change has risks, and xfstests is used on a lot of different systems.

If I don't fully understand the motivation for a change, I ask questions.
All part of a careful review.

And I apologize for the mkfs vs. fsck inconsistency, that was probably
my fault, originally ;)

-Eric
 
> 						- Ted

