From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: Atomic file data replace API
Date: Mon, 27 Dec 2010 15:20:18 +0200
Message-ID: <AANLkTikXAFV6SjWT1gdsR9jZkV+zHr-eFZ0NVFrSEQdg@mail.gmail.com>
References: <AANLkTi=qpQfwZ1vfRjKE063tVvbz0VLmroO_kkvz+N+-@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Olaf van der Spek <olafvdspek@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:53069 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753712Ab0L0NUU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Dec 2010 08:20:20 -0500
In-Reply-To: <AANLkTi=qpQfwZ1vfRjKE063tVvbz0VLmroO_kkvz+N+-@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 27, 2010 at 1:51 PM, Olaf van der Spek <olafvdspek@gmail.com> wrote:
> Hi,
>
> Since non-durable appears to be controversial, let's consider the case
> without that aspect.
>
> Since the introduction of ext4, some apps/users have had issues with
> file corruption after a system crash. It's not a bug in the FS AFAIK
> and it's not exclusive to ext4.
> Writing a temp file, fsync, rename is often proposed.
> But how does one preserve meta-data, including file owner?
>

So as I wrote you on the previous thread, in Ext4 you can probably
accomplish that
already by using the Ext4 specific EXT4_IOC_EXT_MOVE ioctl, which is
used by e4defrag
to atomically switch the fragmented copy of the data with a
de-fragmented copy of the data.

It is a more granular version of the exchangedata() BSD API mentioned
in the previous thread:
http://www.manpagez.com/man/2/exchangedata/

So the atomic update is: write(tempfd); fdatasync(tempfd);
exchangedata(tempfd, fd)

If you choose to pursue your campaign for "Atomic file data replace
API", I recommend that you:
1. change the slogan to the more catchy "Implementing exchangedata()
API" (you already have a man page for that)
2. convince VFS people to support the new generic system call /
optional FS operation exchangedata()
3. if you can, post the relevant patches, so people can review and test them

Implementation of exchangedata() operation in Ext4 should be trivial
using the ext4_move_extents() function
and I didn't check, but I bet that XFS has that functionality as well.

Good luck,
Amir.
