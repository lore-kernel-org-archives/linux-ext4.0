From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] libext2fs: reserve exclude bitmap fields in group
 descriptor
Date: Thu, 15 Sep 2011 17:57:59 -0400
Message-ID: <20110915215759.GG28181@thunk.org>
References: <CAOQ4uxjydz_6Upm5AUErHct2J0VKSN3-d-XT+Jn=q9BJFWQtaw@mail.gmail.com>
 <20110915131606.GG15782@thunk.org>
 <CAOQ4uxi0Xq89Va_ttTGJGZO342Mpa7HG03DhjhEsfHsubeso7A@mail.gmail.com>
 <F609F599-7286-4E6C-93B2-FEB9F9F5C077@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Amir Goldstein <amir73il@gmail.com>,
	"Darrick J. Wong" <djwong@us.ibm.com>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>, linux-ext4@vger.kernel.org,
	Coly Li <colyli@gmail.com>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:41928 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935187Ab1IOV6I (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Sep 2011 17:58:08 -0400
Content-Disposition: inline
In-Reply-To: <F609F599-7286-4E6C-93B2-FEB9F9F5C077@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 15, 2011 at 01:08:34PM -0600, Andreas Dilger wrote:
> In that light, why not continue to use an inode to map the exclude bitmap
> blocks, where the bitmap offset is (group * blocksize), instead of
> explicitly listing all of the blocks in the group descriptor?  This is
> how the buddy bitmap works in memory only, but it could be done for the
> exclude bitmap on disk.

I seem to recall the use of an inode to map the exclude bitmap added a
huge amount of complexity to the snapshot patches.  Amir, am I
remembering this correctly?

							- Ted
