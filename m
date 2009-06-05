From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: Re: Mild filesystem corruption on ext4 (no journal)
Date: Fri, 05 Jun 2009 22:42:41 +0100
Message-ID: <4A299151.3040109@tuffmail.co.uk>
References: <4A28F83F.4030704@tuffmail.co.uk> <4A292E61.3050204@gmail.com> 	<4A293084.5010400@tuffmail.co.uk> <4A2937CC.7070503@redhat.com> 	<4A294B15.9070209@tuffmail.co.uk> <ac3eb2510906050951o200c3aeex56dcb32bf29d0607@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>,
	Aioanei Rares <krnl.list@gmail.com>,
	linux-ext4@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:60779 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738AbZFEVlY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 5 Jun 2009 17:41:24 -0400
In-Reply-To: <ac3eb2510906050951o200c3aeex56dcb32bf29d0607@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Kay Sievers wrote:
> On Fri, Jun 5, 2009 at 18:43, Alan Jenkins<alan-jenkins@tuffmail.co.uk> wrote:
>
>   
>> If I remove the corrupted file and copy a "known good" copy into it's place,
>> then the corruption doesn't happen.  I've verified this a couple of times.
>>  The corruption only occurs if the file was created by "locale-gen".
>>     
>
> Does it use things like: fallocate()?
>
> Kay
>   

Not quite. Ted says it's already reported as

    http://bugzilla.kernel.org/show_bug.cgi?id=13292

It includes an strace log which implicates the use of both mmap() and 
write() on the same file.  Sounds scary :-).

Alan
