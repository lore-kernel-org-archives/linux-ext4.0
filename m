From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: powerpc e2fsprogs and fast symlink
Date: Thu, 20 Mar 2008 14:49:00 -0500
Message-ID: <47E2BFAC.5080806@redhat.com>
References: <20080319193801.GA16687@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:35523 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754942AbYCTT60 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Mar 2008 15:58:26 -0400
In-Reply-To: <20080319193801.GA16687@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> Hi Ted,
> 
> While testing on powerpc i found that e2fsck is getting confused about
> fast symlink on powerpc. On x86_64 it works fine.

Just as a sanity check I made an ext4 image on ppc with fast/long
symlinks, dirs, files of various sizes etc; e2fsck from next fails on ppc:

e2fsck 1.40.8 (13-Mar-2008)
Pass 1: Checking inodes, blocks, and sizes
Error while reading over extent tree in inode 12: Corrupt extent header
Clear inode? no

Segmentation fault

but transporting the image to x86_64, e2fsck is fine.  So at least it
doesn't look like an on-disk problem.  :)

-Eric
