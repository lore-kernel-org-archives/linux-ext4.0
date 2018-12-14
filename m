Return-Path: <SRS0=b4XO=OX=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35226 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726480AbeLNDL4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 13 Dec 2018 22:11:56 -0500
Date: Thu, 13 Dec 2018 22:11:54 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Cc: linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca
Subject: Re: [PATCH 2/2] debugfs: output large directory size
Message-ID: <20181214031154.GB20880@thunk.org>
References: <20181213213156.44773-1-artem.blagodarenko@gmail.com>
 <20181213213156.44773-2-artem.blagodarenko@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181213213156.44773-2-artem.blagodarenko@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 14, 2018 at 12:31:56AM +0300, Artem Blagodarenko wrote:
> Use hight part of directory size in debugfs output.

"high", not "hight".  Also, it would be better if the discription
explained the context of this being needed for directories with the
largedir feature being enabled.

Thanks,

					- Ted
