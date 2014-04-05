From: Azat Khuzhin <a3at.mail@gmail.com>
Subject: Re: [PATCH] ext4: initialize multi-block allocator before checking
 block descriptors
Date: Sat, 5 Apr 2014 19:51:29 +0400
Message-ID: <CAG5DWohnPsD5fZgi_BLzbA=FTecpsVY=UqXDm4+Z3W9d0D3mZQ@mail.gmail.com>
References: <CAG5DWoj0pYD8O17qw_-MK+JX_hsFj04ReUPztShmKWzz45gRbQ@mail.gmail.com>
	<20140316023841.GA902@thunk.org>
	<CAG5DWog0BDHTh1edtQ+457SmJeL_0MacgZ1gYeNL4sY4yEqZWw@mail.gmail.com>
	<20140316161637.GA19885@azat>
	<20140316184634.GA14162@thunk.org>
	<20140316205659.GC19885@azat>
	<20140317020029.GC14162@thunk.org>
	<CAG5DWogdTPBOfccVa3xGciLaRedPC1memAmjxnG2uEwSVV64DA@mail.gmail.com>
	<20140317175302.GD19885@azat>
	<20140325001700.GC13535@thunk.org>
	<20140325062405.GA25115@azat>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "open list:EXT4 FILE SYSTEM" <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qa0-f51.google.com ([209.85.216.51]:59957 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062AbaDEPv3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Apr 2014 11:51:29 -0400
Received: by mail-qa0-f51.google.com with SMTP id j7so4276684qaq.38
        for <linux-ext4@vger.kernel.org>; Sat, 05 Apr 2014 08:51:29 -0700 (PDT)
In-Reply-To: <20140325062405.GA25115@azat>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 25, 2014 at 10:24 AM,  <a3at.mail@gmail.com> wrote:
> On Mon, Mar 24, 2014 at 08:17:00PM -0400, tytso@mit.edu wrote:
>> On Mon, Mar 17, 2014 at 09:53:02PM +0400, a3at.mail@gmail.com wrote:
>> > I was wrong, I've just tested on i386, and got the same errors as you.
>>
>> I assume you will resubmit this patch once you figure out how to avoid
>> the error on 32-bit x86 systems?
>
> Yes, sure, thanks.
> (I just don't have enough free time right now for this.)
>
> BTW now I have this errors on x86_64 too.

Hi Ted,
I just sent v4 patch, I've tested it and tests passed without any fs
corruptions.
(It based on patch from ext4-patch-queue)

Thanks.

>
>>
>>                                               - Ted
>
> --
> Respectfully
> Azat Khuzhin



-- 
Respectfully
Azat Khuzhin
