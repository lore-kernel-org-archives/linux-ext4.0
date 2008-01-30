From: Paul Collins <paul@burly.ondioline.org>
Subject: Re: [GIT PULL] ext4 update
Date: Wed, 30 Jan 2008 21:38:43 +1300
Message-ID: <87lk67d7xo.fsf@burly.wgtn.ondioline.org>
References: <E1JJjMo-00011j-EU@closure.thunk.org>
	<20080129125307.GF6774@mit.edu>
	<Pine.LNX.4.64.0801292250110.14907@fbirervta.pbzchgretzou.qr>
	<20080130071123.GF21944@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from jenny.ondioline.org ([66.220.1.122]:46472 "EHLO
	jenny.ondioline.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754478AbYA3Iul (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Jan 2008 03:50:41 -0500
In-Reply-To: <20080130071123.GF21944@mit.edu> (Theodore Tso's message of "Wed,
	30 Jan 2008 02:11:23 -0500")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso <tytso@MIT.EDU> writes:

> On Tue, Jan 29, 2008 at 10:54:03PM +0100, Jan Engelhardt wrote:
>> 
>> I am seeing normal behavior:
>>
>> 22:52 sovereign:~/linux > git diff HEAD | diffstat
>
> That's because you are doing a diff stat of changes that haven't been
> checked in yet.  I was doing a "git log -p origin.. | diffstat -p1",
> and in that incantation you definitely do need the -p1 to diffstat.

How about git diff --stat origin.. ?

-- 
Paul Collins
Wellington, New Zealand

Dag vijandelijk luchtschip de huismeester is dood
