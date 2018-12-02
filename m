Return-Path: <SRS0=gW7+=OL=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:40092 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725801AbeLBMHr (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Dec 2018 07:07:47 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id BAB4E2AB05
        for <linux-ext4@vger.kernel.org>; Sun,  2 Dec 2018 12:07:46 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Sun, 02 Dec 2018 12:07:44 +0000
Message-ID: <bug-201685-13602-ZVTBvlNkb1@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #139 from Marc Burkhardt (marc@osknowledge.org) ---
(In reply to carlphilippreh from comment #136)
> (In reply to Rainer Fiebig from comment #132)
> > (In reply to carlphilippreh from comment #129)
> > > While I wasn't able to reproduce the bug for quite some time, it ended up
> > > coming back. I'm currently running 4.19.6 and I see invalid metadata in
> > > files that I have written using this version.
> > 
> > I think it could be helpful if you provided your .config(s) here.
> > 
> > And what kernel are you using: self-compiled/from your distribution
> (which)?
> > If self-compiled: have you made changes to the .config?
> > 
> > The set-up of the boxes you mentioned in comment 5 seems just right to hunt
> > this down. ;)
> 
> I'm configuring the kernels myself. Two things that I always enable and that
> _might_ be related are:
> 
> CONFIG_BLK_WBT / CONFIG_BLK_WBT_MQ
> and
> CONFIG_CFQ_GROUP_IOSCHED
> 
> Maybe I can come up with a way to reproduce this bug more quickly. Writing a
> lot of (small) files and then deleting them seems like a good way so far.

I have these config options set and _currently_ no corruption.

Having this compiled in is *probably* not what to look for. Rather people
should seek for actual *usage* of these features. I use the deadline scheduler.

root@marc:~ # egrep  "(BLK_WBT|IOSCH)" /boot/config-4.19.5loc64 
CONFIG_BLK_WBT=y
CONFIG_BLK_WBT_SQ=y
CONFIG_BLK_WBT_MQ=y
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
CONFIG_CFQ_GROUP_IOSCHED=y
CONFIG_DEFAULT_IOSCHED="deadline"
CONFIG_MQ_IOSCHED_DEADLINE=y
CONFIG_MQ_IOSCHED_KYBER=y
CONFIG_IOSCHED_BFQ=y
# CONFIG_BFQ_GROUP_IOSCHED is not set


Could someone gather a list of what actually is in .configs but is
relevant/irrelevant? I don't want to do is but I'm not really sure to not mess
is up. I mean there was "DAX enabled in the .config" talked about but I have it
compiled-in but I'm not actually using is.

I would, moreover, like to gather actual setting used by people who run into
the bug and those who are not, like currently used schedulers, nr_requests,
discard, ...

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
