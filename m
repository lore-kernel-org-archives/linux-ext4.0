From: Jacek Luczak <difrost.kernel@gmail.com>
Subject: Re: getdents - ext4 vs btrfs performance
Date: Thu, 15 Mar 2012 08:59:38 +0100
Message-ID: <CADDYkjRv=ASgzJV25beyN3t=7=djRcRAxy0tEqcZ9NX300boBg@mail.gmail.com>
References: <CADDYkjS5VJeYyHzqumazQ0qKg+HwA6GO+zYSJj7rkHNZFwjcoQ@mail.gmail.com>
	<20120310035202.GA5652@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "Ted Ts'o" <tytso@mit.edu>,
	Jacek Luczak <difrost.kernel@gmail.com>,
	linux-ext4@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34209 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755124Ab2COH7j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Mar 2012 03:59:39 -0400
In-Reply-To: <20120310035202.GA5652@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2012/3/10 Ted Ts'o <tytso@mit.edu>:
> Hey Jacek,
>
> I'm curious parameters of the set of directories on your production
> server. =A0On an ext4 file system, assuming you've copied the
> directories over, what are the result of this command pipeline when
> you are cd'ed into the top of the directory hierarchy of interest
> (your svn tree, as I recall)?
>
> find . -type d -ls | awk '{print $7}' | sort -n | uniq -c
>
> I'm just curious what the distribution of directories sizes are in
> practice for your use case...
>

Hi Ted,

below is from the latest upstream on ext4:

 843341 4096
    165 12288
     29 16384
    164 20480
     26 24576
     22 28672
     24 32768
    118 36864
     12 40960
     19 45056
      3 49152
     12 53248
     37 57344
     10 61440
      2 65536
     13 69632
      1 131072
      1 139264
      1 143360
      1 221184
      1 249856
      1 258048
      1 262144
      1 319488
      2 335872
      1 339968

-Jacek
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
