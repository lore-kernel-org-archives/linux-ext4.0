From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Remove "extents" mount option
Date: Wed, 7 Jan 2009 11:02:50 +0530
Message-ID: <20090107053250.GA9617@skywalker>
References: <1231267777-18831-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:37616 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbZAGFdD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Jan 2009 00:33:03 -0500
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp02.au.ibm.com (8.13.1/8.13.1) with ESMTP id n075W1Aq023538
	for <linux-ext4@vger.kernel.org>; Wed, 7 Jan 2009 16:32:01 +1100
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id n075Xtiv4817000
	for <linux-ext4@vger.kernel.org>; Wed, 7 Jan 2009 16:33:55 +1100
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n075X09R023851
	for <linux-ext4@vger.kernel.org>; Wed, 7 Jan 2009 16:33:00 +1100
Content-Disposition: inline
In-Reply-To: <1231267777-18831-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 06, 2009 at 01:49:37PM -0500, Theodore Ts'o wrote:
> This mount option is largely superfluous, and in fact the way it was
> implemented was buggy; if a filesystem which did not have the extents
> feature flag was mounted -o extents, the filesystem would attempt to
> create and use extents-based file even though the extents feature flag
> was not eabled.  The simplest thing to do is to nuke the mount option
> entirely.  It's not all that useful to force the non-creation of new
> extent-based files if the filesystem can support it.
> 

Ext4 -> Ext3 migration story is to mount the filesystem with -o
noextents and copy the file around. If we remove the -o noextents
options how do we force the creation of non extent format files ?

-aneesh
