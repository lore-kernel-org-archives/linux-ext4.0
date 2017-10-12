From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: Re: [RFC] Ext4 case insensitive proposal
Date: Thu, 12 Oct 2017 03:36:47 -0300
Message-ID: <874lr4q3cw.fsf@dilma.collabora.co.uk>
References: <871snrvu3r.fsf@dilma.collabora.co.uk>
        <20170914231130.5t6ndiaortuo42av@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:38086 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750774AbdJLGgy (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Oct 2017 02:36:54 -0400
In-Reply-To: <20170914231130.5t6ndiaortuo42av@thunk.org> (Theodore Ts'o's
        message of "Thu, 14 Sep 2017 19:11:30 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Ts'o <tytso@mit.edu> writes:

Hi Ted,

> This isn't a complete implementation of my proposal.  In particular
> one of the things which is missing is:
>
>    1.  If case-insensitivity is enabled, override the default dcache hash
>    and compare operations to ones that are case insensitive in ext4's
>    dcache_operations structure.
>
> This is needed so there is a single dcache entry for case-folded file
> names.

Sorry for the delay in replying.  In fact, the dcache hash operations
were part of my original patch, but I dropped it before submitting in
favor of d_add_ci(), which I expected would prevent duplication of the
same elements, differing only by case in the dentry cache.

I have shared it in a different branch if you want to take a look.

git://git.collabora.com/git/user/krisman/linux.git -b ext4-insensitive-dcache-patch

Despite that, I've been learning my way in the VFS subsystem,
investigating the suggestion made by you and HCH on the thread I
mentioned:

> I talked to Christoph at the Plumbers Closing party, and he suggested
> that we get something simple in first which (a) assumes no on-disk
> format changes, (b) does everything in the VFS layer, by using a
> MS_CASE_FOLD, uses a case-insensitive dentry hash, and which degrades
> to a brute force search in the VFS by using readdir interfaces if the
> direct lookup does not succeed, and (c) at least initially assumes
> only ASCII.

My current question on this approach is how the MS_CASE_FOLD could be
exposed to userspace.  It is not any system call that can receive a new
flag to request an insensitive lookup.  In this case, are you
considering a new set of system calls to perform case-insensitive
lookups, some per-process thing or another approach I'm not considering?
Can you provide me with more information on this?

Thanks for helping out on reviewing my code.

--
Gabriel Krisman Bertazi
