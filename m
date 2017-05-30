From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [v4] tune2fs: fix BUGs of tuning project quota
Date: Mon, 29 May 2017 20:41:37 -0400
Message-ID: <20170530004137.2ibggsrn3c5sn3ci@thunk.org>
References: <20170425130307.29168-1-wshilong@ddn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, wshilong@ddn.com,
        andreas.dilger@intel.com, lixi@ddn.com, sihara@ddn.com
To: Wang shilong <wangshilong1991@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49580 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750896AbdE3Alo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 29 May 2017 20:41:44 -0400
Content-Disposition: inline
In-Reply-To: <20170425130307.29168-1-wshilong@ddn.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 25, 2017 at 09:03:07PM +0800, Wang shilong wrote:
> There are several problems for project quota enable/disable:
> tune2fs -O ^project did not work, because @clear_ok_features
> did not include @EXT4_FEATURE_RO_COMPAT_PROJECT.
> 
> update_feature_set() works for -O option, but tune2fs -Q prj/^prj
> did not work well, because function handle_quota_options()
> did not set and clear @EXT4_FEATURE_RO_COMPAT_PROJECT feature very well.
> 
> one warning message is removed, because with project feature
> enabled, quota feature will be enabled automatically.
> 
> Signed-off-by: Wang Shilong <wshilong@ddn.com>

Thanks, applied.

					- Ted
