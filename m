From: Tao Ma <tm@tao.ma>
Subject: Re: High latency with ext4 / jbd2 kernel thread
Date: Tue, 12 Jul 2011 18:48:14 +0800
Message-ID: <4E1C266E.4030802@tao.ma>
References: <CALEedhfHQBiCxv06X3w-JwUzP+beJ9+_zUbr=9vHErp+ew1r=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Andy Campbell <andycampbell.uk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy12-pub.bluehost.com ([67.222.39.55]:39974 "HELO
	oproxy12-pub.bluehost.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1752052Ab1GLKsV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Jul 2011 06:48:21 -0400
In-Reply-To: <CALEedhfHQBiCxv06X3w-JwUzP+beJ9+_zUbr=9vHErp+ew1r=w@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Andy,
On 07/12/2011 08:07 AM, Andy Campbell wrote:
> Hi ext4 mailing list members,
> 
> I hope you can help me with a problem.
> 
> I recently upgraded my main audio PC to Fedora FC15 and, at the same
> time, reformatted by root drive to ext4.  Since this upgrade this, my
> system has high system latency which is causing my audio hardware
> (firewire) to experience buffer under-runs (XRUNs).  This causes
> "unhandled xrun" errors and the audio software fails.
> 
> My audio software (jackd) is running in realtime mode with SCHED_FIFO priority.
> 
> I have been using latencytop (http://www.latencytop.org/) to try to
> understand what is causing the system latency.
> Typically my system runs with a max latency around 5ms.  If i run a
> disk heavy operation (such as updatedb) I see a max latency of around
> 20ms.
> 
> Around the time that jackd fails, I can see events like this with a
> latency of 40 - 120 ms:
> "writing buffer to disk (synchronous)"  = "jbd2_journal_commit_transaction"
> Screenshot here
> http://dl.dropbox.com/u/3289905/latencytop.png
I guess the reason may be some regression.
I have sent a patch to linux-ext4 with the subject
"jbd/2[stable only]: Use WRITE_SYNC_PLUG in journal_commit_transaction."

Can you try it to see if it helps.
> 
> My kernel version is
> Linux speedy.local 2.6.38.8-32.fc15.i686.PAE #1 SMP Mon Jun 13
> 19:55:27 UTC 2011 i686 i686 i386 GNU/Linu
> 
> The ext4 drive is mounted with these options:
> /dev/sda4 on / type ext4 (rw,relatime,seclabel,barrier=1,data=ordered)
> I also tried mounting using using noatime and also using
> data=writeback options.  Unfortunately neither of these parameters
> resolved the problem

Thanks
Tao
