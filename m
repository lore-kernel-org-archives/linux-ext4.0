From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Fix missing iput for root inode in case of all
 failed mount paths.
Date: Mon, 7 Feb 2011 18:23:43 -0500
Message-ID: <20110207232343.GA26289@thunk.org>
References: <AANLkTik8jweuA_kDfzY7H=wP-ikSSwdf-FF1NX09DDCT@mail.gmail.com>
 <032DF412-6B37-4EB7-A687-8216CB1E2BAB@dilger.ca>
 <AANLkTiku46htAypEN7QNN=UZuRETKGnHJQ8cxt3kYPJg@mail.gmail.com>
 <AANLkTim0XZe2=3AWw4Ydb8F7BQGCf+=FyjKoyadc+3yw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
	ext4 <linux-ext4@vger.kernel.org>
To: Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:36903 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755092Ab1BGXXs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Feb 2011 18:23:48 -0500
Content-Disposition: inline
In-Reply-To: <AANLkTim0XZe2=3AWw4Ydb8F7BQGCf+=FyjKoyadc+3yw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jan 29, 2011 at 09:40:34PM -0800, Manish Katiyar wrote:
> 
> Any feedback on this ?

The patch looks good, but it doesn't fix bug #26752.

The root cause of that bug is the fact that ext4_sync_fs() and
ext4_put_super() assumes that sbi has been initialized.

		 	      	      - Ted
