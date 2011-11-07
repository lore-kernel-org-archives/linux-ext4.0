From: Matt Parnell <mparnell@gmail.com>
Subject: Re: Bug In ext4 in kernels > 2.6.39 - Not mounting with arguments/options
 I specify in fstab on root remount
Date: Sun, 06 Nov 2011 18:18:35 -0800
Message-ID: <4EB73FFB.9050506@gmail.com>
References: <4E6F1B49.3010803@gmail.com> <CABeR262=5V1wuXPDVr_qLTeFTc4zDSFKVYKvO_+1w60XmwJvKA@mail.gmail.com> <4E6F6D89.5040905@redhat.com> <CABeR260PEDEF1cyX5JPs3VC0hpThmKNtDAhDd-sPDZ2grtL+=g@mail.gmail.com> <20111009234433.GU7948@thunk.org> <4EA0E72D.8020305@gmail.com> <20111022050031.GC4196@thunk.org> <4EA27607.20407@gmail.com> <20111022093218.GF4196@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58277 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244Ab1KGCSk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 6 Nov 2011 21:18:40 -0500
Received: by iage36 with SMTP id e36so5304395iag.19
        for <linux-ext4@vger.kernel.org>; Sun, 06 Nov 2011 18:18:39 -0800 (PST)
In-Reply-To: <20111022093218.GF4196@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/22/2011 02:32 AM, Ted Ts'o wrote:
> On Sat, Oct 22, 2011 at 02:51:35AM -0500, Matt Parnell wrote:
>> That doesn't really help me at all, it's not
>> rootflags=data=writeback causing this, it's starting to make me
>> think that arch's init may be to blame, although I previously ruled
>> it out...
> Well, it looks like rootflags=data=writeback is not making it to the
> file system.  That's why it's not showing up in /proc/mounts, from you
> showed us.  Can you look at the kernel dmesg?
>
> You should see something like this:
>
> [    1.421146] EXT3-fs (vda): error: couldn't mount because of unsupported optional features (240)
> [    1.434057] EXT4-fs (vda): couldn't mount as ext2 due to feature incompatibilities
> [    1.454631] EXT4-fs (vda): mounted filesystem with writeback data mode. Opts: data=writeback
> [    1.455966] VFS: Mounted root (ext4 filesystem) readonly on device 254:0.
>
>
> The first line is the failure to mount the root file system as ext3.
> The 2nd is the failure to mount the file system as ext2, using the
> ext4 file system driver.  The last two lines show the options show the
> mount as ext4.
>
> What do those two lines look to you.  If you don't see "Opts:
> data=writeback", then somehow the rootflags option isn't getting passed
> down to the file system.  Then when you try to remount the file system
> read/write, the fact that you have "data=writeback" in your /etc/fstab
> causes the failure to remount.
>
> If you simply remove that from /etc/fstab, things should work better.
> The remount will preserve whatever data=journalling mode was in use
> when the root file system was originallymounted as.  If rootflags is
> non-functional, then the file system won't be mounted as
> data=writeback, but at least the boot sequence will continue without
> blowing out.
>
> 							- Ted

Since then, I created a fresh partition and re rsynced my root over onto 
it after making it WITHOUT a journal using the current sysrescue64 cd 
(kernel 3.0.1).

Same thing is happening, and the drive still refuses to mount any other 
way except

  /dev/root / ext4 rw,relatime,user_xattr,acl,barrier=1 0 0

Despite my specifying these in fstab and grub.cfg ...it's like it's not 
even passing the options somewhere, either from grub2 to the kernel or 
from my initscripts...but since I've tried using openrc too and get this 
result, I'm not sure what to do. Note that using both /dev/sdb1 and 
/dev/root don't interchange between the fstab and the kernel...I think 
the /dev/root symlink may be breaking my initscripts.

/dev/sdb1 / ext4 
noatime,nodiratime,data=writeback,nouser_xattr,barrier=0,commit=10 0 0
