From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] ext4:Allow an active handle to be started when
 freezing.
Date: Thu, 7 Apr 2011 13:18:50 -0400
Message-ID: <20110407171850.GA25734@thunk.org>
References: <BANLkTinuQ5Z1LSS+-s8+EqQ4aWSMqqiU2w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Andreas Dilger <adilger@dilger.ca>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45498 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753569Ab1DGRTB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 7 Apr 2011 13:19:01 -0400
Content-Disposition: inline
In-Reply-To: <BANLkTinuQ5Z1LSS+-s8+EqQ4aWSMqqiU2w@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks!  I've added your patch to the ext4 patch queue.

I realize that there are some longer term issues with respect to
freezing that Jan is worried about, but in the mean time this will
make freezing more reliable.

						- Ted
