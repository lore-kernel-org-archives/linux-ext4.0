From: Vitali Lovich <vlovich@gmail.com>
Subject: question about i_dtime being used as an orphan list pointer
Date: Wed, 25 Aug 2010 12:22:22 -0700
Message-ID: <AANLkTi=3hK1RLRJ+2Kt0ju=HEr-LdkO9eX_YxLfp0wea@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52017 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690Ab0HYTWn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 Aug 2010 15:22:43 -0400
Received: by yxg6 with SMTP id 6so319368yxg.19
        for <linux-ext4@vger.kernel.org>; Wed, 25 Aug 2010 12:22:42 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

So I've run into this problem where the clock was reset into the 1970s
on my system, causing e2fsck to get confused & think a file I deleted
actually had an orphan list inode pointer stored in the i_dtime
instead of the deletion time, causing e2fsck to get all confused &
return an error code.

My current idea for a workaround is to clamp the value to midnight
2000 if get_seconds returns that, but I'm not really enamoured with
that idea.

Looking at this further, I made the following observations (please let
me know if I'm completely off base):

Even a value of midnight 2010 corresponds to a limit of only about 1
billion files (1 262 304 000).  Thus it seems if you delete a file on
a partition with more than a billion files, it will make e2fsck think
you've got a corrupt file-system even though you don't.

A slightly related question I have is if anyone knows whether i_dtime
is actually used as a timestamp for anything useful in kernel or
user-space?  Can I just set d_time to 0xffffffff when it's deleted
instead of giving it wall-clock time?

Thanks for any feedback,
Vitali
