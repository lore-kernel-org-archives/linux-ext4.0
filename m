From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: fiemap is broken for sparse file in ext4?
Date: Fri, 11 Jun 2010 12:46:44 -0400
Message-ID: <AANLkTim9xIyL842wapccPIwEPVgd3BY8_r0tBGfGgvOt@mail.gmail.com>
References: <4C119C2E.2090801@oracle.com>
	<4C11B6D8.8070909@redhat.com>
	<4C11C41C.9070000@oracle.com>
	<4C125A6C.2090805@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Tao Ma <tao.ma@oracle.com>, linux-ext4@vger.kernel.org,
	Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:32927 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756810Ab0FKQqp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 11 Jun 2010 12:46:45 -0400
In-Reply-To: <4C125A6C.2090805@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 11, 2010 at 11:46 AM, Eric Sandeen <sandeen@redhat.com> wro=
te:
> Tao Ma wrote:
>
>>> What are you using to call fiemap? =A0Here it seems to be working:
>> I just wrote a simple test program by calling ioctl. It is attached.
>> btw, you need to call it immediately after dd so that we have a chan=
ce
>> that ext4 don't have time to allocate extents. ;)
>
> OK I take it back, I do see it. =A0*cough* too many different filesys=
tems
> on this box ... ;)
>
> Yes, it does look like a bug.
>
> -Eric

I'm not clear how this is supposed to work.

Is this just a userspace bug in that FIEMAP_FLAG_SYNC is needed in the
fiemap call, or is there a kernel bug as well?

If fiemap is called with the FIEMAP_FLAG_SYNC flag is there currently a=
 problem?

Thanks
Greg
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
