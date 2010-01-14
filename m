From: Mike Mestnik <cheako911@gmail.com>
Subject: Re: How to use mkfs.ext4 "stride=" on RAID correctly?
Date: Wed, 13 Jan 2010 18:58:46 -0600
Message-ID: <fa7b26051001131658ya96c3b0ieb6010c6fba389c4@mail.gmail.com>
References: <fa7b26051001131612h482845dalf3446e5fce5f3639@mail.gmail.com>
	 <fa7b26051001131613jc61e20fu5e4d0ccee86d6b16@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f209.google.com ([209.85.219.209]:58557 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043Ab0ANA6r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Jan 2010 19:58:47 -0500
Received: by ewy1 with SMTP id 1so316252ewy.28
        for <linux-ext4@vger.kernel.org>; Wed, 13 Jan 2010 16:58:46 -0800 (PST)
In-Reply-To: <fa7b26051001131613jc61e20fu5e4d0ccee86d6b16@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 13, 2010 at 6:13 PM, Mike Mestnik <cheako@visi.com> wrote:
> What should this value be? =A0From what I gather it should be the len=
gth
> of data stored on a single disk for each RAID level block. =A0If that=
's
> the case how is it that two given data blocks are calculated to be on
> separate drives? =A0It seams to me that the stripe-width is also
> essential in this regard, but the man page does not reflect this.
>
> For example let's say that stride=3D1, then which of the following
> blocks are not on the same drive as 1: 8 9 10?
> The answer is dependent on the number data disks, like so.
> Where x =3D n - 1 or n depending on the RAID type.
> if x =3D 2 then 9
> if x =3D 3 then 8 and 10
> if x =3D 5 then 8 and 9
>
Wait!!
I got this all wrong, one would need all of x, n, and stride to
successfully determine the disk used for a given stride.

Seams to me mkfs is missing some parameters.  What about [-g
blocks-per-group]...

http://tldp.org/HOWTO/Software-RAID-0.4x-HOWTO-8.html

> There is no way to make this calculation with out knowing x, further
> more calculating x based of of both stride and stripe-width is round
> about... =A0Why not simply ask for x, the number of data disks and ha=
ve
> stripe-width be the value that is calculated, as stride might not go
> into stripe-width evenly leaving you with a headache.
>
> Did I locate a bug?
>
> Is there a better forum for this discussion?
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
