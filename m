From: Jan Kara <jack@suse.cz>
Subject: Re: xfstests failures in v3.13-rc7
Date: Tue, 7 Jan 2014 13:01:09 +0100
Message-ID: <20140107120109.GA16640@quack.suse.cz>
References: <1389063428.2169.12.camel@ancientdefender.lm.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"matthew@wil.cx" <matthew@wil.cx>
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57638 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750747AbaAGMBM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Jan 2014 07:01:12 -0500
Content-Disposition: inline
In-Reply-To: <1389063428.2169.12.camel@ancientdefender.lm.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 07-01-14 02:57:13, Verma, Vishal L wrote:
> Hi,
> 
> I have been running xfstests with ext4 on a ramdisk (brd), and noticed a
> few tests were failing with an inconsistent file system at the end of
> the test.
> 
> The following fail for v3.13-rc7:
> generic/013
> generic/083
> generic/269
> generic/321 (this one is not inconsistent fs, see log)
> generic/322
> 
> The output of xfstests for these failures is also attached.
> 
> It looks like generic/013 should be resolved by:
> http://thread.gmane.org/gmane.comp.file-systems.ext4/42032
> Are any of the others known failures, especially for brd?
  Are you using any special mkfs options? Because the referenced patch
should fix only a problem if you are using bigalloc feature...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
