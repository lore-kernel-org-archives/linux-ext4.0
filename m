From: Peng Tao <bergwolf@gmail.com>
Subject: Re: Ext4 file corruption using cp
Date: Tue, 13 Nov 2012 19:33:03 +0800
Message-ID: <CA+a=Yy4_fXHtc9Uu_tb5oMBi2PVXPCYJgsZZ0OoRsvQ6AoT6cw@mail.gmail.com>
References: <CAH3VSLyZvtHC5G_Hx6oHr_jR43+vYz46nXLkifuD3gXGLd21yQ@mail.gmail.com>
 <CAH3VSLw_spHkb27VbRUG-81Rc=hwPDnhfGOe9LqExs0bFveujQ@mail.gmail.com> <61093A2B-5AEA-4ED8-B43D-AB6217B405AC@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Roger Niva <rogerniva@gmail.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:51753 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816Ab2KMLdZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Nov 2012 06:33:25 -0500
Received: by mail-la0-f46.google.com with SMTP id h6so5337067lag.19
        for <linux-ext4@vger.kernel.org>; Tue, 13 Nov 2012 03:33:23 -0800 (PST)
In-Reply-To: <61093A2B-5AEA-4ED8-B43D-AB6217B405AC@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 12, 2012 at 1:50 AM, Andreas Dilger <adilger@dilger.ca> wrote:
> On 2012-11-11, at 4:37, Roger Niva <rogerniva@gmail.com> wrote:
>>
>> We are trying to pin down a file corruption issue we have on 5
>> productionservers and would like some suggestions about how to proceed
>> to find the culprit. It may or may not be ext4-related, but as that is
>> the only clue we have so far, we're trying here first.
>>
>> The productionservers are running Slackware 13.37 with a selfcompiled
>> kernel (no patches or external modules).
>> We have a script running daily that copies files from one folder to
>> another using cp.
>
> there was a bug in ext4 FIEMAP ioctl code in the past that interacted badly with fileutils for copying files that were just written and still in cache.  That was around 2.6.26 or so.
>
It is commit 6d9c85eb700bd3ac59e63bb9de463dea1aca084c that went in at v2.6.39.

However, looking at ext4_fiemap(), it does seem racy. If pages are
written back between ext4_ext_find_extent() and ext4_ext_fiemap_cb(),
fiemap will report holes. This can possibly happen when cp runs
concurrently with background flusher, which is common for a long
running production server. If this is true, the bug also exists in
latest upstream.

--
Thanks,
Tao
