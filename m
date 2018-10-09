Return-Path: <SRS0=WpiV=MV=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:59544 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726445AbeJIWKl (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Oct 2018 18:10:41 -0400
From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
To: "Theodore Y. Ts'o" <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org
Subject: Re: [PATCH RESEND v2 21/25] ext4: Add encoding mount options
References: <20180924215655.3676-1-krisman@collabora.co.uk>
        <20180924215655.3676-22-krisman@collabora.co.uk>
        <20181007192221.GB10662@thunk.org>
Date: Tue, 09 Oct 2018 10:53:19 -0400
In-Reply-To: <20181007192221.GB10662@thunk.org> (Theodore Y. Ts'o's message of
        "Sun, 7 Oct 2018 15:22:21 -0400")
Message-ID: <878t37masg.fsf@collabora.co.uk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

"Theodore Y. Ts'o" <tytso@mit.edu> writes:

> On Mon, Sep 24, 2018 at 05:56:51PM -0400, Gabriel Krisman Bertazi wrote:

> It seems to me that adding support for setting the encoding parameters
> via mount options is a bad idea.  The encoding is going to impact
> directory hash; which means if the file system has directories created
> using, say, ASCII as its encoding, and then the encoding changes to
> UTF-8, directory lookups won't work correctly.  So I think this commit
> needs to be dropped, and support for setting the encoding needs to be
> added to e2fsprogs as the primary way encoding settings are made.

The main reason I had this patch is debugging, so I am ok with dropping
it.

> We need e2fsprogs support before this feature is ready for production
> use, since e2fsck needs to be able to properly rebuild directories.
>
> Do you agree?

I have support for e2fsprogs in the branch I mentioned in the cover
letter, I will rebase and start submitting it in the next iteration.

I am only supporting encoding selection at mkfs time, so I don't need to
rebuild the hashes, (except for fsck errors).  I'm not sure I care about
changing the encoding after creation time, since this complicates
things, for instance by increasing the risk of file name collisions.
I'm also only allowing case-sensitiveness configuration changes on empty
directories for the same reason.

I will start by submitting kernel/e2fsprogs patches to reserve the
superblock bits.  Do we agree on the current superblock format?

Also, what is the best list to send the NLS patches?  fsdevel?

-- 
Gabriel Krisman Bertazi
