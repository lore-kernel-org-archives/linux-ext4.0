From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix extent tree corruption that incurred by hole
 punch [V2]
Date: Thu, 20 Dec 2012 18:42:29 -0500
Message-ID: <20121220234229.GA22476@thunk.org>
References: <CAJSVwFM3vq9wsq0Mn5L1bh-WHoP1g3VMJAOg_ruavZFednsjVw@mail.gmail.com>
 <20121220053914.GB22145@thunk.org>
 <CAJSVwFPWbipgN=GutTdy57dHDb+DjnDivwRwYY93LRB8cvCu3g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ashish Sangwan <ashishsangwan2@gmail.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Forrest Liu <forrestl@synology.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:39627 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751555Ab2LTXmf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Dec 2012 18:42:35 -0500
Content-Disposition: inline
In-Reply-To: <CAJSVwFPWbipgN=GutTdy57dHDb+DjnDivwRwYY93LRB8cvCu3g@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 20, 2012 at 11:11:28PM +0800, Forrest Liu wrote:
> Hi Ted,
>    I will help to find out the problem in e2fsck.

Thanks for the offer, but I think I've found the problem and have the
following set of patches (versus the maint branch) to fix the problem.

						- Ted

