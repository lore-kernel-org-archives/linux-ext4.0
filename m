From: "=?GBK?B?wfXhvyjOxMfkKQ==?=" <wenqing.lz@alibaba-inc.com>
Subject: Re: Incompat change: giving inline data four more bytes?
Date: Thu, 28 May 2015 10:48:21 +0800
Message-ID: <76A8C7EE-5066-43CB-B87E-007826C407C5@alibaba-inc.com>
References: <20150527002543.GC830@birch.djwong.org>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2098\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4" <linux-ext4@vger.kernel.org>, <tm@tao.ma>,
	<gnehzuil.liu@gmail.com>,
	"=?GBK?B?wfXhvyjOxMfkKQ==?=" <wenqing.lz@taobao.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail113-250.mail.alibaba.com ([205.204.113.250]:37828 "EHLO
	us-alimail-mta1.hst.scl.en.alidc.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750812AbbE1CtW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 May 2015 22:49:22 -0400
In-Reply-To: <20150527002543.GC830@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Darrick,

Yes, The Alibaba uses inline data feature in our system.  We are fine
with this incompatiable change, and we will handle this change by
ourselves.

Regards,
                                                - Zheng

> On May 27, 2015, at 8:25 AM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> 
> Hi all,
> 
> [echoing a conversation on today's concall]
> 
> I'm just curious -- is there a reason why the inline data feature stores the
> data with an xattr of [EXT4_XATTR_INDEX_SYSTEM, "data"] instead of creating a
> new index value to cover "system.data"?  That would allow us to set the namelen
> to zero, which fetches us an extra 4 bytes for inline data storage:
> 
> struct ext4_xattr_info i = {
> 	.name_index = EXT4_XATTR_INDEX_SYSTEM,
> 	.name = EXT4_XATTR_SYSTEM_DATA,
> };
> 
> becomes
> 
> struct ext4_xattr_info i = {
> 	.name_index = EXT4_XATTR_INDEX_SYSTEM_DATA,
> 	.name = "",
> };
> 
> The hard part, of course, is that inline.c is hardcoded to the xattr key that
> it uses (instead of using "system.data" and letting the key resolver figure it
> out), which makes it harder to switch to the optimized encoding.
> 
> On the other hand, since inline data isn't in a released e2fsprogs yet, there
> still aren't very many users of it, so if we're going to make the change we
> ought to do so now while it's still fairly inexpensive to do so.
> 
> The biggest problem of course is retrofitting anyone who's been using this
> feature, since old kernels require the larger encoding.  So, who are those
> users, and are you willing to trade some breakage for four more bytes?
> 
> It shouldn't be that hard to teach the kernel to look for either encoding of
> the xattr name.  e2fsprogs uses the full string and lets the xattr code
> figure out the encoding.
> 
> --D

