From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: Re: fstrim has no effect on a just-mounted filesystem
Date: Tue, 11 Mar 2014 23:30:47 +0000
Message-ID: <20140311233047.GX1346@redhat.com>
References: <20140311213932.GA19176@redhat.com>
 <531F8456.2020404@redhat.com>
 <20140311220013.GV1346@redhat.com>
 <531F8953.1030702@redhat.com>
 <20140311225932.GW1346@redhat.com>
 <20140311230715.GA19648@redhat.com>
 <531F97A8.2020905@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34515 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755500AbaCKXau (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Mar 2014 19:30:50 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s2BNUo8W008789
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 11 Mar 2014 19:30:50 -0400
Content-Disposition: inline
In-Reply-To: <531F97A8.2020905@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 11, 2014 at 06:09:28PM -0500, Eric Sandeen wrote:
> On 3/11/14, 6:07 PM, Richard W.M. Jones wrote:
> 
> > I got it to work by using:
> > 
> > ----------------------------------------------------------------------
> > set -e
> > set -x
> > trace-cmd record -e all fstrim /sysroot
> > trace-cmd report
> > ----------------------------------------------------------------------
> > 
> > The output is absolutely huge and I didn't capture it.
> 
> that's why I suggested a single tracepoint, rather than every tracepoint
> in the kernel... ;)
> 
> oh wait, I didn't.  :/  argh sorry.
> 
> # trace-cmd record -e ext4_trim\* 
> 
> should do it.
> 
> > However just the act of doing the tracing *caused* the trim to happen
> > properly in the underlying disk.
> 
> that sounds very strange...

Thanks Eric.

FYI the libguestfs / virt-sparsify patch series that motivates this is
here:

https://www.redhat.com/archives/libguestfs/2014-March/thread.html#00091

Even with the greatly reduced set of traces (see attached), just the
act of tracing seems to have made trimming work properly.  The output
file has been trimmed properly from 926 MB to 819 MB:

819M	fedora-20.img
926M	fedora-20.img.ORIG

