From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: High latency with ext4 / jbd2 kernel thread
Date: Tue, 12 Jul 2011 07:17:44 -0400
Message-ID: <A9ADAB08-144C-4636-A02B-076CF47300F4@mit.edu>
References: <CALEedhfHQBiCxv06X3w-JwUzP+beJ9+_zUbr=9vHErp+ew1r=w@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: Andy Campbell <andycampbell.uk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-3.MIT.EDU ([18.9.25.14]:62336 "EHLO
	dmz-mailsec-scanner-3.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752972Ab1GLLRs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Jul 2011 07:17:48 -0400
In-Reply-To: <CALEedhfHQBiCxv06X3w-JwUzP+beJ9+_zUbr=9vHErp+ew1r=w@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Jul 11, 2011, at 8:07 PM, Andy Campbell wrote:

> Hi ext4 mailing list members,
> 
> I hope you can help me with a problem.
> 
> I recently upgraded my main audio PC to Fedora FC15 and, at the same
> time, reformatted by root drive to ext4.  Since this upgrade this, my
> system has high system latency which is causing my audio hardware
> (firewire) to experience buffer under-runs (XRUNs).  This causes
> "unhandled xrun" errors and the audio software fails.

What were you using before?  ext3 ?   It may be that ext4's default use of
barriers (for safety reasons) is causing a difference.   Try mounting your
file systems with barrier=0.   For the root filesystem, add "rootflags=barrier=0".
This is an unsafe way to run, in that if you have a power failure while you
are writing to the disk, your file system(s) could get corrupted.   Ext3 
defaulted to this for historical reasons (although the enterprise Linux systems,
RHEL and SuSE changed the default for safety reasons).

If this solves the problem, I'd suggest that you look into finding ways to
increase the buffer size of your audio system (were you recording or
doing playback at the time).   You might also try to see if there was 
some amount of disk activity (especially write activity) that could be
avoided or find some way of avoiding the use of fsync() so that you
can re-enable write barriers without causing your latency skips.

Regards,

-- Ted


