From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 00/36 v4] e2fsprogs: make e2fsprogs support inline data
Date: Mon, 17 Sep 2012 10:04:21 +0800
Message-ID: <20120917020421.GA16320@gmail.com>
References: <1343735309-30579-1-git-send-email-wenqing.lz@taobao.com>
 <20120917010645.GB15224@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39629 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068Ab2IQBxy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 16 Sep 2012 21:53:54 -0400
Received: by dady13 with SMTP id y13so561788dad.19
        for <linux-ext4@vger.kernel.org>; Sun, 16 Sep 2012 18:53:53 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20120917010645.GB15224@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Sep 16, 2012 at 09:06:45PM -0400, Theodore Ts'o wrote:
> On Tue, Jul 31, 2012 at 07:47:53PM +0800, Zheng Liu wrote:
> > Hi list,
> > 
> > Here is v4 for making e2fsprogs support inline data.
> 
> Hi Zheng,
> 
> I see Tao Ma has released a new set of kernel patches for inline data.
> 
> Is there an updated version for the e2fsprogs patches that I should
> use when testing/evaluating the inline data patch?

Hi Ted,

Sorry about that.  Now mke2fs, tune2fs, and e2fsck has an updated
version for e2fsprogs, but there still has some works to be done
in debugfs.  I could finish it at this week, and send it out.

Regards,
Zheng
