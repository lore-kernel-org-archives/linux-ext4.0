Return-Path: <SRS0=V5lK=QY=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBD85C43381
	for <linux-ext4@archiver.kernel.org>; Sun, 17 Feb 2019 16:35:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BAF8B2192C
	for <linux-ext4@archiver.kernel.org>; Sun, 17 Feb 2019 16:35:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dpVmzQf1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbfBQQfc (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 17 Feb 2019 11:35:32 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34450 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725810AbfBQQfc (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 17 Feb 2019 11:35:32 -0500
Received: by mail-wr1-f67.google.com with SMTP id f14so15669490wrg.1;
        Sun, 17 Feb 2019 08:35:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=Sql+ZQ+fDimhcvqiB6tREGNUqpSogk9WsvMIdFlg2EA=;
        b=dpVmzQf1DhTIxTQyVkAHW326lDfAc9uFAQ/DrgQbi1kAzR0jdc60W3tHlKJozO549e
         KJIQxl2pFCa5IBDdHmSPGu3gTg6BOgPNvSwBd2XugCUofuZkRy8jZtWIbf5j51eVZ23+
         Lah5oH8ZIMsaByqljj9pctJwSZUojpUSTqOLF7fvv1lUda+hfLCofmrWvAl2XBu4RFGs
         ES9ibBbjaCH7Kzov56EFiAnc4fQikET/dhzcbQo7IVOicrjylaYF2gDyg+6+P3Aa9i8L
         Mce2nPvnUBfsza8AQ2yRnpUTvvSbIEyFt7Ool/ZgzFEQcBgJEBpOCnub8I/fOjyg9CyN
         39Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=Sql+ZQ+fDimhcvqiB6tREGNUqpSogk9WsvMIdFlg2EA=;
        b=Rq1hUzSD73RtYm0HGjFmjeY9VHcleScX9Ww5bzrUBSo93uob2SReuOyRviMsxheuWg
         qyuMB5vOByVJJP827CEqxSXw8cdLXSkyhoOu/TtQ5R4ksjutPMNSCyyHmmeg+E9b1tuc
         5S2egKy6Fs927ZbXYk3B6PJ8ZiaYljtPZAO9xGs3hEg41F5VB2PsNPalQycE9sK1XWA6
         gAAZ2r5hYlRrHhd3UWv3FDBvROM/ziGfTgb2lN/Pqigh3C88GWwWY5kworvOGHOJ4Qhi
         XelOPotlaUmd4zPpU2Kvt3GJGTw3OqHttQ1aw2GuZacGv9+Ve4CEu7zNRN/yRlSF7txZ
         OWbg==
X-Gm-Message-State: AHQUAuZ0VoXoTuCmJBNCHlycbGrBai31stNXxQMyE2IZOVeEhr1ss39g
        dNU46VYRMxuHmxKa4/FrnIUn3n0p
X-Google-Smtp-Source: AHgI3Iai+RDAGgt9EiMTUvISN00dvdaBjTYCovCcKfjgCVyU0e4/1jxpyrErlKnpuvD5kSbLYE6Eog==
X-Received: by 2002:a05:6000:10ce:: with SMTP id b14mr3855548wrx.221.1550421329153;
        Sun, 17 Feb 2019 08:35:29 -0800 (PST)
Received: from [10.0.0.5] ([207.232.55.62])
        by smtp.gmail.com with ESMTPSA id 62sm25223268wra.46.2019.02.17.08.35.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 17 Feb 2019 08:35:28 -0800 (PST)
Subject: Re: [RFC PATCH 0/6] Allow setting file birth time with utimensat()
To:     Dave Chinner <david@fromorbit.com>,
        Omar Sandoval <osandov@osandov.com>
References: <cover.1550136164.git.osandov@fb.com>
 <20190214220626.GV14116@dastard>
Cc:     linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        kernel-team@fb.com, linux-api@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org
From:   Boaz Harrosh <openosd@gmail.com>
Message-ID: <6a9dc05a-0445-d0ab-0140-1de4fee7ba9b@gmail.com>
Date:   Sun, 17 Feb 2019 18:35:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:45.0) Gecko/20100101
 Thunderbird/45.4.0
MIME-Version: 1.0
In-Reply-To: <20190214220626.GV14116@dastard>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On 15/02/19 00:06, Dave Chinner wrote:
> On Thu, Feb 14, 2019 at 02:00:07AM -0800, Omar Sandoval wrote:
>> From: Omar Sandoval <osandov@fb.com>
>>
>> Hi,
>>
>> Since statx was added in 4.11, userspace has had an interface for
>> reading btime (file creation time), but no way to set it. This RFC patch
>> series adds support for changing btime with utimensat(). Patch 1 adds
>> the VFS infrastructure, patch 2 adds the support to utimensat() with a
>> new flag, and the rest of the patches add filesystem support; I excluded
>> CIFS for now because I don't have a CIFS setup to test it on.
>>
>> Updating btime is useful for at least a couple of use cases:
>>
[1]
>> - Backup/restore programs (my motivation for this feature is btrfs send)
>> - File servers which interoperate with operating systems that allow
>>   updating file creation time, including Mac OS [1] and Windows [2]
> 
> So you're adding an interface that allows users to change the create
> time of files without needing any privileges?
> 
[2]
> Inode create time is forensic metadata in XFS  - information we use
> for sequence of event and inode lifetime analysis during examination
> of broken filesystem images and systems that have been broken into.
> Just because it's exposed to userspace via statx(), it doesn't mean
> that it is information that users should be allowed to change. i.e.
> allowing users to be able to change the create time on files makes
> it completely useless for the purpose it was added to XFS for...
> 
<snap>

I think the difference in opinion here is that there are two totally
different BTIme out in the world. For two somewhat opposite motivations
and it seems they both try to be crammed into the same on disk space.

One - Author creation time
  This is a Windows originated creature and later MAC (and all vendors who
  make a living by serving cifs (hint see my email address))

  This is a tag carried globally on the globe denoting the time of the
  original creator of the file. copy, download, backup-restore and so
  on preserve it from the very first original creation.
  This creature is a user oriented information. That needs to be carefully
  orchestrated by all parties

Two - Local creation time
  This is an immutable local FS information that helps in debugging and
  FS-checking / recovery of data. It is an information that kind of denotes
  the order of creation of files on a local FS.

So it looks like both sides are correct trying to preserve their own guy?

XFS invented [2] I'd let it be. If you need [1] on XFS better push for
a well defined standardized xattr and be in peace.

BTRFS should decide which one of [2] or [1] it has space for in the inode
and commit to it. Documenting well what it is.

That said putting my Netapp hat. I would love to see an easy API
for Author-creation-time BTime type of value. That is accessed
uniformly by user-mode and/or Network file servers (NFS/CIFS).
And would love to see a generic implementation of that interface
that puts it into a standardized xattr if the FS in question does
not have a native support for it [1].

So I love these patches. And would want to see this through. But
let us understand each other?

Thanks
Boaz

