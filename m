From: Azat Khuzhin <dohardgopro@gmail.com>
Subject: Re: ext4, jbd2: task blocked for more than 120 seconds.
Date: Mon, 22 Apr 2013 12:58:09 +0000
Message-ID: <CAAW1UO-W3W6+wioq+kYULxyMJphtRngSzvT5+qgqyvJsMOm+qA@mail.gmail.com>
References: <CAAW1UO8bbhfuw-J=0cxLB0uTps6aecTJe4ro2SgExpcK-SDouw@mail.gmail.com>
	<CAAW1UO_+_z8zyRhX-HZKWHsxiZ8fE54bZvxU_uuXTmMQ3=+qSA@mail.gmail.com>
	<CAAW1UO_fwrryWFMdTh7v5wSKMTdfmDpWqU=bJ0j86AHAGYv77A@mail.gmail.com>
	<20130422111759.GB9950@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ia0-f182.google.com ([209.85.210.182]:59449 "EHLO
	mail-ia0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803Ab3DVM6K (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Apr 2013 08:58:10 -0400
Received: by mail-ia0-f182.google.com with SMTP id a5so379416iah.41
        for <linux-ext4@vger.kernel.org>; Mon, 22 Apr 2013 05:58:09 -0700 (PDT)
In-Reply-To: <20130422111759.GB9950@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Theodore,

I will apply it to linux tree, and upgrade kernel.
However this is not error, which occur frequently.
So if I reproduce it, I let you know.

On Mon, Apr 22, 2013 at 11:17 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> Hi Azat,
>
> Could you try and see if the following patch (which is queued for the
> next merge window) solves the problem which you are seeing?
>
>      http://patchwork.ozlabs.org/patch/234776/
>
> Thanks!!
>
>                                                 - Ted



-- 
Respectfully
Azat Khuzhin
Primary email a3at.mail@gmail.com
