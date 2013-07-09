From: Michael <mike@draftx.net>
Subject: Re: EXT4 Larger Than 16TB
Date: Tue, 9 Jul 2013 08:45:12 -0500
Message-ID: <CAGJTRchb5KpYLEOKB1bzNSmJ4SQQ9YVf9UZEsd+Hu38D5mW05g@mail.gmail.com>
References: <CAGJTRcg0SHP3-9V-0nDttZ+atn5Kbhf9RRnn_VOaNOq8MgDe6Q@mail.gmail.com>
	<20130709021403.GC6000@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:45082 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656Ab3GINpM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Jul 2013 09:45:12 -0400
Received: by mail-pd0-f180.google.com with SMTP id 10so5222228pdi.11
        for <linux-ext4@vger.kernel.org>; Tue, 09 Jul 2013 06:45:12 -0700 (PDT)
In-Reply-To: <20130709021403.GC6000@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

No problem, it sounds like it would be a very tricky bit of code to
write. Shuffling metadata blocks is not an easy feat.

Is there any way to tell if I'm using 64 bit? Ubuntu defaults to
setting ext4 to default, but I don't know if it did when I first
created this FS.

If it is 64 bit, the resize2fs utility should be able to handle this
one kernels >3.7, correct?

On Mon, Jul 8, 2013 at 9:14 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Mon, Jul 08, 2013 at 04:32:50PM -0500, Michael wrote:
>> I have a currently 15TB FS that I want to expand to 18TB.
>> Unfortunately EXT4 e2fsprogs has an issue that stops you from being
>> able to do this:
>>
>> sudo resize2fs /dev/md0
>> resize2fs 1.42.5 (29-Jul-2012)
>> resize2fs: New size too large to be expressed in 32 bits
>>
>> It seems to me, reading the change logs, that this only supported if
>> you created your FS with 64 bit specified. There seems to have been a
>> patch last year that added support for changing 32->64bit, but I had a
>> hard time finding/tracking that.
>
> Unfortuantely, there is no patch that would enable this.
>
> In theory it could be done; it would require doubling the size of the
> block group descriptors, which would require moving other metadata
> blocks out of the way.  Resize2fs does do this when growing a file
> system off-line when no blocks are available from the resize inode,
> but no one has implemented the necessary changes to extend this to
> adding the 64-bit feature.
>
> So it's technically possible, but it's not implemented at this time.
>
> Sorry,
>
>                                                         - Ted
