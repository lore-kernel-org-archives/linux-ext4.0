From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] libext2fs: reserve exclude bitmap fields in group
 descriptor
Date: Thu, 15 Sep 2011 09:16:06 -0400
Message-ID: <20110915131606.GG15782@thunk.org>
References: <CAOQ4uxjydz_6Upm5AUErHct2J0VKSN3-d-XT+Jn=q9BJFWQtaw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	"Darrick J. Wong" <djwong@us.ibm.com>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>, linux-ext4@vger.kernel.org,
	Coly Li <colyli@gmail.com>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:37253 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933125Ab1IONQQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Sep 2011 09:16:16 -0400
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjydz_6Upm5AUErHct2J0VKSN3-d-XT+Jn=q9BJFWQtaw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 15, 2011 at 09:50:20AM +0300, Amir Goldstein wrote:
> -#define EXT2_FEATURE_COMPAT_EXCLUDE_INODE      0x0080
> +/* #define EXT2_FEATURE_COMPAT_EXCLUDE_INODE   0x0080 not used */
> +#define EXT2_FEATURE_COMPAT_EXCLUDE_BITMAP     0x0100

Why this change?  Is it because you're already using 0x0100 in
shipping systems?

						- Ted

