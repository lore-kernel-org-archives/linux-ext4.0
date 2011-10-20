From: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: ext4_ext_insert_index error
Date: Thu, 20 Oct 2011 11:48:11 +0800
Message-ID: <20111020034811.GA26265@localhost>
References: <20111020012353.GA8653@localhost>
 <4E9F7F1E.8070809@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:61775 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751744Ab1JTDsR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Oct 2011 23:48:17 -0400
Content-Disposition: inline
In-Reply-To: <4E9F7F1E.8070809@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> > I got these errors when switch the kernel from 3.1-rc8 to linux-next.  Commit
> > 4fd30c0330ba951 looks most likely the culprit in the linux-next change set.
> This should be already fixed in Ted's tree. Please check whether the fix
> works.
> http://comments.gmane.org/gmane.comp.file-systems.ext4/28575

I confirmed that the patch fixed the issue. Thanks!

wfg@bee /export/writeback% ./compare.rb thresh*/*ioless-full-next*+ thresh*/*-ioless-full-ext4*+ 
3.1.0-rc9-ioless-full-next-20111014+  3.1.0-rc9-ioless-full-ext4-ext-index-fix-next-20111014+  
------------------------  ------------------------  
                   31.82        +0.9%        32.12  thresh=1M/ext4-10dd-4k-8p-4096M-1M:10-X
                   52.33        -2.0%        51.31  thresh=1M/ext4-1dd-4k-8p-4096M-1M:10-X
                   19.05      +146.8%        47.01  thresh=1M/ext4-2dd-4k-8p-4096M-1M:10-X
                   35.78        +0.2%        35.84  thresh=8M/ext4-10dd-4k-8p-4096M-8M:10-X
                   55.29        +1.0%        55.85  thresh=8M/ext4-1dd-4k-8p-4096M-8M:10-X
                   18.85      +171.2%        51.12  thresh=8M/ext4-2dd-4k-8p-4096M-8M:10-X
                  213.11       +28.2%       273.25  TOTAL write_bw
wfg@bee /export/writeback% g -l ext4_ext_insert_index thresh*/*-ioless-full-ext4*+/dmesg
(no errors found)

Thanks,
Fengguang

