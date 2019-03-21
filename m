Return-Path: <SRS0=3UD1=RY=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28BC8C43381
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 03:18:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 01D24218A5
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 03:18:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727660AbfCUDSi (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 20 Mar 2019 23:18:38 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:43297 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726983AbfCUDSi (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Mar 2019 23:18:38 -0400
Received: from callcc.thunk.org (guestnat-104-133-0-99.corp.google.com [104.133.0.99] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x2L3IXd7016599
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Mar 2019 23:18:34 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 92512420AA8; Wed, 20 Mar 2019 23:18:33 -0400 (EDT)
Date:   Wed, 20 Mar 2019 23:18:33 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Mikhail Morfikov <mmorfikov@gmail.com>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: Question about ext4 extents and file fragmentation
Message-ID: <20190321031833.GB32021@mit.edu>
References: <aad2611a-9640-9ec1-108a-f67ba662c301@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aad2611a-9640-9ec1-108a-f67ba662c301@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Mar 20, 2019 at 11:44:19PM +0100, Mikhail Morfikov wrote:
> When we have a big file on an ext4 partition, and filefrag shows
> the following:
> 
> filefrag -ve /bigfile
> Filesystem type is: ef53
> File size of /bigfile is 1439201280 (351368 blocks of 4096 bytes)
>  ext:     logical_offset:        physical_offset: length:   expected: flags:
>    0:        0..   32767:      34816..     67583:  32768:            
>    1:    32768..   63487:      67584..     98303:  30720:            
>    2:    63488..   96255:     100352..    133119:  32768:      98304:
>    3:    96256..  126975:     133120..    163839:  30720:            
>    4:   126976..  159743:     165888..    198655:  32768:     163840:
>    5:   159744..  190463:     198656..    229375:  30720:            
>    6:   190464..  223231:     231424..    264191:  32768:     229376:
>    7:   223232..  253951:     264192..    294911:  30720:            
>    8:   253952..  286719:     296960..    329727:  32768:     294912:
>    9:   286720..  319487:     329728..    362495:  32768:            
>   10:   319488..  351367:     362496..    394375:  31880:             last,eof
> /bigfile: 5 extents found
> 
> 1. How many fragments does this file really have? 11 or 5? 
> 2. Should the extents 0 and 1 be treated as one fragment or two 
>    separate ones? I know they could be one from the human 
>    perspective, but is it really one for ext4 filesystem?

They are encoded as two separate physical extents on disk.  Logically,
extents 0, 1, and 2 are contiguous regions on idks.

> 3. What does actually happen during the read in the case of 
>    some HDD and its magnetic heads? If the head finishes reading 
>    the whole extent (ext 0), will it be able to read the data of 
>    the next extent (ext 1) without any delays like in the case of
>    raw read (for instance dd if=/dev/sda ...), or will it be 
>    delayed because of the filesystem layer, and the head will 
>    have to spend some time to be positioned again in order to 
>    read the next extent?

The delay won't be because of the file system layer, as the
information about these first three extents will all be stored on the
same block on disk.  In addition, ext4 has an in-memory "extent cache"
which stores the logical->physical block mapping, and in memory, it
will be stored as a single entry in the extent cache.

It takes *time* to read 128 megabytes (32768 4k blocks), and from a
hard drive perspective, you are doing a streaming sequential read, how
the file system metadata is stored is not going to be the limiting
factor.  In fact, it's likely that they won't be issued to the hard
drive as a single I/O request anyway.  But that doesn't matter; the
hard drive has an I/O request queue, and so the right thing will
happen.

					- Ted
