From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Please help: Is ext4 counting trims as writes, or is something
 killing my SSD?
Date: Thu, 12 Sep 2013 10:52:38 -0500
Message-ID: <5231E346.5030000@redhat.com>
References: <20130912141856.GA17640@jak-x230> <1378997643.28638.53.camel@hp-a6734f> <5231DB33.9090104@redhat.com> <20130912153232.GA19548@jak-x230>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Julian Andres Klode <jak@jak-linux.org>,
	Calvin Walton <calvin.walton@kepstin.ca>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25670 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753195Ab3ILPwm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Sep 2013 11:52:42 -0400
In-Reply-To: <20130912153232.GA19548@jak-x230>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 9/12/13 10:32 AM, Julian Andres Klode wrote:
> On Thu, Sep 12, 2013 at 10:18:11AM -0500, Eric Sandeen wrote:

...

<note, realized that my test on loop might not be valid>

> I created a file using fallocate, deleted it (with discard option set
> on the FS), and then sync'ed and got the following changes in sdb3:
> 
> jak@jak-x230:~$ diff /tmp/a /tmp/b
> diff --git tmp/a tmp/b
> index e0370bf..43c2fdd 100644
> --- tmp/a
> +++ tmp/b
> @@ -1,7 +1,7 @@
>     8       0 sda 1845 2122 15992 15268 6070 313375 3119314 5359680 0 85548 5391508
>     8       1 sda1 500 0 3970 1104 4106 37774 2840016 1028656 0 29656 1046320
> -   8      16 sdb 85114 4486 4281300 36344 143239 111626 282319450 1803288 0 101416 1839608
> +   8      16 sdb 85114 4486 4281300 36344 143300 111658 284417426 1803492 0 101460 1839812
>     8      17 sdb1 930 992 8152 316 2 0 2 0 0 68 316
>     8      18 sdb2 72071 3316 3024626 29692 54309 29582 23201808 183432 0 37704 213060
> -   8      19 sdb3 11858 175 1246458 6320 88381 82044 259117640 1619624 0 65880 1626200
> +   8      19 sdb3 11858 175 1246458 6320 88442 82076 261215616 1619828 0 65924 1626404
                                                        ^^^^^^^^^
field 7 (after major/minor/device) is the number of sectors written.

Yours moved by exactly 1G.

So the takeaway is; I think discards *are* included in the stats, but don't worry, it's
not doing IO to your device.  It was added here, and it doesn't seem to have changed:

commit c69d48540c201394d08cb4d48b905e001313d9b8
Author: Jens Axboe <jens.axboe@oracle.com>
Date:   Fri Apr 24 08:12:19 2009 +0200

    block: include discard requests in IO accounting
    
    We currently don't do merging on discard requests, but we potentially
    could. If we do, then we need to include discard requests in the IO
    accounting, or merging would end up decrementing in_flight IO counters
    for an IO which never incremented them.
    
    So enable accounting for discard requests.

However, it seems a little odd to me that ext4 feels it necessary to issue
discards on blocks which have been fallocated but not written to, I'll have
to think about that part (doesn't really matter for your case, it's just a
curiosity).

Thanks,
-Eric
