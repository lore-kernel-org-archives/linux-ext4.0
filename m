From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 01/51] libext2fs: Read and write full size inodes
Date: Mon, 19 Dec 2011 09:46:31 -0800
Message-ID: <20111219174631.GF8233@tux1.beaverton.ibm.com>
References: <20111214011316.20947.13706.stgit@elm3c44.beaverton.ibm.com> <20111214011324.20947.25259.stgit@elm3c44.beaverton.ibm.com> <15FBE485-FC42-46A4-A2BE-9931A3B933A5@dilger.ca>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>, linux-ext4@vger.kernel.org,
	Coly Li <colyli@gmail.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:59674 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096Ab1LSRqf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Dec 2011 12:46:35 -0500
Received: from /spool/local
	by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Mon, 19 Dec 2011 10:46:35 -0700
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id pBJHkXG8158182
	for <linux-ext4@vger.kernel.org>; Mon, 19 Dec 2011 10:46:33 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id pBJHkW5Z024326
	for <linux-ext4@vger.kernel.org>; Mon, 19 Dec 2011 10:46:33 -0700
Content-Disposition: inline
In-Reply-To: <15FBE485-FC42-46A4-A2BE-9931A3B933A5@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 19, 2011 at 10:36:14AM +0100, Andreas Dilger wrote:
> <html><body class="ApplePlainTextBody" style="word-wrap: break-word;
<html mail snip>
> </span>}<br></blockquote><br>Instead of having an icache that is allocating
> temporary buffers<br>to handle the inode size mismatch, and then copying the
> inode data<br>into the icache each time, it makes more sense to use the
> allocated<br>buffers for the icache directly.<br><br>Cheers,
> Andreas<br><br><br><br><br><br></body></html>

Ok, I guess we can go for the larger reorganization of the code.  I was trying
not to read stuff into the cache before it was verified, but as long as we take
care of the cache bookkeeping it's fine.

--D

