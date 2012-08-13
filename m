From: Zach Brown <zab@redhat.com>
Subject: Re: [PATCH v2] ext4: dynamical adjust the length of zero-out chunk
Date: Mon, 13 Aug 2012 12:49:02 -0700
Message-ID: <20120813194902.GG9117@lenny.home.zabbo.net>
References: <1342075703-4537-1-git-send-email-wenqing.lz@taobao.com>
 <4FFEE402.7090601@redhat.com>
 <7B794B69-EF6C-4279-83D7-EA47E35CD54C@dilger.ca>
 <20120813032243.GB13072@thunk.org>
 <20120813173224.GF9117@lenny.home.zabbo.net>
 <20120813184053.GE32484@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
	Zheng Liu <wenqing.lz@taobao.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Zheng Liu <gnehzuil.liu@gmail.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60048 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167Ab2HMTtM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Aug 2012 15:49:12 -0400
Content-Disposition: inline
In-Reply-To: <20120813184053.GE32484@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> The previously rule of thumb which I had used was that after doing a
> random seek, the time needed to write 4k and 32k was pretty much in
> the noise.  But that was a number from several years ago.  I suppose I
> should do some quick experiments to see what is a good number these
> days....

Indeed.  fio to the rescue.

I remember Christoph saying something about 64k somewhat recently?  But,
helpfully, I can't recall the details :).

- z
