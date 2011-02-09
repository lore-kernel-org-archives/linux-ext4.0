From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: ext4 problems with external RAID array via SAS connection
Date: Wed, 09 Feb 2011 14:46:34 -0500
Message-ID: <4D52EF1A.6060902@redhat.com>
References: <OFFAEBAC93.6731CA9F-ON85257830.0067BABF-85257830.0067C1CB@dart.biz> <20110207225436.GG3457@thunk.org> <OF1BE984CE.39437668-ON85257831.00491D12-85257831.0049261D@dart.biz> <OF3CD75888.312195E5-ON85257831.0050CD2F-85257831.0051875E@dart.biz> <4D515F0D.1030902@redhat.com> <OF0792030A.13D80D43-ON85257831.0066ABF1-85257831.006780FD@dart.biz> <4D51AC5E.10404@redhat.com> <OF29FBBBDF.6F048139-ON85257832.004A565E-85257832.004B6F04@dart.biz> <20110209182823.GC9533@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>, bryan.coleman@dart.biz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22187 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010Ab1BITqj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 Feb 2011 14:46:39 -0500
In-Reply-To: <20110209182823.GC9533@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 02/09/2011 01:28 PM, Ted Ts'o wrote:
> On Wed, Feb 09, 2011 at 08:43:56AM -0500, bryan.coleman@dart.biz wrote:
>> The fsck said it completed successfully.  I kicked off fsck again just to
>> make sure and it reported clean.  So I mounted the drive and ls'd around
>> and it started reporting errors.  "ls: cannot access 40: Input/output
>> error"  Note: 40 is a directory.
> Well, we'd need to look at the kernel messages, but the Input/output
> error strongly suggests that there are, well, I/O errors talking to
> your storage array.  Which again suggests hardware problems, or device
> driver bugs, or both.
>
> 						- Ted

I think that you might want to start to test with a simplified storage config. 
Try keep the RAID card in the loop, but using a simpler RAID scheme (single 
drive? RAID0 or RAID1) and see if the issue persists.

Ric

