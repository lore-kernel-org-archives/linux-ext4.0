Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34F65C19F29
	for <linux-ext4@archiver.kernel.org>; Thu,  4 Aug 2022 00:44:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238650AbiHDAou (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 3 Aug 2022 20:44:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233944AbiHDAou (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Aug 2022 20:44:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC88B5F12C
        for <linux-ext4@vger.kernel.org>; Wed,  3 Aug 2022 17:44:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF1A4B8243B
        for <linux-ext4@vger.kernel.org>; Thu,  4 Aug 2022 00:44:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B2DD1C433C1
        for <linux-ext4@vger.kernel.org>; Thu,  4 Aug 2022 00:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659573885;
        bh=yJ1+BG5RMRj7AKouNE3myoL5lEFaLgXMxrj7GOs2eYk=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=W2StBlD5+jnixDFwa99/Nv2qDth4eXXtLTAGEkuEIXQy5ISAEEVuw2qwW9ujHnr9q
         RMLSgITgqrtts1ml+9pVvkRkJcM/FFdjxOJLkKxokoNnWN0/h9heqX3coDbhuFu8y0
         C3w3STDnAi1mTiqmn1q38ypEB7xVnCpftIv80RFn/7bFLu46TeNYPlkMGIH0a1ul8y
         Fuh4jzoyzixon7aaE1VTp/Ez7oSVe48otNSAnyfj1wrfTGHbLSFBHxryU83TvinKb6
         xxGYXZyLlnAE5O6HpJLvniWA6sMsnr1cj6iNSIdbwr/64Y2q/g3QA37Uv8vh34c6GW
         220IqTJwk/yTQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 9D695C433E9; Thu,  4 Aug 2022 00:44:45 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 216322] Freezing of tasks failed after 60.004 seconds (1 tasks
 refusing to freeze... task:fstrim  ext4_trim_fs - Dell XPS 13 9310
Date:   Thu, 04 Aug 2022 00:44:45 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: ext4
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: tytso@mit.edu
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-216322-13602-8CEcnRTAPy@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216322-13602@https.bugzilla.kernel.org/>
References: <bug-216322-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216322

Theodore Tso (tytso@mit.edu) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu

--- Comment #2 from Theodore Tso (tytso@mit.edu) ---
So the problem is that the FITRIM ioctl does not check if a signal is pendi=
ng,
and so if the fstrim program requests that the entire SSD (len=3DULLONG_MAX=
),
like the broomstick set off by Mickey Mouse in Fantasia's "Sorcerer's
Apprentive", it will mindlessly send discard requests for any blocks not in=
 use
by the file system until it is done.   Or to put it another way, "Neither r=
ain,
nor snow, or a request to freeze the OS, shall stop the FITRIM ioctl from i=
ts
appointed task."  :-)

The question is how to fix things.   The problem is that the FITRIM ioctl
interface is pretty horrible.   The fstrim_range.len variable is an IN/OUT
field where on the input it is the number of bytes that should be trimmed (=
from
start to start+len) and when the ioctl returns fstrm_range.len is the numbe=
r of
bytes that were actually trimmed.   So this is not really amenable for
-ERESTARTSYS.

Worse, the fstrim program in util-linux doesn't handle an EAGAIN error retu=
rn
code, so if it gets the EAGAIN after try_to_freeze_tasks send the fake sign=
al
to the process, fstrim will print to stderr "fstrim: FITRIM ioctl failed" a=
nd
the rest of the file system trim operation will be aborted.

It might be that the only way we can fix this is to have FITRIM return EAGA=
IN,
which will stop the fstrim in its tracks.  This is... not great, but typica=
lly
fstrim is run out of crontab or a systemd timer once a month, so if the user
tries to suspend right as the fstrim is running, hopefully we'll get lucky =
next
month.    We can then try teach fstrim to do the right thing, and so this
lossage mode would only happen in the combination of a new kernel and an ol=
der
version of util-linux.

I'm not happy with that solution, but the alternative of creating a new FIT=
RIM2
ioctl that has a sane interface means that you need an new kernel and a new
util-linux package, and if you don't, the user will have to deal with a hot
laptop bag and a drained battery.   And not changing FITRIM's behaviour will
have the same potential end result, if the user gets unlucky and tries to
suspend the laptop when there is more than 60 seconds left before FITRIM to
complete.   :-/

The other thing I'll note is that every file system has its own FITRIM
implementation, and I suspect they all have this issue, because the FITRIM
interface is fundamentally flawed.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
