Return-Path: <SRS0=rve6=Q5=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37138C10F00
	for <linux-ext4@archiver.kernel.org>; Fri, 22 Feb 2019 14:13:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 068EE206B7
	for <linux-ext4@archiver.kernel.org>; Fri, 22 Feb 2019 14:13:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PIx1tUCw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbfBVON2 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 22 Feb 2019 09:13:28 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:49446 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbfBVON2 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Feb 2019 09:13:28 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1ME3oZL017205;
        Fri, 22 Feb 2019 14:12:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2018-07-02;
 bh=eSEnlAD8Ses7wRSS+VgOS5zr89VkEj4Sm8noepqIjNM=;
 b=PIx1tUCwgb5/do+XIYK2Fk+kt9eLNPF+MPQYyyHQTYg+b0f6l48/9VxkoyBCY5dWhFFE
 Iqt+oLAYmLVg41O49I+Q+3H9mMeNQGhmWLR5nVRUEsCOPXfLwPRriPSPsowFaGNszipq
 lfu39Rmfg8/IkY65DHye+lYmGK0hvHO2NB/SlgwBMnUA3cObmiSZeOoDGiUCZgEIAzaK
 cjmidY8y7fOHQQIO34EmfYcrF1yJ13WFlcEQcH7pfR0/h7DDbQT6eKmV/s70v6vV5S41
 9PpoA6HtzidL0jvkZIWdVlTS5Cki39H33m+VsJLurnR4WeksPa+mVtEBc37vi2XqvoIh wQ== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2qpb5rybh7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Feb 2019 14:12:54 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x1MECmNk028826
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Feb 2019 14:12:48 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x1MEClAR017912;
        Fri, 22 Feb 2019 14:12:47 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 Feb 2019 06:12:47 -0800
To:     Roman Mamedov <rm@romanrm.net>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jeff Mahoney <jeffm@suse.com>,
        Keith Busch <keith.busch@intel.com>,
        Ric Wheeler <ricwheeler@gmail.com>,
        Dave Chinner <david@fromorbit.com>,
        lsf-pc@lists.linux-foundation.org,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        linux-block@vger.kernel.org
Subject: Re: [LSF/MM TOPIC] More async operations for file systems - async discard?
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <92ab41f7-35bc-0f56-056f-ed88526b8ea4@gmail.com>
        <20190217210948.GB14116@dastard>
        <46540876-c222-0889-ddce-44815dcaad04@gmail.com>
        <20190220234723.GA5999@localhost.localdomain>
        <45c27fea-6d74-2adc-fe9d-e314ce4f3672@suse.com>
        <yq17edsil17.fsf@oracle.com> <20190222111532.4ead81dc@natsu>
Date:   Fri, 22 Feb 2019 09:12:44 -0500
In-Reply-To: <20190222111532.4ead81dc@natsu> (Roman Mamedov's message of "Fri,
        22 Feb 2019 11:15:32 +0500")
Message-ID: <yq136ofj4ir.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9174 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902220100
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


Roman,

>> Consequently, many of the modern devices that claim to support
>> discard to make us software folks happy (or to satisfy a purchase
>> order requirements) complete the commands without doing anything at
>> all.  We're simply wasting queue slots.
>
> Any example of such devices? Let alone "many"? Where you would issue a
> full-device blkdiscard, but then just read back old data.

I obviously can't mention names or go into implementation details. But
there are many drives out there that return old data. And that's
perfectly within spec.

At least some of the pain in the industry in this department can be
attributed to us Linux folks and RAID device vendors. We all wanted
deterministic zeroes on completion of DSM TRIM, UNMAP, or DEALLOCATE.
The device vendors weren't happy about that and we ended up with weasel
language in the specs. This lead to the current libata whitelist mess
for SATA SSDs and ongoing vendor implementation confusion in SCSI and
NVMe devices.

On the Linux side the problem was that we originally used discard for
two distinct purposes: Clearing block ranges and deallocating block
ranges. We cleaned that up a while back and now have BLKZEROOUT and
BLKDISCARD. Those operations get translated to different operations
depending on the device. We also cleaned up several of the
inconsistencies in the SCSI and NVMe specs to facilitate making this
distinction possible in the kernel.

In the meantime the SSD vendors made great strides in refining their
flash management. To the point where pretty much all enterprise device
vendors will ask you not to issue discards. The benefits simply do not
outweigh the costs.

If you have special workloads where write amplification is a major
concern it may still be advantageous to do the discards and reduce WA
and prolong drive life. However, these workloads are increasingly moving
away from the classic LBA read/write model. Open Channel originally
targeted this space. Right now work is underway on Zoned Namespaces and
Key-Value command sets in NVMe.

These curated application workload protocols are fundamental departures
from the traditional way of accessing storage. And my postulate is that
where tail latency and drive lifetime management is important, those new
command sets offer much better bang for the buck. And they make the
notion of discard completely moot. That's why I don't think it's going
to be terribly important in the long term.

This leaves consumer devices and enterprise devices using the
traditional LBA I/O model.

For consumer devices I still think fstrim is a good compromise. Lack of
queuing for DSM hurt us for a long time. And when it was finally added
to the ATA command set, many device vendors got their implementations
wrong. So it sucked for a lot longer than it should have. And of course
FTL implementations differ.

For enterprise devices we're still in the situation where vendors
generally prefer for us not to use discard. I would love for the
DEALLOCATE/WRITE ZEROES mess to be sorted out in their FTLs, but I have
fairly low confidence that it's going to happen. Case in point: Despite
a lot of leverage and purchasing power, the cloud industry has not been
terribly successful in compelling the drive manufacturers to make
DEALLOCATE perform well for typical application workloads. So I'm not
holding my breath...

-- 
Martin K. Petersen	Oracle Linux Engineering
