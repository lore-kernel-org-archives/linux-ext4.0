From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: Strange "rm -fr" issue
Date: Mon, 30 Dec 2013 09:10:14 +0100
Message-ID: <20131230081014.GA392@x4>
References: <20131229142406.GA393@x4>
 <59DA49F7-C44D-4C50-A9C8-55C0BB78F29C@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ud10.udmedia.de ([194.117.254.50]:58149 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857Ab3L3IKR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Dec 2013 03:10:17 -0500
Content-Disposition: inline
In-Reply-To: <59DA49F7-C44D-4C50-A9C8-55C0BB78F29C@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2013.12.29 at 11:47 -0700, Andreas Dilger wrote:
> If you are able to reproduce this issue (extract the same tree and
> then try "rm -fr" again) please run this under strace to see how many
> entries are returned during readdir from the kernel.
> 
> It could be a bug in the ext4 readdir code or it could be a bug in
> glibc or coreutils. 

Unfortunately the issue is not reproducible and therefore impossible to
debug. I just thought to post it nevertheless, just to see if perhaps
someone else encounters the same problem.

-- 
Markus
