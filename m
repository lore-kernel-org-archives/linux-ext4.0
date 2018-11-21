Return-Path: <SRS0=ZxZh=OA=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:49676 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728545AbeKVFCv (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 22 Nov 2018 00:02:51 -0500
From: Gabriel Krisman Bertazi <krisman@collabora.com>
To: "Theodore Y. Ts'o" <tytso@mit.edu>
Cc: kernel@collabora.com, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext2fs: Fix build of new superblock fields on BE machines
References: <20181121001127.1868-1-krisman@collabora.com>
        <20181121162432.GF26006@thunk.org>
Date: Wed, 21 Nov 2018 13:27:20 -0500
In-Reply-To: <20181121162432.GF26006@thunk.org> (Theodore Y. Ts'o's message of
        "Wed, 21 Nov 2018 11:24:32 -0500")
Message-ID: <87h8gajng7.fsf@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

"Theodore Y. Ts'o" <tytso@mit.edu> writes:

> On Tue, Nov 20, 2018 at 07:11:27PM -0500, Gabriel Krisman Bertazi wrote:
>> New superblock fields must be byte swapped before being accessed in Big
>> Endian machines.
>> 
>> Not tested on an actual BE machine.
>> 
>> Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
>> ---
>> 
>> I just noticed this today.  I don't see the patch that includes this
>> field already pushed to kernel.org, so if you want to squash this one to
>> that patch before pushing to make the result more bisectable in BE
>> machines, I am ok with that.
>


> Oops, sorry, I just pushed it out before I saw your note.  I'll add it
> as a follow-on commit right away.  Fortunately we don't do too much
> debugging on BE machines, so it's probably not worth breaking the git
> rules and rewinding, even though it's highly unlikely anyone has done
> a git pull in the last 10 minutes or so.
>
> While we're at it, I should have noticed this earler before I acceptd
> patch 2 in your series.  Could you also send a follow up patch which
> adds a quick description of the fname_encoding feature to the ext4.5
> man page?

Hi,

Thanks for pushing it and yes, I can send the follow up patch.

>
> Also, did your v2 patch series to e2fsprogs reflect any of the
> comments I made late last night on the rest of the v1 patch series?

No, it only reflects the comments you made on the night before, up to
patch 3/10, as I hadn't seen your new responses before submitting v2.

So, please disregard v2, and I will follow up with a new iteration
applying your new suggestions.

Thanks.

-- 
Gabriel Krisman Bertazi
