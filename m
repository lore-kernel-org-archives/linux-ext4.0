From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Group meta-data blocks together.
Date: Mon, 19 May 2008 15:27:52 +0530
Message-ID: <20080519095752.GA2762@skywalker>
References: <1210866839-7195-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1210866839-7195-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20080515160626.GB23507@skywalker> <482C617B.8090909@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, tytso@mit.edu, adilger@sun.com,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:37459 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628AbYESJ6J (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 May 2008 05:58:09 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp06.au.ibm.com (8.13.1/8.13.1) with ESMTP id m4J9ve9B032732
	for <linux-ext4@vger.kernel.org>; Mon, 19 May 2008 19:57:40 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m4JA2DLs243202
	for <linux-ext4@vger.kernel.org>; Mon, 19 May 2008 20:02:13 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m4J9w6F3014329
	for <linux-ext4@vger.kernel.org>; Mon, 19 May 2008 19:58:06 +1000
Content-Disposition: inline
In-Reply-To: <482C617B.8090909@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 15, 2008 at 11:14:51AM -0500, Eric Sandeen wrote:
> Aneesh Kumar K.V wrote:
> > On Thu, May 15, 2008 at 09:23:59PM +0530, Aneesh Kumar K.V wrote:
> >> This adds a per inode meta-block prealloc space from which
> >> meta-data block requests are served. This help in making
> >> sure meta-data block are closer. This is needed to speedup
> >> unlink of the file. Any new prealloc space is allocated near
> >> the goal block specified. The goal block is the last block
> >> allocated for the file. So we don't keep the data-block and
> >> meta-data block far apart.
> >>
> > 
> > The result can be found at
> > 
> > http://www.radian.org/~kvaneesh/ext4/meta-group/
> 
> Out of curiosity, do you have graphs similar to
> http://www.radian.org/~kvaneesh/ext4/meta-group/ext4-noextents-metagroup.png
> 
> before and after your change?

http://www.radian.org/~kvaneesh/ext4/meta-group/exp1/

-aneesh
