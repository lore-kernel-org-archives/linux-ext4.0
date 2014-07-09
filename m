From: "Burton, Ross" <ross.burton@intel.com>
Subject: Re: [PATCH][V2] misc: copy extended attributes in populate_fs
Date: Wed, 9 Jul 2014 17:30:50 +0100
Message-ID: <CAJTo0LZ1wnekZieJBThKviZBMxEB16tfQ=tYMA5xK7E4uo4Q8g@mail.gmail.com>
References: <1404156137-31473-1-git-send-email-ross.burton@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Darren Hart <dvhart@linux.intel.com>,
	Robert Yang <liezhi.yang@windriver.com>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yk0-f173.google.com ([209.85.160.173]:55285 "EHLO
	mail-yk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276AbaGIQbL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Jul 2014 12:31:11 -0400
Received: by mail-yk0-f173.google.com with SMTP id 142so2916471ykq.32
        for <linux-ext4@vger.kernel.org>; Wed, 09 Jul 2014 09:31:10 -0700 (PDT)
In-Reply-To: <1404156137-31473-1-git-send-email-ross.burton@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 30 June 2014 20:22, Ross Burton <ross.burton@intel.com> wrote:
> When creating a file system using a source directory, also copy any extended
> attributes that have been set.
>
> Signed-off-by: Ross Burton <ross.burton@intel.com>

Ping?

Ross
