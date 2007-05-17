From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: Checksuming metadata+data
Date: Thu, 17 May 2007 12:03:20 -0600
Message-ID: <20070517180320.GJ5286@schatzie.adilger.int>
References: <488612090.20070517101237@mail.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: sftf <sftf-misc@mail.ru>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:47700 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755706AbXEQSDW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 May 2007 14:03:22 -0400
Content-Disposition: inline
In-Reply-To: <488612090.20070517101237@mail.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On May 17, 2007  10:12 +0600, sftf wrote:
> Why to not implement two modes (via create/mount options):
> 1. Checksuming metadata only
> 2. Checksuming metadata+data (i.e. checksuming ALL)

I don't think anyone is planning data checksumming any time soon.  Even
metadata checksumming is some ways away.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
