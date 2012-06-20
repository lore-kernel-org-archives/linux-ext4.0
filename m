From: Norbert Preining <preining@logic.at>
Subject: Re: Ext4 slow on links
Date: Wed, 20 Jun 2012 13:01:52 +0900
Message-ID: <20120620040152.GB2395@gamma.logic.tuwien.ac.at>
References: <20120620002014.GA25471@gamma.logic.tuwien.ac.at> <4FE14034.6070800@redhat.com> <20120620002014.GA25471@gamma.logic.tuwien.ac.at> <20120620021912.GA26323@thunk.org> <20120620033831.GA2395@gamma.logic.tuwien.ac.at> <BA050E9A-2385-4FF9-B41A-3A25F3FF066A@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Ts'o <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Eric Sandeen <esandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:56001 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab2FTEBz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Jun 2012 00:01:55 -0400
Content-Disposition: inline
In-Reply-To: <BA050E9A-2385-4FF9-B41A-3A25F3FF066A@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Eric,

On Di, 19 Jun 2012, Eric Sandeen wrote:
> You might see if the dir itself is badly fragmented

I don't think so, since I did:
	for i in /usr/local/font-collection/......./* ; do ln -s $i . ; done

	reboot

	time ls -l >/dev/null

newly created entries shouldn't b fragmented, I guess.

> (if not filefrag, stat in debugfs would show you block mapping) and 
> maybe a blktrace of the actions would show you something interesting as well.

I will investigate, but it is the first time I look into that so
if you have a link to quick howto, great, otherwise I read through
man pages ;-)

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
`You'd better be prepared for the jump into hyperspace.
It's unpleasently like being drunk.'
`What's so unpleasent about being drunk?'
`You ask a glass of water.'
                 --- Arthur getting ready for his first jump into hyperspace.
                 --- Douglas Adams, The Hitchhikers Guide to the Galaxy
