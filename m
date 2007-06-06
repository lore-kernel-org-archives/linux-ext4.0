From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: [PATCH] Set JBD2_FEATURE_INCOMPAT_64BIT on filesystems larger
 than 32-bit blocks
Date: Wed, 6 Jun 2007 07:10:58 -0500
Message-ID: <20070606071058.0a10c451@gara>
References: <20070605230912.1d6c4377@gara>
	<4666689A.8070605@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Laurent Vivier <Laurent.Vivier@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:39066 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760551AbXFFMLO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Jun 2007 08:11:14 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l56CBEgF007924
	for <linux-ext4@vger.kernel.org>; Wed, 6 Jun 2007 08:11:14 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l56CBDND211380
	for <linux-ext4@vger.kernel.org>; Wed, 6 Jun 2007 06:11:13 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l56CBD95018818
	for <linux-ext4@vger.kernel.org>; Wed, 6 Jun 2007 06:11:13 -0600
Received: from austin.ibm.com (netmail2.austin.ibm.com [9.41.248.176])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l56CBDKZ018792
	for <linux-ext4@vger.kernel.org>; Wed, 6 Jun 2007 06:11:13 -0600
In-Reply-To: <4666689A.8070605@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 06 Jun 2007 09:56:10 +0200
Laurent Vivier <Laurent.Vivier@bull.net> wrote:

> Jose R. Santos wrote:
> > Set the journals JBD2_FEATURE_INCOMPAT_64BIT on devices with more
> > than 32bit block sizes during mount time.  This ensure proper record
> > lenth when writing to the journal.
> > 
> > Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
> > Signed-off-by: Andreas Dilger <adilger@clusterfs.com>
> > Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> > ---
> >  fs/ext4/super.c |   11 +++++++++++
> >  1 file changed, 11 insertions(+)
> > 
> > Index: linux-2.6.22-rc3/fs/ext4/super.c
> > ===================================================================
> > --- linux-2.6.22-rc3.orig/fs/ext4/super.c	2007-06-04 11:01:20.028360650 -0500
> > +++ linux-2.6.22-rc3/fs/ext4/super.c	2007-06-05 21:14:33.974854532 -0500
> > @@ -1824,6 +1824,13 @@ static int ext4_fill_super (struct super
> >  		goto failed_mount3;
> >  	}
> >  
> > +	if (ext4_blocks_count(es) > 0xffffffff &&
> 
> Perhaps you should use 0xffffffffULL ?

Ah yes...  Thanks for pointing that out.

I will make that change and add you to the Signed-off-by list if its OK
with you.

Thanks

-JRS