However I don't think making tracing the default on all fstrim
operations is going to be a good solution :-(

Rich.

----------------------------------------------------------------------

+ trace-cmd record -e 'ext4_trim*' fstrim /sysroot
/sys/kernel/debug/tracing/events/ext4_trim*/filter
/sys/kernel/debug/tracing/events/*/ext4_trim*/filter
CPU0 data recorded at offset=0x2d0000
    4096 bytes in size
/sys/kernel/debug/tracing/events/ext4_trim*/filter
/sys/kernel/debug/tracing/events/*/ext4_trim*/filter
Kernel buffer statistics:
  Note: "entries" are the entries left in the kernel ring buffer and are not
        recorded in the trace data. They should all be zero.

CPU: 0
entries: 0
overrun: 0
commit overrun: 0
bytes: 3368
oldest event ts:     2.475090
now ts:     2.500652
dropped events: 0
read events: 105

+ trace-cmd report
version = 6
cpus=1
          fstrim-189   [000]     2.475090: ext4_trim_all_free:   dev 8,3 group 0, start 0, len 32767
          fstrim-189   [000]     2.475092: ext4_trim_extent:     dev 8,3 group 0, start 10061, len 22707
          fstrim-189   [000]     2.475300: ext4_trim_all_free:   dev 8,3 group 1, start 0, len 32767
          fstrim-189   [000]     2.475301: ext4_trim_extent:     dev 8,3 group 1, start 316, len 58
          fstrim-189   [000]     2.475413: ext4_trim_extent:     dev 8,3 group 1, start 384, len 35
          fstrim-189   [000]     2.475501: ext4_trim_extent:     dev 8,3 group 1, start 453, len 1
          fstrim-189   [000]     2.475569: ext4_trim_extent:     dev 8,3 group 1, start 512, len 22
          fstrim-189   [000]     2.475648: ext4_trim_extent:     dev 8,3 group 1, start 1735, len 473
          fstrim-189   [000]     2.475937: ext4_trim_extent:     dev 8,3 group 1, start 9225, len 1
          fstrim-189   [000]     2.476008: ext4_trim_extent:     dev 8,3 group 1, start 9227, len 1
          fstrim-189   [000]     2.476076: ext4_trim_extent:     dev 8,3 group 1, start 9232, len 496
          fstrim-189   [000]     2.476250: ext4_trim_all_free:   dev 8,3 group 3, start 0, len 32767
          fstrim-189   [000]     2.476251: ext4_trim_extent:     dev 8,3 group 3, start 5384, len 8
          fstrim-189   [000]     2.476324: ext4_trim_extent:     dev 8,3 group 3, start 17748, len 684
          fstrim-189   [000]     2.476396: ext4_trim_extent:     dev 8,3 group 3, start 30731, len 7
          fstrim-189   [000]     2.476471: ext4_trim_extent:     dev 8,3 group 3, start 30803, len 1
          fstrim-189   [000]     2.476595: ext4_trim_all_free:   dev 8,3 group 4, start 0, len 32767
          fstrim-189   [000]     2.476596: ext4_trim_extent:     dev 8,3 group 4, start 1607, len 57
          fstrim-189   [000]     2.476665: ext4_trim_extent:     dev 8,3 group 4, start 1798, len 250
          fstrim-189   [000]     2.476736: ext4_trim_extent:     dev 8,3 group 4, start 17810, len 14
          fstrim-189   [000]     2.476809: ext4_trim_extent:     dev 8,3 group 4, start 17862, len 14906
          fstrim-189   [000]     2.485681: ext4_trim_all_free:   dev 8,3 group 5, start 0, len 32767
          fstrim-189   [000]     2.485683: ext4_trim_extent:     dev 8,3 group 5, start 316, len 32452
          fstrim-189   [000]     2.492399: ext4_trim_all_free:   dev 8,3 group 6, start 0, len 32767
          fstrim-189   [000]     2.492400: ext4_trim_extent:     dev 8,3 group 6, start 0, len 32768
          fstrim-189   [000]     2.492546: ext4_trim_all_free:   dev 8,3 group 7, start 0, len 32767
          fstrim-189   [000]     2.492547: ext4_trim_extent:     dev 8,3 group 7, start 316, len 32452
          fstrim-189   [000]     2.492665: ext4_trim_all_free:   dev 8,3 group 8, start 0, len 32767
          fstrim-189   [000]     2.492666: ext4_trim_extent:     dev 8,3 group 8, start 0, len 32768
          fstrim-189   [000]     2.492783: ext4_trim_all_free:   dev 8,3 group 9, start 0, len 32767
          fstrim-189   [000]     2.492784: ext4_trim_extent:     dev 8,3 group 9, start 316, len 32452
          fstrim-189   [000]     2.492897: ext4_trim_all_free:   dev 8,3 group 10, start 0, len 32767
          fstrim-189   [000]     2.492898: ext4_trim_extent:     dev 8,3 group 10, start 0, len 32768
          fstrim-189   [000]     2.493018: ext4_trim_all_free:   dev 8,3 group 11, start 0, len 32767
          fstrim-189   [000]     2.493019: ext4_trim_extent:     dev 8,3 group 11, start 0, len 32768
          fstrim-189   [000]     2.493132: ext4_trim_all_free:   dev 8,3 group 12, start 0, len 32767
          fstrim-189   [000]     2.493133: ext4_trim_extent:     dev 8,3 group 12, start 0, len 32768
          fstrim-189   [000]     2.493245: ext4_trim_all_free:   dev 8,3 group 13, start 0, len 32767
          fstrim-189   [000]     2.493246: ext4_trim_extent:     dev 8,3 group 13, start 0, len 32768
          fstrim-189   [000]     2.493359: ext4_trim_all_free:   dev 8,3 group 14, start 0, len 32767
          fstrim-189   [000]     2.493360: ext4_trim_extent:     dev 8,3 group 14, start 0, len 32768
          fstrim-189   [000]     2.493473: ext4_trim_all_free:   dev 8,3 group 15, start 0, len 32767
          fstrim-189   [000]     2.493473: ext4_trim_extent:     dev 8,3 group 15, start 0, len 32768
          fstrim-189   [000]     2.493586: ext4_trim_all_free:   dev 8,3 group 16, start 0, len 32767
          fstrim-189   [000]     2.493587: ext4_trim_extent:     dev 8,3 group 16, start 9816, len 1
          fstrim-189   [000]     2.493656: ext4_trim_extent:     dev 8,3 group 16, start 9818, len 22950
          fstrim-189   [000]     2.493892: ext4_trim_all_free:   dev 8,3 group 18, start 0, len 32767
          fstrim-189   [000]     2.493892: ext4_trim_extent:     dev 8,3 group 18, start 761, len 1
          fstrim-189   [000]     2.493972: ext4_trim_extent:     dev 8,3 group 18, start 793, len 231
          fstrim-189   [000]     2.494085: ext4_trim_extent:     dev 8,3 group 18, start 6767, len 1
          fstrim-189   [000]     2.494170: ext4_trim_extent:     dev 8,3 group 18, start 7694, len 1
          fstrim-189   [000]     2.494259: ext4_trim_extent:     dev 8,3 group 18, start 7700, len 1
          fstrim-189   [000]     2.494347: ext4_trim_extent:     dev 8,3 group 18, start 12252, len 1
          fstrim-189   [000]     2.494437: ext4_trim_extent:     dev 8,3 group 18, start 24218, len 1
          fstrim-189   [000]     2.494620: ext4_trim_all_free:   dev 8,3 group 19, start 0, len 32767
          fstrim-189   [000]     2.494621: ext4_trim_extent:     dev 8,3 group 19, start 7693, len 1
          fstrim-189   [000]     2.494702: ext4_trim_extent:     dev 8,3 group 19, start 7715, len 1
          fstrim-189   [000]     2.494791: ext4_trim_extent:     dev 8,3 group 19, start 8980, len 108
          fstrim-189   [000]     2.494948: ext4_trim_extent:     dev 8,3 group 19, start 9147, len 37
          fstrim-189   [000]     2.495070: ext4_trim_extent:     dev 8,3 group 19, start 9190, len 4
          fstrim-189   [000]     2.495157: ext4_trim_extent:     dev 8,3 group 19, start 9893, len 349
          fstrim-189   [000]     2.495453: ext4_trim_extent:     dev 8,3 group 19, start 10245, len 507
          fstrim-189   [000]     2.495556: ext4_trim_extent:     dev 8,3 group 19, start 10753, len 22015
          fstrim-189   [000]     2.495739: ext4_trim_all_free:   dev 8,3 group 20, start 0, len 32767
          fstrim-189   [000]     2.495739: ext4_trim_extent:     dev 8,3 group 20, start 799, len 31969
          fstrim-189   [000]     2.495915: ext4_trim_all_free:   dev 8,3 group 21, start 0, len 32767
          fstrim-189   [000]     2.495916: ext4_trim_extent:     dev 8,3 group 21, start 0, len 32768
          fstrim-189   [000]     2.496098: ext4_trim_all_free:   dev 8,3 group 22, start 0, len 32767
          fstrim-189   [000]     2.496099: ext4_trim_extent:     dev 8,3 group 22, start 0, len 32768
          fstrim-189   [000]     2.496270: ext4_trim_all_free:   dev 8,3 group 23, start 0, len 32767
          fstrim-189   [000]     2.496271: ext4_trim_extent:     dev 8,3 group 23, start 0, len 32768
          fstrim-189   [000]     2.496449: ext4_trim_all_free:   dev 8,3 group 24, start 0, len 32767
          fstrim-189   [000]     2.496450: ext4_trim_extent:     dev 8,3 group 24, start 0, len 32768
          fstrim-189   [000]     2.496613: ext4_trim_all_free:   dev 8,3 group 25, start 0, len 32767
          fstrim-189   [000]     2.496614: ext4_trim_extent:     dev 8,3 group 25, start 316, len 32452
          fstrim-189   [000]     2.496780: ext4_trim_all_free:   dev 8,3 group 26, start 0, len 32767
          fstrim-189   [000]     2.496781: ext4_trim_extent:     dev 8,3 group 26, start 0, len 32768
          fstrim-189   [000]     2.496952: ext4_trim_all_free:   dev 8,3 group 27, start 0, len 32767
          fstrim-189   [000]     2.496953: ext4_trim_extent:     dev 8,3 group 27, start 316, len 32452
          fstrim-189   [000]     2.497138: ext4_trim_all_free:   dev 8,3 group 28, start 0, len 32767
          fstrim-189   [000]     2.497139: ext4_trim_extent:     dev 8,3 group 28, start 0, len 32768
          fstrim-189   [000]     2.497341: ext4_trim_all_free:   dev 8,3 group 29, start 0, len 32767
          fstrim-189   [000]     2.497342: ext4_trim_extent:     dev 8,3 group 29, start 0, len 32768
          fstrim-189   [000]     2.497530: ext4_trim_all_free:   dev 8,3 group 30, start 0, len 32767
          fstrim-189   [000]     2.497531: ext4_trim_extent:     dev 8,3 group 30, start 0, len 32768
          fstrim-189   [000]     2.497711: ext4_trim_all_free:   dev 8,3 group 31, start 0, len 32767
          fstrim-189   [000]     2.497712: ext4_trim_extent:     dev 8,3 group 31, start 0, len 32768
          fstrim-189   [000]     2.497873: ext4_trim_all_free:   dev 8,3 group 32, start 0, len 32767
          fstrim-189   [000]     2.497874: ext4_trim_extent:     dev 8,3 group 32, start 8, len 8
          fstrim-189   [000]     2.497960: ext4_trim_extent:     dev 8,3 group 32, start 24, len 8
          fstrim-189   [000]     2.498037: ext4_trim_extent:     dev 8,3 group 32, start 4056, len 28712
          fstrim-189   [000]     2.498235: ext4_trim_all_free:   dev 8,3 group 33, start 0, len 32767
          fstrim-189   [000]     2.498237: ext4_trim_extent:     dev 8,3 group 33, start 0, len 32768
          fstrim-189   [000]     2.498433: ext4_trim_all_free:   dev 8,3 group 34, start 0, len 32767
          fstrim-189   [000]     2.498434: ext4_trim_extent:     dev 8,3 group 34, start 0, len 32768
          fstrim-189   [000]     2.498612: ext4_trim_all_free:   dev 8,3 group 35, start 0, len 32767
          fstrim-189   [000]     2.498613: ext4_trim_extent:     dev 8,3 group 35, start 0, len 32768
          fstrim-189   [000]     2.498780: ext4_trim_all_free:   dev 8,3 group 36, start 0, len 32767
          fstrim-189   [000]     2.498781: ext4_trim_extent:     dev 8,3 group 36, start 0, len 32768
          fstrim-189   [000]     2.498972: ext4_trim_all_free:   dev 8,3 group 37, start 0, len 32767
          fstrim-189   [000]     2.498973: ext4_trim_extent:     dev 8,3 group 37, start 0, len 32768
          fstrim-189   [000]     2.499219: ext4_trim_all_free:   dev 8,3 group 38, start 0, len 32767
          fstrim-189   [000]     2.499221: ext4_trim_extent:     dev 8,3 group 38, start 0, len 32768
          fstrim-189   [000]     2.499397: ext4_trim_all_free:   dev 8,3 group 39, start 0, len 9471
          fstrim-189   [000]     2.499398: ext4_trim_extent:     dev 8,3 group 39, start 0, len 9472



-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
Read my programming blog: http://rwmj.wordpress.com
Fedora now supports 80 OCaml packages (the OPEN alternative to F#)
