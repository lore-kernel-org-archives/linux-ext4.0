From: Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [PATCH 10/10] Fs: ext4: namei: fixed file of checkpatch/pl warnings and errors
Date: Sun, 26 Sep 2010 08:36:34 +0200
Message-ID: <m3pqw16mfh.fsf@intrepid.localdomain>
References: <1285439521-2557-1-git-send-email-tdent48227@gmail.com>
	<1285439521-2557-10-git-send-email-tdent48227@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Tracey Dent <tdent48227@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:37010 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061Ab0IZGgq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 26 Sep 2010 02:36:46 -0400
In-Reply-To: <1285439521-2557-10-git-send-email-tdent48227@gmail.com> (Tracey
	Dent's message of "Sat, 25 Sep 2010 14:32:01 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Tracey Dent <tdent48227@gmail.com> writes:

> +		printk("%s%3u:%03u hash %8x/%8x ", levels ? "":"   ", i, block, hash, range);
> +		if (!(bh = ext4_bread(NULL,dir, block, 0,&err))) continue;

Put a SPACE after the comma. "continue" should usually be on the next
line. It doesn't make sense to fix the formatting only partially.


BTW I wouldn't trust checkpatch so blindly. Also keep in mind checkpatch
is only a tool and that maintainers have full authority to ignore the
problems (or "problems") it spews.
And I would merge all the changes (which make sense) and send them in
one patch - that should increase the odds of it actually being applied.
To be honest, fixing the style isn't an easy job.
-- 
Krzysztof Halasa
