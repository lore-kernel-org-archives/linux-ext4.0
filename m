From: Andreas Dilger <aedilger@gmail.com>
Subject: Re: [PATCH 01/37] e2fsprogs: Read and write full-sized inodes
Date: Sun, 4 Sep 2011 11:40:04 -0600
Message-ID: <56D52981-70CD-4A60-B8C4-01A22F5A5433@gmail.com>
References: <20110901003509.1176.51159.stgit@elm3c44.beaverton.ibm.com> <20110901003517.1176.46651.stgit@elm3c44.beaverton.ibm.com> <0151C905-AE23-4729-92B9-9EAFA44A92FD@dilger.ca> <20110904140419.GE3461@thunk.org>
Mime-Version: 1.0 (iPhone Mail 8L1)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Andreas Dilger <adilger@dilger.ca>,
	"Darrick J. Wong" <djwong@us.ibm.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	AmirGoldstein <amir73il@gmail.com>,
	Andi Kleen <andi@firstfloor.org>, MingmingCao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Coly Li <colyli@gmail.com>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:44947 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025Ab1IDRj3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 4 Sep 2011 13:39:29 -0400
Received: by gxk21 with SMTP id 21so2986607gxk.19
        for <linux-ext4@vger.kernel.org>; Sun, 04 Sep 2011 10:39:27 -0700 (PDT)
In-Reply-To: <20110904140419.GE3461@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-09-04, at 8:04 AM, Ted Ts'o <tytso@mit.edu> wrote:

> On Sat, Sep 03, 2011 at 12:05:39PM -0600, Andreas Dilger wrote:
>> Why not just get rid of ext2_inode and replace it with
>> ext2_inode_large?  Less change to the code, and less confusion for
>> developers.
> 
> struct ext2_inode_large is there to make sure we don't break ABI
> compatibility for shared libraries.

What about renaming ext2_inode to ext2_inode_{small,orig} and then (optionally) rename ext2_inode_large to ext2_inode?  That still avoids the code churn and continual risk of errors by developers using the small inode instead of the large inode, but keeps ABI compatibility. 

Cheers, Andreas