From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 5/4] exofs: Handle error from d_splice_alias()
Date: Mon, 11 Jun 2012 18:41:30 +0300
Message-ID: <4FD611AA.5010006@panasas.com>
References: <1338322067-17566-1-git-send-email-jack@suse.cz> <4FC5F8CC.20400@panasas.com> <20120608215950.GQ30000@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from natasha.panasas.com ([67.152.220.90]:40012 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755270Ab2FKPmC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Jun 2012 11:42:02 -0400
In-Reply-To: <20120608215950.GQ30000@ZenIV.linux.org.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 06/09/2012 12:59 AM, Al Viro wrote:

> On Wed, May 30, 2012 at 01:39:08PM +0300, Boaz Harrosh wrote:
>> +	ret = d_splice_alias(inode, dentry);
>> +	if (IS_ERR(ret)) {
>> +		EXOFS_ERR("directory #%lu corrupted", dir->i_ino);
>> +		iput(inode);
> 
> That's a bloody wrong interface.  If you add d_splice_alias() failure
> exit like that, do iput() *there*.  Requiring every caller to deal with
> failure exit cleanups like that is the recipe for recurring bugs.
> Don't Do That.


I agree. Thanks.

My point being that please any changes made to ext2, in this area please also
apply to exofs, since it is just another copy/paste of ext2. I'll ACK any
which way you guys decide to properly go with, as part of the VFS changes.

Thanks
Boaz
