From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: Re: [RFC][PATCH 0/3] ext4: inode preferred block allocation
Date: Fri, 16 Apr 2010 17:23:51 +0900
Message-ID: <4BC81E97.9030701@sx.jp.nec.com>
References: <4BC57A1D.9080105@sx.jp.nec.com> <87pr2092e2.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: ext4 <linux-ext4@vger.kernel.org>, Theodore Tso <tytso@mit.edu>,
	linux-fsdevel@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:51000 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755247Ab0DPI0e (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 16 Apr 2010 04:26:34 -0400
In-Reply-To: <87pr2092e2.fsf@basil.nowhere.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Andi,

2010/04/16 0:11, Andi Kleen wrote:
> Kazuya Mio<k-mio@sx.jp.nec.com>  writes:
> 
> 
>> We implemented new two ioctls to allocate preferred blocks using inode PA.
>> The old implementation idea is the following (b).
>> http://marc.info/?l=linux-ext4&m=124962738211206&w=4
> 
> I had to read until patch 3/3 to find out what a "PA" actually is.
> It might make the patch descriptions more clearer if it was spelled
> out at least once in each.

Thank you for informing me.
I will take care not to abbreviate the first "preallocation" to "PA".

Best regards,
Kazuya Mio
