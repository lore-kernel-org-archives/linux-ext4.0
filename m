From: Jan Kara <jack@suse.cz>
Subject: Re: generic/232 test failures on 4.14-rc1
Date: Wed, 27 Sep 2017 11:34:39 +0200
Message-ID: <20170927093439.GB25746@quack2.suse.cz>
References: <20170921154846.re5vcyn3bugdbie5@localhost.localdomain>
 <20170925135946.GB8004@quack2.suse.cz>
 <20170926125831.GC13627@quack2.suse.cz>
 <20170926214152.tfyxaardy7rsn6md@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47204 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752560AbdI0JmF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 27 Sep 2017 05:42:05 -0400
Content-Disposition: inline
In-Reply-To: <20170926214152.tfyxaardy7rsn6md@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 26-09-17 17:41:52, Eric Whitney wrote:
> Hi Honza:
> 
> That patch works for me - 100 out of 100 trials of generic/232 passed
> successfully running a modified 4.14-rc1 kernel on kvm-xfstests' ext4 4k
> test configuration.
> 
> Tested-by: Eric Whitney <enwlinux@gmail.com>

Thanks for testing!

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
