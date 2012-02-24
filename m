From: Andreas Dilger <adilger@whamcloud.com>
Subject: Re: [PATCH] libquota: don't include system quota.h header
Date: Fri, 24 Feb 2012 00:36:03 -0700
Message-ID: <52C82F38-1590-412B-98EE-2209A0DC8CD3@whamcloud.com>
References: <1330068686-35788-1-git-send-email-adilger@whamcloud.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44650 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282Ab2BXHgH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 24 Feb 2012 02:36:07 -0500
Received: by daed14 with SMTP id d14so2192955dae.19
        for <linux-ext4@vger.kernel.org>; Thu, 23 Feb 2012 23:36:07 -0800 (PST)
In-Reply-To: <1330068686-35788-1-git-send-email-adilger@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-02-24, at 12:31 AM, Andreas Dilger wrote:
> Don't use the system <sys/quota.h> header in mkquota.c, since there
> is a local e2fsprogs version of quota.h that has the desired quota
> constants, and avoids symbol conflict on OSX.

My bad, this included a bunch of changes that I wanted to put into
a separate patch.  I'll resend.

Cheers, Andreas
--
Andreas Dilger                       Whamcloud, Inc.
Principal Lustre Engineer            http://www.whamcloud.com/




