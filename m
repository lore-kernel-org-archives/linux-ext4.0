From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: xfstest ext4 'utility required' run stop
Date: Thu, 13 Jun 2013 09:59:55 -0400
Message-ID: <20130613135955.GD13429@thunk.org>
References: <20130613134347.300880@gmx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Zheng Liu <gnehzuil.liu@gmail.com>, linux-ext4@vger.kernel.org
To: jon ernst <jonernst07@gmx.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57669 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757363Ab3FMOAD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Jun 2013 10:00:03 -0400
Content-Disposition: inline
In-Reply-To: <20130613134347.300880@gmx.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 13, 2013 at 09:43:46AM -0400, jon ernst wrote:
> I built xfstest from latest code. I also built fio from latest code base.
> Thanks for your help!

Dmitry's advice is on-target.  Do you have:

#define CONFIG_LINUX_EXT4_MOVE_EXTENT

defined in fio/config-host.h?

						- Ted
