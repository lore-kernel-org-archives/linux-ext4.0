From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [2/2] ext4: Provide separate operations for sysfs feature files
Date: Thu, 11 Sep 2014 11:28:47 -0400
Message-ID: <20140911152847.GA19019@thunk.org>
References: <1410262340-13713-2-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51192 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054AbaIKP2x (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Sep 2014 11:28:53 -0400
Content-Disposition: inline
In-Reply-To: <1410262340-13713-2-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 09, 2014 at 01:32:20PM +0200, Lukas Czerner wrote:
> Currently sysfs feature files uses ext4_attr_ops as the file operations
> to show/store data. However the feature files is not supposed to contain
> any data at all, the sole existence of the file means that the module
> support the feature. Moreover, none of the sysfs feature attributes
> actually register show/store functions so that would not be a problem.
> 
> However if a sysfs feature attribute register a show or store function
> we might be in trouble because the kobject in this case is _not_ embedded
> in the ext4_sb_info structure as ext4_attr_show/store expect.
> 
> So just to be safe, provide separate empty sysfs_ops to use in
> ext4_feat_ktype. This might safe us from potential problems in the
> future. As a bonus we can "store" something more descriptive than
> nothing in the files, so let it contain "enabled" to make it clear that
> the feature is really present in the module.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Applied, thanks.

					- Ted
