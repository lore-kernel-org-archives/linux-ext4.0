From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 11266] New: unable to handle kernel paging
 request in ext2_free_blocks
Date: Thu, 7 Aug 2008 10:52:51 -0700
Message-ID: <20080807105251.bf28cbd0.akpm@linux-foundation.org>
References: <bug-11266-10286@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: bugme-daemon@bugzilla.kernel.org, linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: sliedes@cc.hut.fi
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34330 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751382AbYHGRyB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Aug 2008 13:54:01 -0400
In-Reply-To: <bug-11266-10286@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

On Thu,  7 Aug 2008 05:53:37 -0700 (PDT) bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=11266
> 
>            Summary: unable to handle kernel paging request in
>                     ext2_free_blocks
>            Product: File System
>            Version: 2.5
>      KernelVersion: 2.6.27-rc2 + patch for #10976 (now in -mm)
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: ext2
>         AssignedTo: akpm@osdl.org
>         ReportedBy: sliedes@cc.hut.fi
> 
> 
> Latest working kernel version: (I think at least 2.6.25.4 works)
> Earliest failing kernel version:
> Distribution: Minimal Debian sid (unstable)
> Hardware Environment: qemu x86
> Software Environment:
> Problem Description:
> 
> Mere rm -rf after mounting on an intentionally corrupted partition occasionally
> causes "BUG: unable to handle kernel paging request" in ext2_free_blocks. 
> 
> Unfortunately the issue seems to be timing sensitive (or something), doing it
> on the same filesystem only sometimes results in the crash :( But I have
> reproduced it something like 6 times now with brief testing.
> 
> If you wish, I can attach some filesystems with which I have been able to
> reproduce this at least once.
> 
> Another thing I could do is take a look at it with the new kernel debugger
> (which I haven't tried yet) if none of you are able to figure out this from the
> traces. Is there something you would specifically want me to take a look at?
> The local and referenced variables at ext2_free_blocks(), I guess?
> 
> I think I ran quite extensive tests on 2.6.25.4 & ext2, so I suspect (but am
> not sure, I've made some changes to the way I test) this bug is newer than
> 2.6.25.4. I could do some bisecting too, but I haven't managed to automate the
> thing yet.
> 
> Here's a script I run under qemu, google for zzuf (it's a fuzzer), and timeout
> is from the Debian package `timeout':
> 
> ----------
> #!/bin/sh
> 
> if [ "`hostname`" != "fstest" ]; then
>    echo "This is a dangerous script."
>    echo "Set your hostname to \`fstest\' if you want to use it."
>    exit 1
> fi
> 
> umount /dev/hdb
> umount /dev/hdc
> /etc/init.d/sysklogd stop
> /etc/init.d/klogd stop
> /etc/init.d/cron stop
> mount /dev/hda / -t ext3 -o remount,ro || exit 1
> 
> ulimit -t 20
> 
> for ((s=$1; s<1000000000; s++)); do
>   umount /mnt
>   echo '***** zzuffing *****' seed $s
>   zzuf -r 0:0.03 -s $s </dev/hdc >/dev/hdb || exit
>   mount /dev/hdb /mnt -o errors=continue || continue
>   cd /mnt || continue
>   cp -r doc doc2 >&/dev/null
>   find -xdev >&/dev/null
>   find -xdev -print0 2>/dev/null |xargs -0 touch -- 2>/dev/null
>   mkdir tmp >&/dev/null
>   echo whoah >tmp/filu 2>/dev/null
>   rm -rf /mnt/* >&/dev/null
>   cd /
> done
> ----------
> 
> The attached backtraces all start from the time of mounting the filesystem.
> 

Yes, please do test 2.6.26.

Aneesh, your recent changes to the ext2 block allocator would have to
be prime suspects here.

