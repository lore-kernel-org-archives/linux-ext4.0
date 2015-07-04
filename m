From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH 2/2] ext4: reserve hole in the migration to non-extent
 based file
Date: Sun, 5 Jul 2015 00:05:39 +0800
Message-ID: <20150704160539.GE21206@dhcp-13-216.nay.redhat.com>
References: <1435942311-2337-1-git-send-email-guaneryu@gmail.com>
 <1435942311-2337-3-git-send-email-guaneryu@gmail.com>
 <20150704043329.GS9456@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:33470 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbbGEKSK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 5 Jul 2015 06:18:10 -0400
Received: by wgck11 with SMTP id k11so118056209wgc.0
        for <linux-ext4@vger.kernel.org>; Sun, 05 Jul 2015 03:18:08 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20150704043329.GS9456@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jul 04, 2015 at 12:33:29AM -0400, Theodore Ts'o wrote:
> Applied, although I reworded the commit description a little:
> 
> ext4: correctly migrate a file with a hole at the beginning
> 
> Currently ext4_ind_migrate() doesn't correctly handle a file which
> contains a hole at the beginning of the file.  This caused the migration
> to be done incorrectly, and then if there is a subsequent following
> delayed allocation write to the "hole", this would reclaim the same data
> blocks again and results in fs corruption.

Clearly better than my wording, thanks!

Eryu
