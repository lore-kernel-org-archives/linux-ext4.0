From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [RFC] enable ext4 allocate blocks across group boundary
Date: Wed, 14 Mar 2012 20:34:10 -0600
Message-ID: <B931D1EA-1D19-4054-9427-F1212D2837A7@dilger.ca>
References: <CAGBYx2aETBVb2hMyEBC91meRwr_Z+cnMNwF+ZBU4nk1PdedygA@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:33203 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070Ab2COCds (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 14 Mar 2012 22:33:48 -0400
In-Reply-To: <CAGBYx2aETBVb2hMyEBC91meRwr_Z+cnMNwF+ZBU4nk1PdedygA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-03-14, at 6:52 PM, Yongqiang Yang wrote:
> Here is a proposal to enable ext4 allocate blocks across group boundary.
> 
> Now ext4 allocates blocks within a single block group by locking a
> group.   Flex_bg puts metadata blocks together, as a result,it
> enlarges contiguous blocks.  So we can enable ext4 allocate blocks
> within a flex block group. Inode allocation takes group lock as block
> allocation,  I am not sure if we should allocate inode within single
> group as before.
> 
> If we do this, then the new group boundary will be flex block group
> boundary.  I am not sure if it is worth doing.

The maximum extent size is the same as a single block group, so there
is relatively little value in doing this, IMHO.

Cheers, Andreas





