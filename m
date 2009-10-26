From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [Bug 14354] Re: ext4 increased intolerance to unclean shutdown?
Date: Mon, 26 Oct 2009 09:49:14 -0400
Message-ID: <4AE5A8DA.3040209@redhat.com>
References: <f7848160910152128h96237b7ga103915082d6412b@mail.gmail.com> <20091016091558.GA10184@mit.edu> <4AD8C679.3030300@redhat.com> <20091025062202.GB1391@ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>,
	Parag Warudkar <parag.lkml@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
	bugzilla-daemon@bugzilla.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47104 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751920AbZJZNq2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 Oct 2009 09:46:28 -0400
In-Reply-To: <20091025062202.GB1391@ucw.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/25/2009 02:22 AM, Pavel Machek wrote:
> Hi!
>
>>>> So I have been experimenting with various root file systems on my
>>>> laptop running latest git. This laptop some times has problems waking
>>>> up from sleep and that results in it needing a hard reset and
>>>> subsequently unclean file system.
>>>>
>>> A number of people have reported this, and there is some discussion
>>> and some suggestions that I've made here:
>>>
>>> 	http://bugzilla.kernel.org/show_bug.cgi?id=14354
>>>
>>> It's been very frustrating because I have not been able to replicate
>>> it myself; I've been very much looking for someone who is (a) willing
>>> to work with me on this, and perhaps willing to risk running fsck
>>> frequently, perhaps after every single unclean shutdown, and (b) who
>>> can reliably reproduce this problem.  On my system, which is a T400
>>> running 9.04 with the latest git kernels, I've not been able to
>>> reproduce it, despite many efforts to try to reproduce it.  (i.e.,
>>> suspend the machine and then pull the battery and power; pulling the
>>> battery and power, "echo c>   /proc/sysrq-trigger", etc., while
>>> doing "make -j4" when the system is being uncleanly shutdown)
>>>
>>
>> I wonder if we might have better luck if we tested using an external
>> (e-sata or USB connected) S-ATA drive.
>>
>> Instead of pulling the drive's data connection, most of these have an
>> external power source that could be turned off so the drive firmware
>> won't have a chance to flush the volatile write cache. Note that some
>> drives automatically write back the cache if they have power and see a
>> bus disconnect, so hot unplugging just the e-sata or usb cable does not
>> do the trick.
>>
>> Given the number of cheap external drives, this should be easy to test
>> at home....
>
> Do they support barriers?
>
> (Anyway, you may want to use some kind of VM for testing. That should
> make the testing cycle shorter, easier to reprorduce *and* more repeatable.)
>
> 									Pavel
>

The drives themselves will support barriers - they are the same S-ATA/ATA drives 
you get normally for your desktop, etc.

I think that e-SATA would have no trouble (but fewer boxes have that external 
S-ATA port). Not sure how reliable the SCSI -> USB -> ATA conversion is for USB 
drives though (a lot of moving pieces there!).

VM testing is a good idea, but I worry that the virtual IO stack support for 
data integrity is still somewhat shaky. Christoph was working on fixing various 
bits and pieces I think...

ric

