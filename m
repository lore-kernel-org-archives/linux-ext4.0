From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: delayed allocatiou result in Oops
Date: Tue, 19 Jun 2007 15:50:05 -0600
Message-ID: <20070619215005.GU5181@schatzie.adilger.int>
References: <20070614072352.GA6517@localhost.sw.ru> <4672202C.4080304@clusterfs.com> <1181949368.3808.7.camel@dyn9047017103.beaverton.ibm.com> <20070616081426.GB14349@localhost.sw.ru> <1182214878.3711.21.camel@dyn9047017103.beaverton.ibm.com> <46778186.9030306@clusterfs.com> <20070619091628.GB20172@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alex Tomas <alex@clusterfs.com>, cmm@us.ibm.com,
	linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@sw.ru>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:53845 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbXFSVuI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Jun 2007 17:50:08 -0400
Content-Disposition: inline
In-Reply-To: <20070619091628.GB20172@localhost.sw.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jun 19, 2007  13:16 +0400, Dmitry Monakhov wrote:
> But whole approach based on using PagePrivate bit and page->private
> ptr for special purposes is realy dengerous, and imho wrong,
> because avery fs-related code assume that page->private points to
> page_buffers.

This is actually a misconception.  page->private can be anything.  While
many fs helper routines use page->private as buffers, that only happens
when the fs itself causes those helper routines to be called.  Lustre,
for example, has no buffer heads on the clients, and uses page->private
to track RPC batching information and data checksums.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
