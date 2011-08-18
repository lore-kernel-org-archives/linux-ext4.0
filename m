From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [RFC] ext4 metadata checksumming design
Date: Thu, 18 Aug 2011 00:16:00 -0600
Message-ID: <EB5DDA28-421A-4C67-817C-74F9B9643351@dilger.ca>
References: <20110817032519.GN20655@tux1.beaverton.ibm.com>
Mime-Version: 1.0 (iPhone Mail 8L1)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Joel Becker <jlbec@evilplan.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Coly Li <colyli@gmail.com>, Andi Kleen <andi@firstfloor.org>
To: "djwong@us.ibm.com" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from shawmail.shawcable.com ([64.59.128.220]:15211 "EHLO
	mail.shawcable.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429Ab1HRGPZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Aug 2011 02:15:25 -0400
In-Reply-To: <20110817032519.GN20655@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-08-16, at 9:25 PM, "Darrick J. Wong" <djwong@us.ibm.com> wrote:
> - Extended attribute blocks that are stored in the inode table -- the h_magic
>  field is written by the kernel, but neither the kernel nor e2fsprogs ever
>  actually read this field.  The field could be reused to checksum the extra
>  space since (as far as I can tell) EAs are the only user of that empty space.

I haven't had a chance to read the document you wrote, but wanted to comment on xattrs. There is a hash field for each xattr (including internal xattrs), and one for the external xattr blocks that can be used to validate the xattr value.

In addition to the hash for the in-inode xattrs, the inode hash itself would serve to validate the xattr values. 

I have a patch for e2fsprogs that checks the xattr hash for in-inode xattrs (currently it is always 0).

> Please have a look at the design document and please feel free to suggest any
> changes.

Hopefully soon. 

Cheers, Andreas