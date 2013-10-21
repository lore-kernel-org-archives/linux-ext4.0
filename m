From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: Weird jbd2 I/O load
Date: Tue, 22 Oct 2013 00:55:20 +0800
Message-ID: <52655C78.4080507@gmail.com>
References: <525DB679.4070008@redhost.ro> <20131021135338.GA3392@gmail.com> <5265392D.1020500@redhost.ro>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Andrei Banu <andrei.banu@redhost.ro>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:33625 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025Ab3JUQzY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Oct 2013 12:55:24 -0400
Received: by mail-pd0-f179.google.com with SMTP id y10so4834643pdj.38
        for <linux-ext4@vger.kernel.org>; Mon, 21 Oct 2013 09:55:24 -0700 (PDT)
In-Reply-To: <5265392D.1020500@redhost.ro>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/21/2013 10:24 PM, Andrei Banu wrote:
> Hi Zheng,
> 
> Thank you for your reply. We can make this test and if it doesn't help
> we'll re-enable
> the barrier but first I need to ask a few questions:
> 
> 1. /dev/md2 is mounted on /. So your command should look like this?
> 
> $ mount -t ext4 -o remount,barrier=0    /dev/md2    /

Yes.

> 
> In /etc/fstab I have other parameters as well:
> noatime,usrjquota=quota.user,jqfmt=vfsv0
> Do I also add these like this:
> 
> $ mount -t ext4 -o
> remount,barrier=0,noatime,usrjquota=quota.user,jqfmt=vfsv0 /dev/md2     /

If I remember correctly, this command is OK.  But frankly I don't do the
test.  I am not sure all these options will pass when you remount a
partition.

> 
> 2. Can the command above be run on an active (very active) cPanel server?

Sorry, I am not familiar with cPanel server.  But if your previous
testings run on a server under a heavy pressure.  It quite impacts the
result because disk bandwidth is occupied by this process.

> 
> 3. How do I re-enable the barrier?

sudo mount -t ext4 -o remount,barrier=1 ${DEV} ${MNT}

> 
> 4. What is the probability of data loss in case of cold reboot?

After disabling barrier, the system couldn't ensure that the dirty data
has been written into the disk medium if your device couldn't support
FUA command.  So I just want to make sure that your SSD can not handle
barrier command properly.  *Please do not use 'barrier=0' in your
product system*.

						- Zheng

> 
> Thanks!
> 
> On 10/21/2013 4:53 PM, Zheng Liu wrote:
>> Hi Andrei,
>>
>> Could you please disable barrier for ext4 and try your 'dd' test again?
>>    $ sudo mount -t ext4 -o remount,barrier=0 ${DEV} ${MNT}
>>
>> *WARNING: you could lost your data with barrier=0 when you get a power
>> failure or cold reset.*
>>
>> We have met a similar problem that is because some SSDs couldn't handle
>> barrier command properly.
>>
>> Regards,
>>                                                  - Zheng
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

