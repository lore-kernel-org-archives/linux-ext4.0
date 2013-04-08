From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] ext4: Return proper offset for '..' if inline_data
 enabled.
Date: Mon, 8 Apr 2013 13:11:52 -0400
Message-ID: <20130408171152.GC4598@thunk.org>
References: <1364466899-5599-1-git-send-email-tm@tao.ma>
 <20130328183332.GE16651@lenny.home.zabbo.net>
 <5154EFC2.4010800@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Zach Brown <zab@redhat.com>, linux-ext4@vger.kernel.org
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60343 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760040Ab3DHRL5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Apr 2013 13:11:57 -0400
Content-Disposition: inline
In-Reply-To: <5154EFC2.4010800@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 29, 2013 at 09:34:58AM +0800, Tao Ma wrote:
> My fault, will change it in the next version.

Hi Tao,

Will you be able to send out a new version of this patch series in the
next few days?  The next merge window will be coming fairly quickly.

Thanks,

					- Ted
