From: Adam Huffman <adam.huffman@gmail.com>
Subject: Re: Filesystem corruption on Fedora 17
Date: Wed, 28 Nov 2012 18:16:40 +0000
Message-ID: <CAP5prOhXZS+x4xAEOYcTquVFz9rtTVeyhK_x2qajKGoKxfw5vA@mail.gmail.com>
References: <CAP5prOgjNXnvXr1HELuez7+Be+TW4N8t9P_AeQw8pBVYDnFHTg@mail.gmail.com>
	<20121127164745.GB7107@thunk.org>
	<CAP5prOh1VvLtCvY_iE2om2dXmgwHoD5JkkfVqu=MUtMiv9L9vg@mail.gmail.com>
	<20121127173115.GC7107@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:48578 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab2K1SQl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 28 Nov 2012 13:16:41 -0500
Received: by mail-ea0-f174.google.com with SMTP id e13so5375330eaa.19
        for <linux-ext4@vger.kernel.org>; Wed, 28 Nov 2012 10:16:40 -0800 (PST)
In-Reply-To: <20121127173115.GC7107@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 27, 2012 at 5:31 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Tue, Nov 27, 2012 at 04:59:05PM +0000, Adam Huffman wrote:
>>
>> I took a copy using dd_rescue yesterday, and that's what I've been
>> running fsck against.
>> (After that I tried mkfs.ext4 -S on the disk itself, which wasn't successful...)
>
> On the disk itself?  Instead of another copy of the disk?  That was
> unfortunate.... mke2fs -S is very destructive when it doesn't work
> out.... and what happened after you tried that, BTW?  What were the
> e2fsck failures that you were seeing?  If you're seeing the same
> repeated journal failures, you might as well go for broke and see if
> zapping the journal helps:
>
>         debugfs -w /dev/XXXX -R "clri <8>"
>
> Again, I always recommend issuing these sorts of commands on copies,
> and to never tamper with the initial image backup of the file
> system....
>
>> The images comprises an LVM PV and VG, so I've used kpartx to make it
>> available, if that makes a difference.
>>
>> There is one person claiming that it does:
>>
>> http://j-b.livejournal.com/334065.html
>
> Hmm... I don't see why that would make a difference.  At this point
> what I'd really need is an e2image dump of the file system.  Please
> read the e2image man page, especially the sections regarding a raw
> e2image dump and a qcow e2image dump.  If you are willing to send me a
> copy of your metadata blocks, please send me a qcow e2image dump and
> I'll take a look at it.
>

I'll send you that off-list.

>> Do you have any ideas about this error, with a different LV from the same disk?:
>>
>> Pass 1: Checking inodes, blocks, and sizes
>> Inode 4122234 has illegal block(s).  Clear? yes
>>
>> Illegal block #256918621 (1313286244) in inode 4122234.  CLEARED.
>> Error storing directory block information (inode=4122234, block=0,
>> num=78646612): Memory allocation failed
>
> That's the sign of a very badly corrupted inode data structure.  We
> should do a better job of handling this case automatically.
>
> Can you send me a copy of the output of:
>
> debugfs -w /dev/XXXX
> debugfs: stat <4122234>
>

Here you go:

debugfs:  stat 4122234
4122234: File not found by ext2_lookup


> Then what I'd recommend doing is to use the debugfs command "clri
> <4122234>" to zap the the corrupted inode, and then rerunning e2fsck.
> This is relatively safe thing to try as these things go, so I won't
> strongly recommend that you take an image backup of the file system
> image in question before proceeding --- but in general, it's still a
> good idea if you are paranoid.  :-)
>
> The fact that you are seeing multiple errors like this really makes me
> wonder.... what kind of storage device is this?  An external USB
> drive?  A SATA drive?  A software raid device?  Something else?
>

It was a simple internal SATA disk - no RAID.

I ran a memory tester over the weekend in case bad RAM was causing the
corruption, and in 32 passes no errors were found.

As I said in the other reply, I was able to mount the image in the
end.  Perhaps one of those fsck invocations made a difference, even
though the same error appeared each time?

Thanks,
Adam

> Thanks,
>
>                                                 - Ted
