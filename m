From: Manish Katiyar <mkatiyar@gmail.com>
Subject: Re: [PATCH 2/3] ext4 : Pass GFP_KERNEL for transaction allocation if
 caller can handler failures
Date: Sun, 30 Jan 2011 11:44:25 -0800
Message-ID: <AANLkTik8_iO=LF=HqmZyNGC=t5TVqEHzb=G78M-NWMHR@mail.gmail.com>
References: <AANLkTinVBicZyTthnp5SjOoHUWHcKc1Css46RjpfEEnh@mail.gmail.com>
 <20110125161745.GC4088@quack.suse.cz> <AANLkTiniUaD8SN53BKFC2ayku-4m=4EATKxBc148d51G@mail.gmail.com>
 <20110130194251.GE4258@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jan Kara <jack@suse.cz>, ext4 <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:45867 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867Ab1A3Toq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 30 Jan 2011 14:44:46 -0500
Received: by qwa26 with SMTP id 26so4830541qwa.19
        for <linux-ext4@vger.kernel.org>; Sun, 30 Jan 2011 11:44:46 -0800 (PST)
In-Reply-To: <20110130194251.GE4258@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jan 30, 2011 at 11:42 AM, Ted Ts'o <tytso@mit.edu> wrote:
> On Tue, Jan 25, 2011 at 12:05:07PM -0800, Manish Katiyar wrote:
>> Thanks a lot Jan, I will have a look at the functions you mentioned
>> and send an updated version.
>
> Please do the cleanups as separate patches, each with a separate
> commit description.

Hi Ted,

Do you mean separate patch for each of the changed functions ?


-- 
Thanks -
Manish
