From: torn5 <torn5@shiftmail.org>
Subject: Re: Regular ext4 error warning with HD in USB dock
Date: Tue, 28 Dec 2010 11:41:53 +0100
Message-ID: <4D19BEF1.9010708@shiftmail.org>
References: <201012280953.46149.kernel@kolivas.org>
 <20101228025343.GD10149@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Ted Ts'o <tytso@mit.edu>, Con Kolivas <kernel@kolivas.org>,
	linux-kernel@vger.kernel.org, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-usb@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from blade3.isti.cnr.it ([194.119.192.19]:52123 "EHLO
	BLADE3.ISTI.CNR.IT" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988Ab0L1KmY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Dec 2010 05:42:24 -0500
Received: from SCRIPT-SPFWL-DAEMON.mx.isti.cnr.it by mx.isti.cnr.it
 (PMDF V6.5-x5 #31825) id <01NVYB5IJYQ8NG4M5P@mx.isti.cnr.it> for
 linux-ext4@vger.kernel.org; Tue, 28 Dec 2010 11:41:49 +0100 (MET)
Received: from conversionlocal.isti.cnr.it by mx.isti.cnr.it
 (PMDF V6.5-x5 #31825) id <01NVYB5I0PLCNG4JSC@mx.isti.cnr.it> for
 linux-ext4@vger.kernel.org; Tue, 28 Dec 2010 11:41:48 +0100 (MET)
In-reply-to: <20101228025343.GD10149@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/28/2010 03:53 AM, Ted Ts'o wrote:
> On Tue, Dec 28, 2010 at 09:53:45AM +1100, Con Kolivas wrote:
>    
>> Since I moved my internal HD into a USB dock externally and mount the ext4
>> filesystem on it, I regularly get the following errors after it has been
>> mounted for a while (see timecode). It doesn't seem to matter which recent
>> kernel I use.
>>
>> [1048401.773270] EXT4-fs (sde8): mounted filesystem with writeback data mode.
>> Opts: (null)
>> [1048702.736011] EXT4-fs (sde8): error count: 3
>> [1048702.736016] EXT4-fs (sde8): initial error at 1289053677:
>> ext4_journal_start_sb:251
>> [1048702.736018] EXT4-fs (sde8): last error at 1289080948: ext4_put_super:719
>>      
> That's actually not an error.  It's a report which is generated every
> 24 hours, indicating that there has been 3 errors since the last time
> the error count has been cleared, with the first error taking place at
> Sat Nov 6 10:27:57 2010 (US/Eastern) in the function
> ext4_journal_start_sb(), at line 251, and the most recent error taking
> place at Sat Nov 6 18:02:28 2010 (US/Eastern), in the function
> ext4_put_super() at line 719.  This is a new feature which was added
> in 2.6.36.
>    


This is going to be a faq...
I suppose the datetime is encoded (what format is that?) in that long 
number after "at".
May I suggest the datetime gets decoded in the printing?
Also may I suggest that the error happens immediately after mount and 
not after 300 seconds from mount?

I just subscribed to this list exactly to report the same kind of error.

Last week I was doing reliability tests for open-iscsi and this error 
drove me crazy. I spent days in tests where I thought I could reproduce 
an error in open-iscsi by disconnecting and reconnecting the network; I 
even reported this to the open-iscsi mailing list, but in fact it was an 
old error of the filesystem and it was not getting cleared by my older 
e2fsck 1.41.11 .

If that happened immediately after mount or if it spitted the datetime 
in human readable format, I would have immediately guessed it was due to 
an existing "filesystem problem" (even though I was running fsck.ext4 -f 
prior to each mount) but instead I thought it was due to my 5 minutes of 
"networks disconnection tests" I was doing after each mount. DOH!

Anyway thanks for your work: excellent filesystem.

PS: I have a question for you regarding ext4 behaviour with SCSI 
commands resubmissions... ok I am opening another thread for that.
