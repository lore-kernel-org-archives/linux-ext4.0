From: "Riccardo S." <sirmy15@gmail.com>
Subject: Re: [PATCH 0/3] Improve kobject handling in fs/ext4
Date: Tue, 28 Nov 2017 11:50:11 +0100
Message-ID: <20171128105011.GB83442@rschirone-mbp.local>
References: <20171127231801.27652-1-sirmy15@gmail.com>
 <20171128035105.lec6u6y4p3qwgjde@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        gregkh@linuxfoundation.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:44561 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933699AbdK1KuT (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Nov 2017 05:50:19 -0500
Received: by mail-wm0-f66.google.com with SMTP id r68so871411wmr.3
        for <linux-ext4@vger.kernel.org>; Tue, 28 Nov 2017 02:50:18 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20171128035105.lec6u6y4p3qwgjde@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/27, Theodore Ts'o wrote:
> On Tue, Nov 28, 2017 at 12:17:58AM +0100, Riccardo Schirone wrote:
> > This patch tries to correctly use kobjects in fs/ext4. In particular it
> > allocates kobjects/ksets dynamically, instead of statically, and improve
> > error handling in case kobject_* functions fail.
> 
> I don't see the point of allocating the kobjects in question
> dynamically?  There is only one of them, so why not use static
> allocation?  What is "incorrect" about not doing dynamically allocated
> kobjects/ksets?
> 
> Regards,
> 
> 						- Ted

According to Documentation/kobject.txt that's how they should be
allocated.  The reason for this being they are dynamic objects, so you
don't really know what is their life time. Other parts of the kernel
could get a reference to those kobjects (since they are registered in
the system) and it's not said the module is the last one to access them.

If you declare them statically, what would happen when you remove the
module that statically defines them? What if there's still someone
holding a reference to one of those kobjects?

Regards,


Riccardo
