From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH 4/6] add noversion mount option
Date: Thu, 14 Jun 2007 15:42:42 -0600
Message-ID: <20070614214242.GS5181@schatzie.adilger.int>
References: <1181835073.7779.9.camel@garfield> <1181836579.7779.46.camel@garfield> <1181854214.3883.10.camel@dyn9047017103.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kalpak Shah <kalpak@clusterfs.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Jean noel Cordenner <jean-noel.cordenner@bull.net>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:50110 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381AbXFNVmo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Jun 2007 17:42:44 -0400
Content-Disposition: inline
In-Reply-To: <1181854214.3883.10.camel@dyn9047017103.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jun 14, 2007  13:50 -0700, Mingming Cao wrote:
> On Thu, 2007-06-14 at 21:26 +0530, Kalpak Shah wrote:
> > This patch adds a "noversion" mount option to disable inode version
> > updates.
> 
> Can you explain a bit more why we need this mount option? Is it because
> of performance concern? 

This is the "disable i_version updates for Lustre" option we previously
agreed on in the concall.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
