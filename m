From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH 1/5][TAKE3] fallocate() implementation on i86, x86_64
	and powerpc
Date: Tue, 15 May 2007 17:42:46 -0700
Message-ID: <1179276167.4819.22.camel@dyn9047017103.beaverton.ibm.com>
References: <20070329101010.7a2b8783.akpm@linux-foundation.org>
	 <20070330071417.GI355@devserv.devel.redhat.com>
	 <20070417125514.GA7574@amitarora.in.ibm.com>
	 <20070418130600.GW5967@schatzie.adilger.int>
	 <20070420135146.GA21352@amitarora.in.ibm.com>
	 <20070420145918.GY355@devserv.devel.redhat.com>
	 <20070424121632.GA10136@amitarora.in.ibm.com>
	 <20070426175056.GA25321@amitarora.in.ibm.com>
	 <20070515193722.GA3487@amitarora.in.ibm.com>
	 <20070515195421.GA2948@amitarora.in.ibm.com>
	 <20070515200359.GA5834@amitarora.in.ibm.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: torvalds@osdl.org, akpm@linux-foundation.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:34077 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759664AbXEPAmu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 May 2007 20:42:50 -0400
In-Reply-To: <20070515200359.GA5834@amitarora.in.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 2007-05-16 at 01:33 +0530, Amit K. Arora wrote:
> This patch implements sys_fallocate() and adds support on i386, x86_64
> and powerpc platforms.

> @@ -1137,6 +1148,8 @@ struct inode_operations {
>  	ssize_t (*listxattr) (struct dentry *, char *, size_t);
>  	int (*removexattr) (struct dentry *, const char *);
>  	void (*truncate_range)(struct inode *, loff_t, loff_t);
> +	long (*fallocate)(struct inode *inode, int mode, loff_t offset,
> +			  loff_t len);
>  };

Does the return value from fallocate inode operation has to be *long*?
It's not consistent with the ext4_fallocate() define in patch 4/5, 

+int ext4_fallocate(struct inode *inode, int mode, loff_t offset, loff_t
len)

thus cause compile warnings.



Mingming
