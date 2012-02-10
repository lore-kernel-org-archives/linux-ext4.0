From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: Restoring filenames from partly damaged ext4-filesystem
Date: Fri, 10 Feb 2012 23:20:09 +0100
Message-ID: <4F359819.6040701@fastmail.fm>
References: <1328804993.34330.YahooMailNeo@web132403.mail.ird.yahoo.com> <ADF9EEFE-188A-4E88-BA8E-45D2607B1F3B@dilger.ca> <1328822543.65833.YahooMailNeo@web132404.mail.ird.yahoo.com> <4F351E7A.2070005@fastmail.fm> <1328893673.79058.YahooMailNeo@web132401.mail.ird.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"debian-user@lists.debian.org" <debian-user@lists.debian.org>
To: Rudolf Zran <rudolfzran@yahoo.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:33620 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753226Ab2BJWUK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 10 Feb 2012 17:20:10 -0500
Received: from compute4.internal (compute4.nyi.mail.srv.osa [10.202.2.44])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id 7DAA4210FB
	for <linux-ext4@vger.kernel.org>; Fri, 10 Feb 2012 17:20:10 -0500 (EST)
In-Reply-To: <1328893673.79058.YahooMailNeo@web132401.mail.ird.yahoo.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 02/10/2012 06:07 PM, Rudolf Zran wrote:
> Hello Bernd!
>
>
>> I have written some tools in the past to recover the file structure of
>> an over-formated ext3/ext4 device based on directory blocks.
>> With some tweaks it should be able to assign the file#inode_numbers in
>> lost+found to a directory structure.
>> Problem is that I'm rather busy with too many other projects already. Do
>> you know C and could you add some code on your own for the lost+found
>> assignment? I can assist you, but it is unlikely that I find much time
>> do it myself...
>
> I'm not that fluent in C, but I could just give it a try. Since it's my
> own data and this recovery for personal "fun" I can't do something bad
> with it :) So, if you could share the code I'd be happy!

I'm going upload the existing code on Sunday. Going to travel tomorrow 
and I need to go to bed now.

Sorry for the day!


Cheers,
Bernd



