From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: Re: Mild filesystem corruption on ext4 (no journal)
Date: Fri, 05 Jun 2009 15:49:40 +0100
Message-ID: <4A293084.5010400@tuffmail.co.uk>
References: <4A28F83F.4030704@tuffmail.co.uk> <4A292E61.3050204@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Aioanei Rares <krnl.list@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:58295 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbZFEOtn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 5 Jun 2009 10:49:43 -0400
In-Reply-To: <4A292E61.3050204@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aioanei Rares wrote:
> Alan Jenkins wrote:
>> Hi,
>>
>> I run ext4 without a journal on my cheap netbook with a 4 gig SSD.  I 
>> suspect "without a journal" is significant, I don't think I'm doing 
>> anything else strange.
>>
>> When I upgrade libc from 2.7 (debian stable) to 2.9 (debian 
>> unstable), the locale breaks every reboot, and I have to repair it by 
>> running locale-gen.  This happened now when I only upgraded libc, in 
>> order to play with signalfd().  It also happened before, when I 
>> upgraded the entire machine to debian unstable (which I later reverted).
>>
>> The problem is that /usr/lib/locale/locale-archive gets corrupted 
>> when I reboot.  The exact corruption differs with each reboot (i.e. 
>> the md5sum differs).  Last time, the first ~70K was overwritten with 
>> data from xorg.log and my web browsing history.  I have copies of the 
>> original and corrupted state which I can send, the full file is 1.3 
>> megs, but I can limit it to the first 70K, since that's all that was 
>> corrupted.
>>
>> To try and rule out a faulty userspace program, I marked the file as 
>> read-only (chmod a-w) and immutable (chattr +i).  After a reboot, the 
>> file was still read-only and immutable, yet it still became corrupted.
>>
>> Also, I ran md5sum in the shutdown scripts, after mounting the root 
>> filesystem read-only (which is also preceeded by a sync in a 
>> different script).  This showed that the file did not appear 
>> corrupted at this point.  (Though maybe it was ok in page-cache, but 
>> corrupted on-disk).
>>
>> The locale-archive file is read by the libc locale routines using 
>> mmap().  The mapping is read only and is not modified.  It seems 
>> likely that some process has it mapped when the kernel shuts down.
>>
>> I tried reproducing this by writting a minimal daemon which maps a 
>> copy of the locale-archive file, and starting it just before the 
>> filesystem is remounted read-only.  It didn't work though; this copy 
>> of the locale-archive file remained uncorrupted.
>>
>> I forced a fsck on boot, and the filesystem was reported to be 
>> clean.  I am currently running with e2fsprogs v1.41.6 (from debian 
>> unstable), and a custom-built kernel, 2.6.30-rc7.
>>
>> Thanks in advance!
>> Alan
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe 
>> linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
> I suspect, although I might be wrong, that this is not a kernel-related
> problem.

"To try and rule out a faulty userspace program, I marked the file as 
read-only (chmod a-w) and immutable (chattr +i).  After a reboot, the 
file was still read-only and immutable, yet it still became corrupted."

Since the immutable bit is not respected, I tend to think it is a kernel 
problem.  Unless the filesystem isn't getting unmounted/flushed properly 
for some reason... but I thought the modern kernel had that covered.

I agree it is very suspicious this happens only after upgrading libc.  
I'll see if I can find an individual change in libc locale-handling that 
might trigger this.

Thanks
Alan
