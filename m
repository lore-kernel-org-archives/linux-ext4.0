From: Roger Niva <rogerniva@gmail.com>
Subject: Re: Ext4 file corruption using cp
Date: Mon, 26 Nov 2012 09:48:10 +0100
Message-ID: <CAH3VSLwhe7ZHfuc1+RatWvrvAOAS3HakYoRr5+PNnvvrue9BmA@mail.gmail.com>
References: <CAH3VSLyZvtHC5G_Hx6oHr_jR43+vYz46nXLkifuD3gXGLd21yQ@mail.gmail.com>
	<CAH3VSLw_spHkb27VbRUG-81Rc=hwPDnhfGOe9LqExs0bFveujQ@mail.gmail.com>
	<61093A2B-5AEA-4ED8-B43D-AB6217B405AC@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:52575 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753839Ab2KZIsM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Nov 2012 03:48:12 -0500
Received: by mail-ea0-f174.google.com with SMTP id e13so4300550eaa.19
        for <linux-ext4@vger.kernel.org>; Mon, 26 Nov 2012 00:48:10 -0800 (PST)
In-Reply-To: <61093A2B-5AEA-4ED8-B43D-AB6217B405AC@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Nov 11, 2012 at 6:50 PM, Andreas Dilger <adilger@dilger.ca> wrote:
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
> You should probably try a new version of fileutils to see if that solves the problem. Alternately, if you run "sync" before "cp" this should also avoid the problem.
>
> Cheers, Andreas

Hi.

We have now been running a newer coreutils (/bin/cp) for about a week
without seeing this pop up again, so we're reasonably sure it fixed
the issue for us.

Thanks a bunch!


-- 
Vennlig hilsen,
Roger Niva
