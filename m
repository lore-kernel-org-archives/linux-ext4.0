From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: Set file system to read-only by I/O error threshold
Date: Tue, 21 Jun 2011 09:58:45 -0600
Message-ID: <24822739-C817-40BC-BBE8-18FD93F54E42@dilger.ca>
References: <1308312516-14252-1-git-send-email-wangshaoyan.pt@taobao.com> <alpine.LFD.2.00.1106181015180.4602@dhcp-27-109.brq.redhat.com> <BANLkTim-1FfCZAm449zp5PpApbq027HGwYhoZBF0soZpJon9tQ@mail.gmail.com> <20110621144856.GH32133@thunk.org>
Mime-Version: 1.0 (iPhone Mail 8J2)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Lukas Czerner <lczerner@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from shawmail.shawcable.com ([64.59.128.220]:19999 "EHLO
	mail.shawcable.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929Ab1FUP6h (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Jun 2011 11:58:37 -0400
In-Reply-To: <20110621144856.GH32133@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-06-21, at 8:48 AM, Ted Ts'o <tytso@mit.edu> wrote:
> In fact I've recently written up a plan to turn metadata errors into
> EIO's, without bringing down the entire file system as containing
> errors, to make the file system more resiliant to I/O errors --- the
> exact reverse of what you're trying to do.

Could you share that plan on the list?  

Cheers, Andreas
