From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: Re: ext4 hung tasks in linux-stable 3.0.41
Date: Fri, 31 Aug 2012 11:51:48 +0200
Message-ID: <50408934.9070305@profihost.ag>
References: <50406B29.1090403@profihost.ag> <20120831092859.GB19786@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: stable@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>,
	Theodore Tso <tytso@MIT.EDU>, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.profihost.ag ([85.158.179.208]:50146 "EHLO
	mail.profihost.ag" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005Ab2HaJvu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 31 Aug 2012 05:51:50 -0400
In-Reply-To: <20120831092859.GB19786@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Am 31.08.2012 11:28, schrieb Jan Kara:
>    Hello,
>
> On Fri 31-08-12 09:43:37, Stefan Priebe - Profihost AG wrote:
>> i'm expected every night a hang of my rsync backup process, doing a
>> backup to an ext4 filesystem. Always throwing Call traces.
>>
>> The hung task messages are really long so i posted it to pastebin:
>> http://pastebin.com/raw.php?i=9v7HEvjA
>>
>> Used kernel: vanilla 3.0.41
>>
>> Is this problem known? Or is there a fix for 3.0.X available?
>    From a quick look, processes are waiting for IO so it may be that your
> disk is just loaded... Did it start happening after some change? Or do you
> experience unexpectedly low performance?

The main disk is XFS. The backup disk is ext4. The backup disk is doing 
nothing else than this SINGLE rsync task / process. So the only I/O is 
rsync itself.

So i don't expect low performance as the main disk is XFS ;-)

Greets,
Stefan
