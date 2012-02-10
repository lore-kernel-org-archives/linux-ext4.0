From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: Restoring filenames from partly damaged ext4-filesystem
Date: Fri, 10 Feb 2012 14:41:14 +0100
Message-ID: <4F351E7A.2070005@fastmail.fm>
References: <1328804993.34330.YahooMailNeo@web132403.mail.ird.yahoo.com> <ADF9EEFE-188A-4E88-BA8E-45D2607B1F3B@dilger.ca> <1328822543.65833.YahooMailNeo@web132404.mail.ird.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@dilger.ca>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"debian-user@lists.debian.org" <debian-user@lists.debian.org>
To: Rudolf Zran <rudolfzran@yahoo.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailgw1.uni-kl.de ([131.246.120.220]:50332 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759286Ab2BJNlU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Feb 2012 08:41:20 -0500
Received: from itwm2.itwm.fhg.de (itwm2.itwm.fhg.de [131.246.191.3])
	by mailgw1.uni-kl.de (8.14.3/8.14.3/Debian-5+lenny1) with ESMTP id q1ADfHht003026
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Fri, 10 Feb 2012 14:41:18 +0100
In-Reply-To: <1328822543.65833.YahooMailNeo@web132404.mail.ird.yahoo.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 02/09/2012 10:22 PM, Rudolf Zran wrote:
> Hello Andreas!
>
>
> [ext4 partition overwritten with garbage at the beginning]
>
>
>>>   * photorec from the testdisk package recoveres, luckily!, about 500GB of
>>>     data. Though the content seems to be pretty reasonable, no filenames
>>>     are recovered, since photorec operates without using filesystem
>>>    knowledge.
>>>
>>>   Do you see any chances (besides consulting professional recovery companies)
>>>   getting the filenames back?
>>
>> There was an ext3grep tool that some people had success with, but when I
>> looked at it, it was still fairly complex to use.
>
> Thanks for the hint, but the problem with ext3grep is that it seems to
> rely on an intact filesystem structure. It even has no option to set
> another superblock besides the default one and fails with all commands
> I tried ( see https://pzt.me/8q6k ).
>

I have written some tools in the past to recover the file structure of 
an over-formated ext3/ext4 device based on directory blocks.
With some tweaks it should be able to assign the file#inode_numbers in 
lost+found to a directory structure.
Problem is that I'm rather busy with too many other projects already. Do 
you know C and could you add some code on your own for the lost+found 
assignment? I can assist you, but it is unlikely that I find much time 
do it myself...


Cheers,
Bernd

