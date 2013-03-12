From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: Inactive memory keep growing and how to release it?
Date: Tue, 12 Mar 2013 16:37:11 +0800
Message-ID: <20130312083711.GA1943@gmail.com>
References: <CAAO_Xo5g2LR54ry=SU7UhGbv-chdkdd6foq+-LjnuE8yAj8ikg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lenky Gao <lenky.gao@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f48.google.com ([209.85.160.48]:46235 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754882Ab3CLIVw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 Mar 2013 04:21:52 -0400
Received: by mail-pb0-f48.google.com with SMTP id wy12so4696916pbc.21
        for <linux-ext4@vger.kernel.org>; Tue, 12 Mar 2013 01:21:52 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAAO_Xo5g2LR54ry=SU7UhGbv-chdkdd6foq+-LjnuE8yAj8ikg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Gao,

On Tue, Mar 12, 2013 at 02:58:24PM +0800, Lenky Gao wrote:
> Hi,
> 
> When i just run a test on Centos 6.2 as follows:
> ################################
> #!/bin/bash
> 
> while true
> do
> 
>         file="/tmp/filetest"
> 
>         echo $file
> 
>         dd if=/dev/zero of=${file} bs=512 count=204800 &> /dev/null
> 
>         sleep 5
> done
> ################################
> 
> the inactive memory keep growing:
> 
> #cat /proc/meminfo | grep Inactive\(fi
> Inactive(file):   420144 kB
> ...
> #cat /proc/meminfo | grep Inactive\(fi
> Inactive(file):   554662 kB
> ...
> #cat /proc/meminfo | grep Inactive\(fi
> Inactive(file):   882824 kB
> 
> and i cannot reclaim it:
> 
> # cat /proc/meminfo | grep Inactive\(file\);
> Inactive(file):   882824 kB
> # sync;
> # echo 3 > /proc/sys/vm/drop_caches
> # cat /proc/meminfo | grep Inactive\(file\);
> Inactive(file):   777664 kB
> 
> My file system type is ext3, mounted with the option data=journal and
> it is easy to reproduce. If the mount option is data=ordered,
> reproducing this problom need more time. Because of the problom, when
> in the final situation, i cannot kmalloc a larger contiguous memory,
> especially in interrupt context. I have tested on other version
> kernel, such as 2.6.30 and 3.6.11, the problom also exists.
> 
> Is this a bug?

I don't think it is a bug.  If I understand correctly, when you try to
reclaim memory (sync and drop caches), the test script is still running,
right?  If so, that means that some memory will be re-dirtied again.  So
the number of inactive pages could not reduce as you expected.

Regards,
                                                - Zheng
