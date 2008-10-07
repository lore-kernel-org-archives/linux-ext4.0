From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: No-journal option for ext4
Date: Tue, 07 Oct 2008 10:28:53 -0500
Message-ID: <48EB8035.7030004@redhat.com>
References: <929ffc5e0810061839l6d5977b4o96ea1699c8451446@mail.gmail.com>	 <20081007054530.GI9337@mit.edu> <929ffc5e0810070759p39310eb4m53e239e83e951079@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Michael Rubin <mrubin@google.com>,
	Frank Mayhar <fmayhar@google.com>
To: Peter Kukol <pkukol@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:59711 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753056AbYJGP3a (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Oct 2008 11:29:30 -0400
In-Reply-To: <929ffc5e0810070759p39310eb4m53e239e83e951079@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Peter Kukol wrote:
> Thanks for the great suggestions - they all make perfect sense. I did
> see the "journal present" flag, BTW, but figured that it might be
> safer not to change existing behavior - e.g. when someone accidentally
> says ext4 instead of ext2 when mounting an ext2 volume, right now they
> get an error. If folks are OK with this changing to a successful
> mount, I'm happy - less code/work is good ;-).

As long as we've purged all kernelspace flag updates it's probably ok to
"accidentally" mount ext2 (or ext3) as ext4 - as long as it's really
easy to go back.  It'd be worth one more look though in the long run.

Early on I had some nasty surprises with ext4 "assimilating" my ext3
RHEL5 root disk :)

-Eric

> I'll rework my patch and send out an update when it's ready.
> 
> Thanks again!
> 
> PeterK
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

