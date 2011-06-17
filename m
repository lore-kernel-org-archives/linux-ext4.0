From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3 v5] XFS TESTS: Expand 252 punch hole test
Date: Fri, 17 Jun 2011 08:08:53 -0400
Message-ID: <20110617120853.GB20714@infradead.org>
References: <4DED63DE.1070000@vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	xfs-oss <xfs@oss.sgi.com>
To: Allison Henderson <achender@vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:39602
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758268Ab1FQMIy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Jun 2011 08:08:54 -0400
Content-Disposition: inline
In-Reply-To: <4DED63DE.1070000@vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 06, 2011 at 04:33:50PM -0700, Allison Henderson wrote:
> This patch adds additional punch hole tests to 252
> that were used to test ext4 punch hole. The _test_generic_punch
> routine has been modified to accept two new flags:
> 
> -k To keep the test file between tests.
>    This will test the handling of existing holes
> 
> -d To not sync the file between tests.
>    This will test the handling of delayed extents
> 
> Four new corner cases have also been added to the routine:
> 14. data -> hole @ EOF
> 15. data -> hole @ 0
> 16. data -> cache cold ->hole
> 17. data -> hole in single block file

Looks good, I'll put it in.

