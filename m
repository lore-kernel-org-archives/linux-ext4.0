From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [Fwd: [Bug] 2.6.30 kernel stack trace with 'fsfuzzer ext3' on
	s390]
Date: Mon, 29 Jun 2009 12:28:56 +0200
Message-ID: <20090629102856.GB9321@osiris.boeblingen.de.ibm.com>
References: <4A48858B.5080602@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, sachinp@linux.vnet.ibm.com,
	linux-s390@vger.kernel.org, akpm@linux-foundation.org
To: Nageswara R Sastry <rnsastry@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:33461 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbZF2K3F (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Jun 2009 06:29:05 -0400
Content-Disposition: inline
In-Reply-To: <4A48858B.5080602@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 29, 2009 at 02:42:43PM +0530, Nageswara R Sastry wrote:
> Hitting the same bug with 2.6.31-rc1 on s390 arch.
>
>
> EXT3-fs error (device loop0): htree_dirblock_to_tree: bad entry in  
> directory #2: rec_len % 4 != 0 - offset=44, inode=12, rec_len=139,  
> name_len=10
> __log_wait_for_space: needed 256 blocks and only had 0 space available
> __log_wait_for_space: no way to get more journal space

Does this _only_ happen on s390? I would expect that this is not
architecture specific. Whatever fsfuzzer is doing.
