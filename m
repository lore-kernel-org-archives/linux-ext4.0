Return-Path: <SRS0=WpiV=MV=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:59372 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726445AbeJIV57 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Oct 2018 17:57:59 -0400
From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
To: "Theodore Y. Ts'o" <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org
Subject: Re: [PATCH RESEND v2 19/25] vfs: Handle case-exact lookup in d_add_ci
References: <20180924215655.3676-1-krisman@collabora.co.uk>
        <20180924215655.3676-20-krisman@collabora.co.uk>
        <20181007180953.GA10662@thunk.org>
Date: Tue, 09 Oct 2018 10:40:39 -0400
In-Reply-To: <20181007180953.GA10662@thunk.org> (Theodore Y. Ts'o's message of
        "Sun, 7 Oct 2018 14:09:53 -0400")
Message-ID: <87va6bmbdk.fsf@collabora.co.uk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

"Theodore Y. Ts'o" <tytso@mit.edu> writes:

> On Mon, Sep 24, 2018 at 05:56:49PM -0400, Gabriel Krisman Bertazi wrote:
>> This prevents a soft hang if called d_add_ci is called from the FS
>> layer, when doing a CI search but the result dentry is the exact match.
>
> This isn't the right way to fix this problem.  Take a look at how xfs
> handles this in fs/xfs/xfs_iops.c:xfs_vn_ci_lookup().  This logic
> should be in the file system, not in d_add_ci().  Also, we don't want
> to use d_same_name(), since that is *not* guaranteed to do an exact
> match.  It happens to do so for ext4 since we don't provide d_compare,
> but it's better just check for an exact match and call
> d_splice_alias() instead of d_add_ci() in ext4_lookup().
>
> Also note that d_same_name() is *not* guaranteeed to do an exact
> match, in particular if the file system provides d_compare (which
> granted, ext4 doesn't right now).  It's simpler to just do a direct
> strcmp in ext4_lookup.
>
> 					- Ted
>
> P.S.  Apologies for not having a chance to look at this series in
> detail until now.  It's been a crazy month...

Hey Ted,

No worries. Thanks for the review.

I'm aware of how xfs does it. I was looking for a generic way but I see
its problems now.  I will have it addressed in the next iteration.

thanks.

-- 
Gabriel Krisman Bertazi
