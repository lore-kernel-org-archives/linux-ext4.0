From: "Justin Piszcz" <jpiszcz@lucidpixels.com>
Subject: RE: Far too long mount time
Date: Fri, 17 Aug 2012 11:00:19 -0400
Message-ID: <018a01cd7c89$05687cf0$103976d0$@lucidpixels.com>
References: <CAAnFQG_O051svcCZftDefebVEds+P1zAceteh=B18HOqmoqitg@mail.gmail.com> <CAAnFQG9esXovsAYkCS5Lw5JGpc5dW2PLccvYjN7NvaHLQDqGmA@mail.gmail.com> <0F24AF1B-39C9-4300-862B-B9E84A21E34C@dilger.ca> <1345126608.22142.59.camel@cwalton-XPS-8300> <20120816144219.GB29410@thunk.org> <20120816185337.GB31346@thunk.org> <20120817135506.GC11439@thunk.org> <018901cd7c87$515904b0$f40b0e10$@lucidpixels.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "'Andreas Dilger'" <adilger@dilger.ca>,
	"'Javier Marcet'" <jmarcet@gmail.com>,
	"'Linux Ext4 Mailing List'" <linux-ext4@vger.kernel.org>
To: "'Theodore Ts'o'" <tytso@mit.edu>,
	"'Calvin Walton'" <calvin.walton@kepstin.ca>, <ap@solarrain.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55383 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756333Ab2HQPAV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Aug 2012 11:00:21 -0400
Received: by yenl14 with SMTP id l14so4055355yen.19
        for <linux-ext4@vger.kernel.org>; Fri, 17 Aug 2012 08:00:21 -0700 (PDT)
In-Reply-To: <018901cd7c87$515904b0$f40b0e10$@lucidpixels.com>
Content-Language: en-us
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



-----Original Message-----
From: Justin Piszcz [mailto:jpiszcz@lucidpixels.com] 
Sent: Friday, August 17, 2012 10:48 AM
To: 'Theodore Ts'o'; 'Calvin Walton'; ap@solarrain.com
Cc: 'Andreas Dilger'; 'Javier Marcet'; 'Linux Ext4 Mailing List'
Subject: RE: Far too long mount time



-----Original Message-----
From: Theodore Ts'o [mailto:tytso@mit.edu] 
Sent: Friday, August 17, 2012 9:55 AM
To: Calvin Walton
Cc: Andreas Dilger; Javier Marcet; Linux Ext4 Mailing List;
jpiszcz@lucidpixels.com
Subject: Re: Far too long mount time

On Thu, Aug 16, 2012 at 02:53:37PM -0400, Theodore Ts'o wrote:
> This patch should solve the problem (as an alternative to reverting
> 8aeb00ff85a).

This should be "grp"; stupid typo on my part.

This patch with the fix-up will be pushed to Linus shortly and tagged
for the stable tree.

--

Hi Theo,

Found the patch here:
http://www.spinics.net/lists/linux-ext4/msg33498.html

Patched against the fresh+stable 3.5.1 tree:

p34:/usr/src/linux-3.5.1# patch -p1 < ../tso.patch
patching file fs/ext4/super.c
Hunk #1 succeeded at 3109 (offset -20 lines).
p34:/usr/src/linux-3.5.1#

Rebooted, but we have a problem, my 60TB RAID-6 is now a 46TB RAID-6?
I am rebooting back into the 3.5.1+earlier reverted patch.

p34:~# uptime; uname -a ; df -h | grep /r1
 10:46:51 up 0 min,  1 user,  load average: 1.04, 0.27, 0.09
Linux p34 3.5.1 #5 SMP Fri Aug 17 10:24:22 EDT 2012 x86_64 GNU/Linux
/dev/sda1        46T  1.5T   45T   4% /r1
p34:~#
--

Went back to old kernel (w/reverted patch, it is ok now)

p34:~# uname -a; uptime; df -h |grep /r1
Linux p34 3.5.1+ #3 SMP Sun Aug 12 10:31:34 EDT 2012 x86_64 GNU/Linux
 10:59:51 up 9 min,  1 user,  load average: 0.00, 0.20, 0.23
/dev/sda1        61T   16T   45T  27% /r1
p34:~#

Justin.



