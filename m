From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: torrent hash failures since 3.9.0-rc1
Date: Tue, 12 Mar 2013 09:28:11 -0400
Message-ID: <20130312132811.GI18595@thunk.org>
References: <20130311204625.GA433@x4>
 <20130311211833.GC15478@thunk.org>
 <20130311213837.GA438@x4>
 <20130311231227.GA319@x4>
 <20130312030057.GA6142@gmail.com>
 <20130312033054.GB18595@thunk.org>
 <20130312061624.GA436@x4>
 <20130312064449.GA8806@gmail.com>
 <20130312064810.GA426@x4>
 <20130312071606.GA8900@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Markus Trippelsdorf <markus@trippelsdorf.de>,
	Dave Jones <davej@redhat.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52839 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868Ab3CLN2S (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Mar 2013 09:28:18 -0400
Content-Disposition: inline
In-Reply-To: <20130312071606.GA8900@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 12, 2013 at 03:16:06PM +0800, Zheng Liu wrote:
> 
> Ted, I am wandering if we need to Cc this patch to stable kernel.  We
> don't receive any report to complaint it, though, but it is worth
> backporting it I think.

I'll check, bu I suspect it will require an explicit backport; it's
not going to apply cleanly automatically, will it?  

(i.e., if we include cc: stable@vger.kernel.org, are there some
prerequisite patches that will also have to be backported, and/or we
will need manually fix up patch conflicts, right?)

						- Ted
