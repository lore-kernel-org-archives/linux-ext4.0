From: Ted Ts'o <tytso@mit.edu>
Subject: Re: ext4 problems with external RAID array via SAS connection
Date: Wed, 9 Feb 2011 13:28:23 -0500
Message-ID: <20110209182823.GC9533@thunk.org>
References: <OFFAEBAC93.6731CA9F-ON85257830.0067BABF-85257830.0067C1CB@dart.biz>
 <20110207225436.GG3457@thunk.org>
 <OF1BE984CE.39437668-ON85257831.00491D12-85257831.0049261D@dart.biz>
 <OF3CD75888.312195E5-ON85257831.0050CD2F-85257831.0051875E@dart.biz>
 <4D515F0D.1030902@redhat.com>
 <OF0792030A.13D80D43-ON85257831.0066ABF1-85257831.006780FD@dart.biz>
 <4D51AC5E.10404@redhat.com>
 <OF29FBBBDF.6F048139-ON85257832.004A565E-85257832.004B6F04@dart.biz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: bryan.coleman@dart.biz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40492 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755472Ab1BIS2d (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 Feb 2011 13:28:33 -0500
Content-Disposition: inline
In-Reply-To: <OF29FBBBDF.6F048139-ON85257832.004A565E-85257832.004B6F04@dart.biz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 09, 2011 at 08:43:56AM -0500, bryan.coleman@dart.biz wrote:
> 
> The fsck said it completed successfully.  I kicked off fsck again just to 
> make sure and it reported clean.  So I mounted the drive and ls'd around 
> and it started reporting errors.  "ls: cannot access 40: Input/output 
> error"  Note: 40 is a directory.

Well, we'd need to look at the kernel messages, but the Input/output
error strongly suggests that there are, well, I/O errors talking to
your storage array.  Which again suggests hardware problems, or device
driver bugs, or both.

						- Ted
