From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH 3/8][e2fsprogs] add new -D <desc-size> option to mkfs
Date: Thu, 30 Aug 2007 08:12:37 -0600
Message-ID: <20070830141237.GT5377@schatzie.adilger.int>
References: <1188487715.15770.35.camel@ext1.frec.bull.fr> <1188488221.15770.46.camel@ext1.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:56298 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756675AbXH3OMO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 30 Aug 2007 10:12:14 -0400
Content-Disposition: inline
In-Reply-To: <1188488221.15770.46.camel@ext1.frec.bull.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Aug 30, 2007  17:37 +0200, Valerie Clement wrote:
> @@ -1439,6 +1448,26 @@ static void PRS(int argc, char *argv[])
> +		if (desc_size < EXT2_MIN_DESC_SIZE ||
> +		    desc_size > EXT2_BLOCK_SIZE(&fs_param) ||

Should this be EXT2_MAX_DESC_SIZE?

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
