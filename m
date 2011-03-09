From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 4/4] e2fsck: Add QCOW2 support
Date: Wed, 9 Mar 2011 19:52:51 +0200
Message-ID: <AANLkTi=7w_cWdgxnGTCfARqOESO3eBX66e37d5O8yYYO@mail.gmail.com>
References: <1298638173-25050-1-git-send-email-lczerner@redhat.com>
	<1298638173-25050-4-git-send-email-lczerner@redhat.com>
	<20110226164442.GD2924@thunk.org>
	<alpine.LFD.2.00.1103011103200.3874@dhcp-27-109.brq.redhat.com>
	<AANLkTikOzaC=rSReQx18xSBHAtY5rrQ0Ap22+pWgYsTy@mail.gmail.com>
	<alpine.LFD.2.00.1103071331250.5084@dhcp-27-109.brq.redhat.com>
	<alpine.LFD.2.00.1103091721120.5562@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Ted Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	sandeen@redhat.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:52952 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932827Ab1CIRww (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Mar 2011 12:52:52 -0500
Received: by qyk7 with SMTP id 7so4062127qyk.19
        for <linux-ext4@vger.kernel.org>; Wed, 09 Mar 2011 09:52:51 -0800 (PST)
In-Reply-To: <alpine.LFD.2.00.1103091721120.5562@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 9, 2011 at 6:30 PM, Lukas Czerner <lczerner@redhat.com> wrote:
>
> --snip--
>> >
>> > Did you consider the possibility to use QCOW2 format for doing a "tryout"
>> > fsck on the filesystem with the option to rollback?
>> >
>> > If QCOW2 image is created with the 'backing_file' option set to the origin
>> > block device (and 'backing_fmt' is set to 'host_device'), then qemu-nbd
>> > will be able to see the exported image metadata as well as the filesystem
>> > data.
>> >
>> > You can then do an "intrusive" fsck run on the NBD, mount your filesystem
>> > (from the NBD) and view the results.
>> >
>> > If you are satisfied with the results, you can apply the fsck changes to the
>> > origin block device (there is probably a qemu-img command to do that).
>> > If you are unsatisfied with the results, you can simply discard the image
>> > or better yet, revert to a QCOW2 snapshot, which you created just before
>> > running fsck.
>>
>> But this is something you can do even now. You can mount the qcow2
>> metadata image without any problems, you just will not see any data. But
>> I can take a look at this functionality, it seems simple enough.
>
> So I have done this and it works as expected as long as the device
> you've created the image from is present in the system, which might not
> be true, especially in the case you are transferring the image to the
> another machine (bug report).
>
> If the device with the same name as the original does not exist in the
> system qemu-nbd is not smart enough to just ignore that fact and mount
> the image anyway. And looking at the man page there is no way to do it.
>
> So, the result is I am not going to include this into my patches (if
> someone does not change my mind:)) as I do not want to create just-another
> switch for e2image. Also I fail to see the benefit if it anyway:).
>

The benefit is, as I see it, is with the following capability:
A user with a corrupted fs, sends an e2image to an expert,
having him examine the file system (so far we already have).
Then the expert can fix the fs image (say using hard core debugfs'ing) and
send it back to the user.
The user can then "test mount" the fixed fs and if his valuable data is back,
send the other half of the payment to the expert, apply the fix to the origin
device and go on with his life.

It's a shame that qemu-nbd doesn't play along with that plan, but you can't
blame it, can you...

Anyway, thanks for testing my idea and thanks for QCOW2 e2image :-)
This is just one example of the nice things that the new e2image format
can be leveraged to.

Amir.
