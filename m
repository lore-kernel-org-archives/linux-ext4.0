Return-Path: <SRS0=ZxZh=OA=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:49960 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726505AbeKVGV4 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 22 Nov 2018 01:21:56 -0500
From: Gabriel Krisman Bertazi <krisman@collabora.com>
To: "Theodore Y. Ts'o" <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org
Subject: Re: [PATCH e2fsprogs 9/9] tune2fs: Prevent enabling encryption flag on encoding-aware fs
References: <20181015211220.27370-1-krisman@collabora.co.uk>
        <20181015211220.27370-10-krisman@collabora.co.uk>
        <20181121050301.GD26006@thunk.org>
Date: Wed, 21 Nov 2018 14:46:13 -0500
In-Reply-To: <20181121050301.GD26006@thunk.org> (Theodore Y. Ts'o's message of
        "Wed, 21 Nov 2018 00:03:01 -0500")
Message-ID: <87d0qydxiy.fsf@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

"Theodore Y. Ts'o" <tytso@mit.edu> writes:

> On Mon, Oct 15, 2018 at 05:12:20PM -0400, Gabriel Krisman Bertazi wrote:
>> The kernel will refuse to mount filesystems with the encryption and
>> encoding features enabled at the same time.  The encoding feature can
>> only be set at mount time, so we can just prevent encryption from being
>> set at a later time by tune2fs.
>> 
>> Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
>
> This check also needs to be in mke2fs, right?  I don't think I saw it
> in your mke2fs patch.

I hadn't noticed you could set the encryption flag at mkfs time.
sorry.  will fix in v3.
-- 
Gabriel Krisman Bertazi
