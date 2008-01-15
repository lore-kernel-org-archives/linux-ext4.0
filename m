From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: checkpatch.pl warnings
Date: Tue, 15 Jan 2008 11:34:59 -0800
Message-ID: <1200425699.4072.0.camel@localhost.localdomain>
References: <4787D498.1050202@redhat.com> <20080112163144.GA6546@skywalker>
	 <4788ED9E.3090207@redhat.com> <4788EE87.5040007@redhat.com>
	 <1200343767.4197.7.camel@localhost.localdomain>
	 <20080115125224.GA18227@skywalker>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:58022 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896AbYAOTfF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Jan 2008 14:35:05 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e3.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m0FJZ1vj002563
	for <linux-ext4@vger.kernel.org>; Tue, 15 Jan 2008 14:35:01 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m0FJZ172117294
	for <linux-ext4@vger.kernel.org>; Tue, 15 Jan 2008 14:35:01 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m0FJZ1gI012353
	for <linux-ext4@vger.kernel.org>; Tue, 15 Jan 2008 14:35:01 -0500
In-Reply-To: <20080115125224.GA18227@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 2008-01-15 at 18:22 +0530, Aneesh Kumar K.V wrote:
> On Mon, Jan 14, 2008 at 12:49:27PM -0800, Mingming Cao wrote:
> > Hi Guys,
> > 
> > Could you check the checkpatch.pl warnings and see if it make sense to fix them? Thanks!
> > 
> > cmm@kernel:~/fs/ext4/stylecheck$ grep "has style problems" *
> > linux-2.6.24-rc7-48-bit-i_blocks.patch.out:Your patch has style problems, please review.  If any of these errors
> > linux-2.6.24-rc7-ext3-4-migrate.patch.out:Your patch has style problems, please review.  If any of these errors
> > linux-2.6.24-rc7-ext4_export_iov_shorten_from_kernel_for_ext4.patch.out:Your patch has style problems, please review.  If any of these errors
> > linux-2.6.24-rc7-ext4-journal_chksum-2.6.20.patch.out:Your patch has style problems, please review.  If any of these errors
> > linux-2.6.24-rc7-ext4_rec_len_overflow_with_64kblk_fix-v2.patch.out:Your patch has style problems, please review.  If any of these errors
> > linux-2.6.24-rc7-ext4_store_maxbytes_for_bitmaped_files.patch.out:Your patch has style problems, please review.  If any of these errors
> > linux-2.6.24-rc7-inode-version-ext4.patch.out:Your patch has style problems, please review.  If any of these errors
> > linux-2.6.24-rc7-jbd-stats-through-procfs.out:Your patch has style problems, please review.  If any of these errors
> > linux-2.6.24-rc7-large-file-blocktype.patch.out:Your patch has style problems, please review.  If any of these errors
> > linux-2.6.24-rc7-mballoc-core.patch.out:Your patch has style problems, please review.  If any of these errors
> > 
> 
> Fixed the checkpatch.pl warning for all the patches in the patch queue.
> The diff is attached below for review.

Thanks!

patch queue has been updated.

Mingming
