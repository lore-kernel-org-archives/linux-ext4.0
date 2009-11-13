From: Florian Weimer <fw@deneb.enyo.de>
Subject: Re: Ext4 on SSD Intel X25-M
Date: Fri, 13 Nov 2009 23:03:29 +0100
Message-ID: <878wea84lq.fsf@mid.deneb.enyo.de>
References: <4AFC14D6.7080700@diamondcut.com.br>
	<20091112153017.GA32122@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Renato S. Yamane" <yamane@diamondcut.com.br>,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.enyo.de ([212.9.189.167]:45314 "EHLO mail.enyo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756448AbZKMWXe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Nov 2009 17:23:34 -0500
In-Reply-To: <20091112153017.GA32122@mit.edu> (Theodore Tso's message of "Thu,
	12 Nov 2009 10:30:17 -0500")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Theodore Tso:

> That being said, though, it shouldn't be necessary to avoid using a
> journal on the Intel SSD.  Intel says that laptop will last at least 5
> years with 10GB worth of writes per day, and that's a huge amount.  I
> have an X25-M SSD in my laptop, using an ext4 file system and with the
> journal enabled, and since the file system was created 266 days ago,
> when I put my X25-M into service, the drive has seen 570GB worth of
> writes, so I'm averaging 2.14 GB writes per day.

That really depends on the software you use.  Just fetching mail on my
machine causes about 500 MB of data written to disk.  That's because
I'm using Gnus with nnml and slightly large mail folders and Gnus
rewrites those index files from scratch each time new mail for a
folder arrives.  I should really consider this a bug and fix it, but I
haven't yet found a good solution.
