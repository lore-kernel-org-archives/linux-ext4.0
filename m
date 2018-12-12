Return-Path: <SRS0=RWfY=OV=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52332 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726211AbeLLCzd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 11 Dec 2018 21:55:33 -0500
Date: Tue, 11 Dec 2018 21:55:25 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Krzysztof Kozlowski <krzk@kernel.org>,
        Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>,
        Eric Biggers <ebiggers@kernel.org>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-fscrypt@vger.kernel.org
Subject: Re: [BUG BISECT next] Files cannot be opened after "fsverity: Move
 verity status check to fsverity_file_open"
Message-ID: <20181212025525.GF4464@thunk.org>
References: <CAJKOXPdNS+Qs6t1GwrgYhWT5EbtORJwYMzSrDPf8oAxv7ndNBg@mail.gmail.com>
 <20181211222721.GC4464@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181211222721.GC4464@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The fscrypt.git tree has been updated with for the problem.  Apologies
for not testing the !CONFIG_FS_VERITY case.

							- Ted
