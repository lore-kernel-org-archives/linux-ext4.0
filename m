From: Bastien Traverse <bastien.traverse@gmail.com>
Subject: Re: mke2fs options for large media archive filesystem
Date: Wed, 05 Feb 2014 17:45:34 +0100
Message-ID: <52F26AAE.9010608@gmail.com>
References: <52EE703B.3010703@gmail.com> <op.xanxpcwg0ncgu9@vitalif.vhome> <F3EDB2EF-E089-486A-B1FC-6395770B111E@dilger.ca> <op.xao2fube0ncgu9@vitalif.vhome> <7A86A0B9-5C08-42C9-A136-010CAAE384A1@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>,
	Vitaliy Filippov <vitalif@yourcmc.ru>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:43102 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799AbaBEQpi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Feb 2014 11:45:38 -0500
Received: by mail-wi0-f176.google.com with SMTP id hi5so770443wib.9
        for <linux-ext4@vger.kernel.org>; Wed, 05 Feb 2014 08:45:37 -0800 (PST)
In-Reply-To: <7A86A0B9-5C08-42C9-A136-010CAAE384A1@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Le 02/02/2014 17:35, Vitaliy Filippov a =E9crit :
> I personally don't think you'll really benefit from bigalloc on a
> 1TB archive partition.

Le 03/02/2014 02:30, Andreas Dilger a =E9crit :
> I would say that bigalloc is probably not what you want for an
> archival system.

Thanks for the enlightenment! I'll leave bigalloc aside for this usage,
but I'll definitely keep it around for another use case that I wanted t=
o
submit to the list (in a later message).

> Since you already know the average file size, using -i {average size}
> is what you want. The -N option is just a different way of specifying
> the same thing, the underlying filesystem ends up being the same.
>
> I would also recommend to allocate about 2x the inodes you think you =
>
will need. If there are suddenly thumbnails of the photos or key      >
photos for videos then you don't want to run out of inodes.

Thanks a lot, this is much helpful. It confirms my intent to go for a 2=
M
bytes-per-inode ratio so as to reach ~460k inodes (or twice as much as
I'll probably need).

Cheers, Bastien


--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
