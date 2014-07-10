From: "Burton, Ross" <ross.burton@intel.com>
Subject: Re: [PATCH][V3] misc: copy extended attributes in populate_fs
Date: Thu, 10 Jul 2014 17:45:45 +0100
Message-ID: <CAJTo0LY7reaPnNwT=f8D7vEr0M55BFRro8pBCfT_6ugr7uP=ww@mail.gmail.com>
References: <1405010389-25988-1-git-send-email-ross.burton@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qc0-f176.google.com ([209.85.216.176]:48011 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896AbaGJQqJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Jul 2014 12:46:09 -0400
Received: by mail-qc0-f176.google.com with SMTP id w7so8030369qcr.7
        for <linux-ext4@vger.kernel.org>; Thu, 10 Jul 2014 09:46:08 -0700 (PDT)
In-Reply-To: <1405010389-25988-1-git-send-email-ross.burton@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10 July 2014 17:39, Ross Burton <ross.burton@intel.com> wrote:
> +               retval = retval ? close_retval;

Not sure what happened here, V4 incoming.

Ross
