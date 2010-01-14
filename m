From: Mike Mestnik <cheako@visi.com>
Subject: How to use mkfs.ext4 "stride=" on RAID correctly?
Date: Wed, 13 Jan 2010 18:13:12 -0600
Message-ID: <fa7b26051001131613jc61e20fu5e4d0ccee86d6b16@mail.gmail.com>
References: <fa7b26051001131612h482845dalf3446e5fce5f3639@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:11212 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755186Ab0ANANN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Jan 2010 19:13:13 -0500
Received: by ey-out-2122.google.com with SMTP id 22so25119eye.19
        for <linux-ext4@vger.kernel.org>; Wed, 13 Jan 2010 16:13:12 -0800 (PST)
In-Reply-To: <fa7b26051001131612h482845dalf3446e5fce5f3639@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

What should this value be? =A0From what I gather it should be the lengt=
h
of data stored on a single disk for each RAID level block. =A0If that's
the case how is it that two given data blocks are calculated to be on
separate drives? =A0It seams to me that the stripe-width is also
essential in this regard, but the man page does not reflect this.

=46or example let's say that stride=3D1, then which of the following
blocks are not on the same drive as 1: 8 9 10?
The answer is dependent on the number data disks, like so.
Where x =3D n - 1 or n depending on the RAID type.
if x =3D 2 then 9
if x =3D 3 then 8 and 10
if x =3D 5 then 8 and 9

There is no way to make this calculation with out knowing x, further
more calculating x based of of both stride and stripe-width is round
about... =A0Why not simply ask for x, the number of data disks and have
stripe-width be the value that is calculated, as stride might not go
into stripe-width evenly leaving you with a headache.

Did I locate a bug?

Is there a better forum for this discussion?
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
