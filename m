From: Stefan Priebe <s.priebe@profihost.ag>
Subject: Re: ext4 hung tasks in linux-stable 3.0.41
Date: Sat, 01 Sep 2012 10:41:29 +0200
Message-ID: <5041CA39.7080401@profihost.ag>
References: <50406B29.1090403@profihost.ag> <20120831092859.GB19786@quack.suse.cz> <20120831175903.GB6342@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, stable@vger.kernel.org,
	Greg KH <gregkh@linuxfoundation.org>, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.profihost.ag ([85.158.179.208]:47264 "EHLO
	mail.profihost.ag" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258Ab2IAIl3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 1 Sep 2012 04:41:29 -0400
In-Reply-To: <20120831175903.GB6342@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Am 31.08.2012 19:59, schrieb Theodore Ts'o:
> On Fri, Aug 31, 2012 at 11:28:59AM +0200, Jan Kara wrote:
>>>
>>> Is this problem known? Or is there a fix for 3.0.X available?
>>    From a quick look, processes are waiting for IO so it may be that your
>> disk is just loaded... Did it start happening after some change? Or do you
>> experience unexpectedly low performance?
>
> All of the processes waiting for I/O are waiting for a directory
> block.  This makes me suspicious that perhaps an interrupt or I/O
> request got lost.
>
> Is this a repeatable failure, and is the stack traces always the same?
>
> If so, you might want to try running badblocks on the device and make
> sure that hardware issues have been ruled out.

But but SMART is OK and i see no I/O errors from AHCI. But i'll try to 
replace the disk and see if this fixes it.

Stefan
