From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH, RFC] properly lock group descriptors before initializing
Date: Wed, 16 Jul 2008 00:36:09 -0500
Message-ID: <487D88C9.4050501@redhat.com>
References: <487D8671.2080307@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:50919 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818AbYGPFgM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Jul 2008 01:36:12 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m6G5aBZb014696
	for <linux-ext4@vger.kernel.org>; Wed, 16 Jul 2008 01:36:11 -0400
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6G5aACj000400
	for <linux-ext4@vger.kernel.org>; Wed, 16 Jul 2008 01:36:10 -0400
Received: from liberator.sandeen.net (sebastian-int.corp.redhat.com [172.16.52.221])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6G5a9Ok032661
	for <linux-ext4@vger.kernel.org>; Wed, 16 Jul 2008 01:36:10 -0400
In-Reply-To: <487D8671.2080307@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:
> I noticed when filling a 1T filesystem with 4 threads using the 
> fs_mark benchmark:
> 
> fs_mark -d /mnt/test -D 256 -n 100000 -t 4 -s 20480 -F -S 0
> 
> that I occasionally got checksum mismatch errors:
> 
> EXT4-fs error (device sdb): ext4_init_inode_bitmap: Checksum bad for group 6935
> 
> etc.  I'd reliably get 4-5 of them during the run.
> 
> It appears that the problem is likely a race to init the bg's
> when the uninit_bg feature is enabled.
> 
> With the patch below I was able to complete 2 runs with no errors
> or warnings.  However, I did hit a hang on one run that I can't yet
> explain, so maybe this bears more inspection or testing.

Crud hit it again, looks like it's my fault.  So hold off on this one :)

-Eric
