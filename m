Return-Path: <SRS0=RWfY=OV=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from muru.com ([72.249.23.125]:57620 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726201AbeLLBhj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 11 Dec 2018 20:37:39 -0500
Date: Tue, 11 Dec 2018 17:37:35 -0800
From: Tony Lindgren <tony@atomide.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-fscrypt@vger.kernel.org, "Theodore Y . Ts'o" <tytso@mit.edu>,
        Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        linux-ext4@vger.kernel.org, Kirill Tkhai <ktkhai@virtuozzo.com>
Subject: Re: [PATCH 0/2] fs-verity: fix !CONFIG_FS_VERITY case
Message-ID: <20181212013735.GB39861@atomide.com>
References: <20181211224651.112510-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181211224651.112510-1-ebiggers@kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Eric Biggers <ebiggers@kernel.org> [181211 22:48]:
> Replace the two patches that broken the !CONFIG_FS_VERITY case with
> fixed verisons.

Thanks for fixing these quickly. Mounting ext4 rootfs on SD card
now works again for me with these:

Tested-by: Tony Lindgren <tony@atomide.com>
