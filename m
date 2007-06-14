From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH 1/6] Separated 64-bit i_version patch
Date: Thu, 14 Jun 2007 15:41:54 -0600
Message-ID: <20070614214154.GR5181@schatzie.adilger.int>
References: <1181835073.7779.9.camel@garfield> <1181836574.7779.43.camel@garfield> <1181854724.3883.14.camel@dyn9047017103.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kalpak Shah <kalpak@clusterfs.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Jean noel Cordenner <jean-noel.cordenner@bull.net>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:53566 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756185AbXFNVl7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Jun 2007 17:41:59 -0400
Content-Disposition: inline
In-Reply-To: <1181854724.3883.14.camel@dyn9047017103.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jun 14, 2007  13:58 -0700, Mingming Cao wrote:
> On Thu, 2007-06-14 at 21:26 +0530, Kalpak Shah wrote:
> > This patch converts the 32-bit i_version in the generic inode to a 64-
> > bit i_version field.
> > 
> > Signed-off-by: Jean Noel Cordenner <jean-noel.cordenner@bull.net>
> > Signed-off-by: Kalpak Shah <kalpak@clusterfs.com>
> > 
> > @@ -549,7 +549,7 @@ struct inode {
> >         uid_t                   i_uid;
> >         gid_t                   i_gid;
> >         dev_t                   i_rdev;
> > -       unsigned long           i_version;
> > +       uint64_t                i_version;
> >         loff_t                  i_size;
> >  #ifdef __NEED_I_SIZE_ORDERED
> >         seqcount_t              i_size_seqcount;
> > 
> > 
> 
> 
> I think u64 is better here. It seems uint64_t is not defined in some
> cases and rarely being used.

Agreed.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
