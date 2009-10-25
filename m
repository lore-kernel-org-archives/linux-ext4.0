From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [Bug 14354] Re: ext4 increased intolerance to unclean shutdown?
Date: Sun, 25 Oct 2009 07:22:02 +0100
Message-ID: <20091025062202.GB1391@ucw.cz>
References: <f7848160910152128h96237b7ga103915082d6412b@mail.gmail.com> <20091016091558.GA10184@mit.edu> <4AD8C679.3030300@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>,
	Parag Warudkar <parag.lkml@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
	bugzilla-daemon@bugzilla.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40175 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753682AbZJYTEM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 25 Oct 2009 15:04:12 -0400
Content-Disposition: inline
In-Reply-To: <4AD8C679.3030300@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi!

>>> So I have been experimenting with various root file systems on my
>>> laptop running latest git. This laptop some times has problems waking
>>> up from sleep and that results in it needing a hard reset and
>>> subsequently unclean file system.
>>>      
>> A number of people have reported this, and there is some discussion
>> and some suggestions that I've made here:
>>
>> 	http://bugzilla.kernel.org/show_bug.cgi?id=14354
>>
>> It's been very frustrating because I have not been able to replicate
>> it myself; I've been very much looking for someone who is (a) willing
>> to work with me on this, and perhaps willing to risk running fsck
>> frequently, perhaps after every single unclean shutdown, and (b) who
>> can reliably reproduce this problem.  On my system, which is a T400
>> running 9.04 with the latest git kernels, I've not been able to
>> reproduce it, despite many efforts to try to reproduce it.  (i.e.,
>> suspend the machine and then pull the battery and power; pulling the
>> battery and power, "echo c>  /proc/sysrq-trigger", etc., while
>> doing "make -j4" when the system is being uncleanly shutdown)
>>    
>
> I wonder if we might have better luck if we tested using an external  
> (e-sata or USB connected) S-ATA drive.
>
> Instead of pulling the drive's data connection, most of these have an  
> external power source that could be turned off so the drive firmware  
> won't have a chance to flush the volatile write cache. Note that some  
> drives automatically write back the cache if they have power and see a  
> bus disconnect, so hot unplugging just the e-sata or usb cable does not  
> do the trick.
>
> Given the number of cheap external drives, this should be easy to test  
> at home....

Do they support barriers?

(Anyway, you may want to use some kind of VM for testing. That should
make the testing cycle shorter, easier to reprorduce *and* more repeatable.)

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
