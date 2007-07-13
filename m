From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/6][TAKE7] revalidate write permissions for fallocate
Date: Fri, 13 Jul 2007 14:21:37 +0100
Message-ID: <20070713132137.GB23256@infradead.org>
References: <20070713123816.GA18000@amitarora.in.ibm.com> <20070713124847.GC22961@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com, tytso@mit.edu,
	cmm@us.ibm.com, suparna@in.ibm.com, adilger@clusterfs.com,
	dgc@sgi.com
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:44688 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759719AbXGMNVi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Jul 2007 09:21:38 -0400
Content-Disposition: inline
In-Reply-To: <20070713124847.GC22961@amitarora.in.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jul 13, 2007 at 06:18:47PM +0530, Amit K. Arora wrote:
> From: David P. Quigley <dpquigl@tycho.nsa.gov>
> 
> Revalidate the write permissions for fallocate(2), in case security policy has
> changed since the files were opened.
> 
> Acked-by: James Morris <jmorris@namei.org>
> Signed-off-by: David P. Quigley <dpquigl@tycho.nsa.gov>

This should be merged into the main falloc patch.
