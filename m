From: Jacek Luczak <difrost.kernel@gmail.com>
Subject: Re: getdents - ext4 vs btrfs performance
Date: Fri, 2 Mar 2012 15:16:12 +0100
Message-ID: <CADDYkjT8apYQpdZqr1gZKiHbm9xfTaLr=8GEJF0VKF9neHwgOg@mail.gmail.com>
References: <CADDYkjS5VJeYyHzqumazQ0qKg+HwA6GO+zYSJj7rkHNZFwjcoQ@mail.gmail.com>
	<E15A491F-62E2-4518-939F-07B3AB4C3E65@mit.edu>
	<20120301143859.GX5054@shiny>
	<CADDYkjQ8jgWUo7=eAeMjve0iRmVZMcrjjbqnvPq0SchE5W9Fqg@mail.gmail.com>
	<20120302140038.GD5054@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Chris Mason <chris.mason@oracle.com>,
	Jacek Luczak <difrost.kernel@gmail.com>,
	Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55771 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796Ab2CBOQO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 2 Mar 2012 09:16:14 -0500
In-Reply-To: <20120302140038.GD5054@shiny>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2012/3/2 Chris Mason <chris.mason@oracle.com>:
> On Fri, Mar 02, 2012 at 11:05:56AM +0100, Jacek Luczak wrote:
>>
>> I've took both on tests. The subject is acp and spd_readdir used wit=
h
>> tar, all on ext4:
>> 1) acp: http://91.234.146.107/~difrost/seekwatcher/acp_ext4.png
>> 2) spd_readdir: http://91.234.146.107/~difrost/seekwatcher/tar_ext4_=
readir.png
>> 3) both: http://91.234.146.107/~difrost/seekwatcher/acp_vs_spd_ext4.=
png
>>
>> The acp looks much better than spd_readdir but directory copy with
>> spd_readdir decreased to 52m 39sec (30 min less).
>
> Do you have stats on how big these files are, and how fragmented they
> are? =A0For acp and spd to give us this, I think something has gone w=
rong
> at writeback time (creating individual fragmented files).

How big? Which files?

-Jacek
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
