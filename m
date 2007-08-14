From: Alex Tomas <alex@clusterfs.com>
Subject: Re: Change output format of filefrag
Date: Tue, 14 Aug 2007 17:53:39 +0400
Message-ID: <46C1B3E3.1000404@clusterfs.com>
References: <1187097165.3907.9.camel@garfield>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: TheodoreTso <tytso@mit.edu>,
	Andreas Dilger <adilger@clusterfs.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Kalpak Shah <kalpak@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.rialcom.ru ([80.71.245.247]:52137 "EHLO mail.rialcom.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751480AbXHNNyR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 14 Aug 2007 09:54:17 -0400
In-Reply-To: <1187097165.3907.9.camel@garfield>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I'd make sense to dump location of index blocks as well (optional?).

thanks, Alex

Kalpak Shah wrote:
> Hi,
> 
> I am adding FIEMAP support to filefrag and I noticed that current output
> format of filefrag can be improved a lot. It is very difficult to add
> information like lun, extent type, etc. to such a format.
> 
> $ filefrag  -v /tmp/abc 
> 
> Checking /tmp/abc
> Filesystem type is: ef53
> Filesystem cylinder groups is approximately 296
> File is stored in extents format
> Blocksize of file /tmp/abc is 1024
> File size of /tmp/abc is 10485760 (10240 blocks)
> First block: 4609
> Last block: 26068
> Discontinuity: Block 512 is at 8556 (was 5120)
> Discontinuity: Block 517 is at 15729 (was 8560)
> Discontinuity: Block 1173 is at 16633 (was 16384)
> Discontinuity: Block 9117 is at 24945 (was 24576)
> Discontinuity: Block 9125 is at 24954 (was 24952)
> /tmp/abc: 6 extents found
> 
> I think an output format similar to that of xfs may be better. This is
> easier for parsing as well. Like this:
> 
> $ filefrag -e {filename}
> 
> ext:    logical:   phys start..end kB:  kB :lun: flags
>   0:   [0..151]: 288444888..288445039: 152 : 0 :
>   1: [152..199]: XXXXXXXX..YYYYYYYYYY:  47 : 0 : hole
>   2: [200..299]: MMMMMMMM..NNNNNNNNNN: 100 : 0 : unwritten, unknown
> 
> Please suggest if this is ok.
> 
> Thanks,
> Kalpak.
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
