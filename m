From: Srivatsan Canchivaram <crsrivatstechnical@gmail.com>
Subject: Re: Segmentation fault in mke2fs
Date: Mon, 16 Dec 2013 11:17:09 -0500
Message-ID: <CAO_L5k_UsqLhYqHeN-3mZL2RCp09sdpAL4xV0dhXAOqE_ScTaw@mail.gmail.com>
References: <CAO_L5k9iSm88wrs9W_yNCD1i8sy0SXfXJdbCwL840Hnn6Ef-0g@mail.gmail.com>
	<CAO_L5k_cLUdXNOhsAP6TkxtTHWv5hafx1dTmruaZnVmyGG0oKg@mail.gmail.com>
	<20131214065950.GB24998@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:38303 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143Ab3LPQRJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Dec 2013 11:17:09 -0500
Received: by mail-pa0-f44.google.com with SMTP id fa1so3156514pad.3
        for <linux-ext4@vger.kernel.org>; Mon, 16 Dec 2013 08:17:09 -0800 (PST)
In-Reply-To: <20131214065950.GB24998@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

The hardware is a stable product that has been in use for a while.
We have experienced a number of issues with the toolchain that we
received from the vendor.
They are about to release a new, official version this week.

So, I will try this test again with the new toolchain at some point soon.

Thanks to you and Eric for the replies.

Best,
Sri

On Sat, Dec 14, 2013 at 1:59 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Fri, Dec 13, 2013 at 06:33:22PM -0500, Srivatsan Canchivaram wrote:
>> Hello,
>>
>> I found that the segmentation fault occurs in optimized code (-O2). It
>> does not happen when optimization is turned off. I am not sure what
>> exactly happened but mke2fs is now able to get past that point.
>
> This is really starting to smell like a compiler bug.  Are you sure
> you are using a stable version of gcc?
>
>> The command now fails at a different point:
>>
>> ext2fs_mkdir: EXT2 directory corrupted while creating /lost+found
>>
>> Tracing from the ext2fs_mkdir() function, I found that the code
>> returns an error here:
>> ext2fs_read_dir_block3(): returns EXT2_ET_DIR_CORRUPTED
>
> The mke2fs program has just created the root directory, and when it is
> trying to link the newly created lost+found directory to the root
> directory, when it reads in the just-created root directory, when it
> tries to byte-swap the directory block, the values found the root
> directory were insane.
>
> Combined with the fact that the other failure was someplace completely
> diferent, I'm at this point deeply suspicious about your compiler tool
> chain and/or your hardware where you are conducting your tests.
>
>                                          - Ted
