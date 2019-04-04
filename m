Return-Path: <SRS0=e1E2=SG=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A65F3C4360F
	for <linux-ext4@archiver.kernel.org>; Thu,  4 Apr 2019 09:57:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 80FB9206DD
	for <linux-ext4@archiver.kernel.org>; Thu,  4 Apr 2019 09:57:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728920AbfDDJ5J (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 4 Apr 2019 05:57:09 -0400
Received: from tartarus.angband.pl ([54.37.238.230]:60640 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728040AbfDDJ5J (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Apr 2019 05:57:09 -0400
Received: from kilobyte by tartarus.angband.pl with local (Exim 4.92)
        (envelope-from <kilobyte@angband.pl>)
        id 1hBz73-0003Sa-AG; Thu, 04 Apr 2019 11:56:49 +0200
Date:   Thu, 4 Apr 2019 11:56:49 +0200
From:   Adam Borowski <kilobyte@angband.pl>
To:     Pankaj Gupta <pagupta@redhat.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        darrick wong <darrick.wong@oracle.com>,
        linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-acpi@vger.kernel.org,
        qemu-devel@nongnu.org, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org,
        dan j williams <dan.j.williams@intel.com>,
        zwisler@kernel.org, vishal l verma <vishal.l.verma@intel.com>,
        dave jiang <dave.jiang@intel.com>, mst@redhat.com,
        jasowang@redhat.com, willy@infradead.org, rjw@rjwysocki.net,
        hch@infradead.org, lenb@kernel.org, jack@suse.cz, tytso@mit.edu,
        adilger kernel <adilger.kernel@dilger.ca>,
        lcapitulino@redhat.com, kwolf@redhat.com, imammedo@redhat.com,
        jmoyer@redhat.com, nilal@redhat.com, riel@surriel.com,
        stefanha@redhat.com, aarcange@redhat.com, david@redhat.com,
        cohuck@redhat.com,
        xiaoguangrong eric <xiaoguangrong.eric@gmail.com>
Subject: Re: [PATCH v4 5/5] xfs: disable map_sync for async flush
Message-ID: <20190404095649.GB8738@angband.pl>
References: <20190403104018.23947-1-pagupta@redhat.com>
 <20190403104018.23947-6-pagupta@redhat.com>
 <20190403220912.GB26298@dastard>
 <1518295599.17367903.1554358350929.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1518295599.17367903.1554358350929.JavaMail.zimbra@redhat.com>
X-Junkbait: aaron@angband.pl, zzyx@angband.pl
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: kilobyte@angband.pl
X-SA-Exim-Scanned: No (on tartarus.angband.pl); SAEximRunCond expanded to false
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Apr 04, 2019 at 02:12:30AM -0400, Pankaj Gupta wrote:
> > All this ad hoc IS_DAX conditional logic is getting pretty nasty.
> > 
> > xfs_file_mmap(
> > ....
> > {
> > 	struct inode	*inode = file_inode(filp);
> > 
> > 	if (vma->vm_flags & VM_SYNC) {
> > 		if (!IS_DAX(inode))
> > 			return -EOPNOTSUPP;
> > 		if (!dax_synchronous(xfs_find_daxdev_for_inode(inode))
> > 			return -EOPNOTSUPP;
> > 	}
> > 
> > 	file_accessed(filp);
> > 	vma->vm_ops = &xfs_file_vm_ops;
> > 	if (IS_DAX(inode))
> > 		vma->vm_flags |= VM_HUGEPAGE;
> > 	return 0;
> > }
> 
> Sure, this is better.

> > Even better, factor out all the "MAP_SYNC supported" checks into a
> > helper so that the filesystem code just doesn't have to care about
> > the details of checking for DAX+MAP_SYNC support....
> 
> o.k. Will add one common helper function for both ext4 & xfs filesystems.

Note this pending patch for Goldwyn Rodrigues' patchset for btrfs:

https://lore.kernel.org/linux-btrfs/20190328102418.5466-1-kilobyte@angband.pl/

We might want to coordinate.


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀
⣾⠁⢠⠒⠀⣿⡁ Did ya know that typing "test -j8" instead of "ctest -j8"
⢿⡄⠘⠷⠚⠋⠀ will make your testsuite pass much faster, and fix bugs?
⠈⠳⣄⠀⠀⠀⠀
