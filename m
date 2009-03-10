From: Alexander Beregalov <a.beregalov@gmail.com>
Subject: Re: next-20090310: ext4 hangs
Date: Tue, 10 Mar 2009 17:18:55 +0300
Message-ID: <a4423d670903100718w1a532143he767782ae598d0fb@mail.gmail.com>
References: <a4423d670903100517y42f342d4pd73c4c36f5c64dd7@mail.gmail.com>
	 <20090310124658.GE8840@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@mit.edu>,
	"linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
	linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f177.google.com ([209.85.219.177]:45842 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180AbZCJOTA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Mar 2009 10:19:00 -0400
In-Reply-To: <20090310124658.GE8840@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2009/3/10 Theodore Tso <tytso@mit.edu>:
> On Tue, Mar 10, 2009 at 03:17:51PM +0300, Alexander Beregalov wrote:
>> Hi
>>
>> It is similar to http://lkml.org/lkml/2009/2/6/304,
>> http://bugzilla.kernel.org/show_bug.cgi?id=12579
>>
>> I run dbench on ext4 on loop on ext3 on sparc.
>> The kernel is 2.6.29-rc7-next-20090310
>> e2fsprogs -1.41.4
>
> Thanks for reporting this; does it show up on stock 2.6.29-rc7?
No, I can not reproduce it.
It is a slow system, I would not like to bisect it, only if it is the
last possibility.
