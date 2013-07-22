From: Michael <mike@draftx.net>
Subject: Re: EXT4 Larger Than 16TB
Date: Sun, 21 Jul 2013 19:44:12 -0500
Message-ID: <CAGJTRchJ4Mq5in0nXeeF8mA2A=yub7kv4OohUb_QpKtEKCWM-A@mail.gmail.com>
References: <CAGJTRcg0SHP3-9V-0nDttZ+atn5Kbhf9RRnn_VOaNOq8MgDe6Q@mail.gmail.com>
	<20130709021403.GC6000@thunk.org>
	<CAGJTRchb5KpYLEOKB1bzNSmJ4SQQ9YVf9UZEsd+Hu38D5mW05g@mail.gmail.com>
	<51EC64E8.8090509@zytor.com>
	<20130721234325.GA15659@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: "H. Peter Anvin" <hpa@zytor.com>, Michael <mike@draftx.net>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f43.google.com ([209.85.160.43]:44889 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660Ab3GVAoN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 21 Jul 2013 20:44:13 -0400
Received: by mail-pb0-f43.google.com with SMTP id md12so6385901pbc.30
        for <linux-ext4@vger.kernel.org>; Sun, 21 Jul 2013 17:44:12 -0700 (PDT)
In-Reply-To: <20130721234325.GA15659@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Also, in /etc/mke2fs.conf(Ubuntu has this by default):
        ext4 = {
                features =
has_journal,extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize
                auto_64-bit_support = 1
                inode_size = 256
        }

        ext4dev = {
                features =
has_journal,extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize
                inode_size = 256
                options = test_fs=1
        }



Also, any info on how to find out if my fs is 64 bit or not? I don't
know what this config was back when I made the system.

On Sun, Jul 21, 2013 at 6:43 PM, Zheng Liu <gnehzuil.liu@gmail.com> wrote:
> On Sun, Jul 21, 2013 at 03:47:04PM -0700, H. Peter Anvin wrote:
>> On 07/09/2013 06:45 AM, Michael wrote:
>> > No problem, it sounds like it would be a very tricky bit of code to
>> > write. Shuffling metadata blocks is not an easy feat.
>> >
>> > Is there any way to tell if I'm using 64 bit? Ubuntu defaults to
>> > setting ext4 to default, but I don't know if it did when I first
>> > created this FS.
>> >
>> > If it is 64 bit, the resize2fs utility should be able to handle this
>> > one kernels >3.7, correct?
>> >
>>
>> Is there a way to force this at mkfs time?  I.e. "I know I may want to
>> expand this filesystem beyond the 16 TB point?"
>
> Hi Peter,
>
> You could use 'mkfs.ext4 -O 64bit' to force enable 64bit support.  In
> addition, we will enable this feature by default.  Lukas has a patch to
> fix it.  Here is the link [1].
>
> 1. http://patchwork.ozlabs.org/patch/253234/
>
> Regards,
>                                                 - Zheng
