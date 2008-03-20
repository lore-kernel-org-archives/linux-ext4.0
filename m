From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: powerpc e2fsprogs and fast symlink
Date: Thu, 20 Mar 2008 18:26:37 +0530
Message-ID: <20080320125637.GC11891@skywalker>
References: <20080319193801.GA16687@skywalker> <20080320125028.GX3158@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:56123 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472AbYCTM4q (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Mar 2008 08:56:46 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp04.au.ibm.com (8.13.1/8.13.1) with ESMTP id m2KCuHBD026603
	for <linux-ext4@vger.kernel.org>; Thu, 20 Mar 2008 23:56:17 +1100
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m2KCuiM64489290
	for <linux-ext4@vger.kernel.org>; Thu, 20 Mar 2008 23:56:44 +1100
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m2KCuoVi030043
	for <linux-ext4@vger.kernel.org>; Thu, 20 Mar 2008 23:56:50 +1100
Content-Disposition: inline
In-Reply-To: <20080320125028.GX3158@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 20, 2008 at 08:50:28AM -0400, Theodore Tso wrote:
> On Thu, Mar 20, 2008 at 01:08:01AM +0530, Aneesh Kumar K.V wrote:
> > Hi Ted,
> > 
> > While testing on powerpc i found that e2fsck is getting confused about
> > fast symlink on powerpc. On x86_64 it works fine.
> 
> What version of e2fsprogs are you testing?  Are you using 1.40.8, or
> the git 'next' (or 'master') branch?  I was missing a byte-swap patch
> in 1.40.8; it is in the git tree at this point.
> 

It is next a7c9cb7d0dc464eda26958595b728a6c3a4cacbc


-aneesh

