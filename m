From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] Add extent conversion support to chattr
Date: Tue, 9 Sep 2008 18:06:45 +0530
Message-ID: <20080909123645.GA5026@skywalker>
References: <1220951542-1451-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20080909114647.GA14052@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.ed, adilger@sun.com, linux-ext4@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:57761 "EHLO
	e28esmtp02.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750837AbYIIMhE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Sep 2008 08:37:04 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28esmtp02.in.ibm.com (8.13.1/8.13.1) with ESMTP id m89Cb1Ie025565
	for <linux-ext4@vger.kernel.org>; Tue, 9 Sep 2008 18:07:01 +0530
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m89Cb18w1658912
	for <linux-ext4@vger.kernel.org>; Tue, 9 Sep 2008 18:07:01 +0530
Received: from d28av04.in.ibm.com (loopback [127.0.0.1])
	by d28av04.in.ibm.com (8.13.1/8.13.3) with ESMTP id m89Cb0as008916
	for <linux-ext4@vger.kernel.org>; Tue, 9 Sep 2008 22:37:01 +1000
Content-Disposition: inline
In-Reply-To: <20080909114647.GA14052@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 09, 2008 at 07:46:47AM -0400, Christoph Hellwig wrote:
> On Tue, Sep 09, 2008 at 02:42:22PM +0530, Aneesh Kumar K.V wrote:
> > This patch adds new option, -E to chattr. The -E option
> > is used to convert the ext3 format (non extent) file
> > to ext4 (extent) format. This can be used to migrate
> > the ext3 file system to ext4 file system.
> 
> I think this is an awkware interfac.  Chattr is supposed to set simple
> binary flags and not a front end to complicated filesystem conversions.
> 

Since chattr is used to set inode flags and since migrate can be looked
at as setting extent flags (with the side effect that we change the 
inode format) I used chattr interface. Last patch i sent actually added a new
command e4migrate. Let me know if you have any suggestion related to
which command is best suited for setting extent flags.

-aneesh
