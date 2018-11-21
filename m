Return-Path: <SRS0=ZxZh=OA=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:49952 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732849AbeKVGUi (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 22 Nov 2018 01:20:38 -0500
From: Gabriel Krisman Bertazi <krisman@collabora.com>
To: "Theodore Y. Ts'o" <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org
Subject: Re: [PATCH e2fsprogs 6/9] lib/ext2fs: Implement NLS support
References: <20181015211220.27370-1-krisman@collabora.co.uk>
        <20181015211220.27370-7-krisman@collabora.co.uk>
        <20181121050148.GC26006@thunk.org>
Date: Wed, 21 Nov 2018 14:44:54 -0500
In-Reply-To: <20181121050148.GC26006@thunk.org> (Theodore Y. Ts'o's message of
        "Wed, 21 Nov 2018 00:01:48 -0500")
Message-ID: <87h8gadxl5.fsf@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

"Theodore Y. Ts'o" <tytso@mit.edu> writes:

> On Mon, Oct 15, 2018 at 05:12:17PM -0400, Gabriel Krisman Bertazi wrote:
>> Basic NLS support is required in e2fsprogs because of fsck, which
>> needsto calculate dx hashes for encoding aware filesystems.  this patch
>> implements this infrastructure as well as ascii support.
>> 
>> We don't need to do all the dance of versioning as we do in the kernel,
>> because we know before-hand which encodings and versions we
>> support (those we know how to store in the sb), so it is simpler just to
>> create static tables.
>> 
>> Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
>
> I see the case folding tables for ASCII, but it looks like the case
> folding tables for Unicode aren't included.  Am I missing something?

Oh, I think mentioned this in the cover letter, I removed the utf8 parts
from this version for no good reason.  It is already part of v2. :)


-- 
Gabriel Krisman Bertazi
