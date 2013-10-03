From: Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
Subject: Re: [PATCH 0/2] fs/ext4: increase parallelism in updating ext4 orphan
 list
Date: Thu, 03 Oct 2013 17:20:17 -0600
Message-ID: <524DFBB1.5010101@hp.com>
References: <y> <1380728283-61038-1-git-send-email-tmac@hp.com> <117221D9-7634-4131-95C2-7527C20F1F62@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: T Makphaibulchoke <tmac@hp.com>, Theodore Ts'o <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	aswin@hp.com
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <117221D9-7634-4131-95C2-7527C20F1F62@dilger.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 10/03/2013 06:28 PM, Andreas Dilger wrote:
> 
> It would also be possible to have a completely contention-free orphan
> inode list by only generating the on-disk orphan linked list in a
> pre-commit callback hook from an efficient in-memory list.  That would
> allow the common "add to orphan list; do something; remove from list"
> operations within a single transaction to run with minimal contention,
> and only the few rare cases of operations that exceed the lifetime of
> a single transaction would need to modify the on-disk list.
> 
> For example, a per-cpu list would be quite efficient, or a hash table.
> Then, a jbd2 callback run before the transaction commits could modify
> the requisite inodes and superblock.  All of those inodes are already
> (by definition) part of the transaction, so it won't add new buffers
> of the transaction.
> 
> I'm not necessarily against the current patch, just thinking aloud about
> how it might be improved further.
> 
> Cheers, Andreas
> 

Thanks again for the suggestion.  I'll rework this patch first and look into this possibility next.

Thanks,
Mak.
