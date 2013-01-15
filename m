From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: debuge2fs not displaying /dev folder
Date: Tue, 15 Jan 2013 12:00:31 -0600
Message-ID: <50F5993F.5020606@redhat.com>
References: <CAD6i1f+GzTqewnV=2OefPTGT8YFzNo6+zmoPvxuJXMb9r0ABng@mail.gmail.com> <CAD6i1f+p0-W2Pf-Pcf6phTNqrzn6h3OG+zXM3nc9hULdKq1zvw@mail.gmail.com> <CF3C02F1-C284-4E7F-9921-C6DB21A33EE5@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Prashant Shah <pshah.mumbai@gmail.com>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31593 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757440Ab3AOSnP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Jan 2013 13:43:15 -0500
In-Reply-To: <CF3C02F1-C284-4E7F-9921-C6DB21A33EE5@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 1/15/13 11:43 AM, Andreas Dilger wrote:
> 
> On 2013-01-14, at 11:01 PM, Prashant Shah wrote:
>> When using debuge2fs on a ext3 partition the /dev partition does not
>> show any entries at all. While running it on a ext4 partition only
>> part of entries are shown for /dev.
>>
>> Below is the list of files and folder within /dev folder residing on
>> a ext4 partition. Using "debugfs" shows around 92 entries while "ls"
>> shows around 217 entries. A block level dump also shows the same
>> folders as "debugfs".
> 
> The first and most important question is whether "/dev" is a real
> filesystem, or if it is a virtual (e.g. "tmpfs" type) filesystem
> on your machine?

was going to say the same thing; try

# mount | grep "on /dev"

>> --------------------- debugfs --------------------
>> 3014659  (12) .    2  (12) ..    3014663  (12) fd    3014664  (16) mapper
>> 3014665  (12) pts    3014666  (12) shm    3014667  (16) agpgart
>>
>>
>> --------- from ls -----------
>> autofs           ecryptfs  loop6               pts    random    sr0
>> tty2   tty35  tty50  tty9       ttyS22  uinput      vcsa2
>> block            fb0       loop7               ram0   rfkill    stderr
> 
> It would be useful to show "ls -li" information for some of the
> entries that appear via debugfs (e.g. "fd", "pts", and "shm" above),
> and also some of the entries that do not appear in debugfs.

Yep, I'm guessing you are seeing some installer-created devices in the root fs's
/dev but that something has been mounted over the top of it.

-Eric

 
> Cheers, Andreas


