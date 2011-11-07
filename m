From: Matt Parnell <mparnell@gmail.com>
Subject: Re: Bug In ext4 in kernels > 2.6.39 - Not mounting with arguments/options
 I specify in fstab on root remount
Date: Sun, 06 Nov 2011 21:32:21 -0800
Message-ID: <4EB76D65.7070509@gmail.com>
References: <4E6F1B49.3010803@gmail.com> <CABeR262=5V1wuXPDVr_qLTeFTc4zDSFKVYKvO_+1w60XmwJvKA@mail.gmail.com> <4E6F6D89.5040905@redhat.com> <CABeR260PEDEF1cyX5JPs3VC0hpThmKNtDAhDd-sPDZ2grtL+=g@mail.gmail.com> <20111009234433.GU7948@thunk.org> <4EA0E72D.8020305@gmail.com> <20111022050031.GC4196@thunk.org> <4EA27607.20407@gmail.com> <20111022093218.GF4196@thunk.org> <4EB7416A.7080006@gmail.com> <4EB76C21.5060104@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42735 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417Ab1KGDdO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 6 Nov 2011 22:33:14 -0500
Received: by iage36 with SMTP id e36so5362645iag.19
        for <linux-ext4@vger.kernel.org>; Sun, 06 Nov 2011 19:33:13 -0800 (PST)
In-Reply-To: <4EB76C21.5060104@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/06/2011 09:26 PM, Matt Parnell wrote:
> On 11/06/2011 06:24 PM, Matt Parnell wrote:
>> On 10/22/2011 02:32 AM, Ted Ts'o wrote:
>>> On Sat, Oct 22, 2011 at 02:51:35AM -0500, Matt Parnell wrote:
>>>> That doesn't really help me at all, it's not
>>>> rootflags=data=writeback causing this, it's starting to make me
>>>> think that arch's init may be to blame, although I previously ruled
>>>> it out...
>>> Well, it looks like rootflags=data=writeback is not making it to the
>>> file system.  That's why it's not showing up in /proc/mounts, from you
>>> showed us.  Can you look at the kernel dmesg?
>>>
>>> You should see something like this:
>>>
>>> [    1.421146] EXT3-fs (vda): error: couldn't mount because of 
>>> unsupported optional features (240)
>>> [    1.434057] EXT4-fs (vda): couldn't mount as ext2 due to feature 
>>> incompatibilities
>>> [    1.454631] EXT4-fs (vda): mounted filesystem with writeback data 
>>> mode. Opts: data=writeback
>>> [    1.455966] VFS: Mounted root (ext4 filesystem) readonly on 
>>> device 254:0.
>>>
>>>
>>> The first line is the failure to mount the root file system as ext3.
>>> The 2nd is the failure to mount the file system as ext2, using the
>>> ext4 file system driver.  The last two lines show the options show the
>>> mount as ext4.
>>>
>>> What do those two lines look to you.  If you don't see "Opts:
>>> data=writeback", then somehow the rootflags option isn't getting passed
>>> down to the file system.  Then when you try to remount the file system
>>> read/write, the fact that you have "data=writeback" in your /etc/fstab
>>> causes the failure to remount.
>>>
>>> If you simply remove that from /etc/fstab, things should work better.
>>> The remount will preserve whatever data=journalling mode was in use
>>> when the root file system was originallymounted as.  If rootflags is
>>> non-functional, then the file system won't be mounted as
>>> data=writeback, but at least the boot sequence will continue without
>>> blowing out.
>>>
>>>                             - Ted
>> Looks like the kernel isn't creating the /dev/root link/block device, 
>> either all of the time or some of the time, I'm confused.
> I figured it out. data=writeback isn't needed and is done by default 
> if there's no journal, as per commit 
> 373cd5c53d5ea6622c319ecd84e29e2737d488bd 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=373cd5c53d5ea6622c319ecd84e29e2737d488bd
>
> ...sorry about throwing you guys through loops over this, although I'm 
> guessing there's still a bug in that the kernel should just warn the 
> user about the option when it's used and otherwise ignore it instead 
> of breaking if there's no journal.
That is, you were right in removing rootflags=data=writeback from the 
kernel boot params, and removing data=writeback from fstab would fix it 
- that commit is where things break, though...

So really instead of breaking it should log that it's ignoring that flag 
becuase it's enabled by default when there's no journal.
