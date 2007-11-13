From: Karel Zak <kzak@redhat.com>
Subject: Re: [PATCH 01/13][e2fsprogs] Add initial checksum support.
Date: Wed, 14 Nov 2007 00:04:45 +0100
Message-ID: <20071113230445.GF22480@petra.dvoda.cz>
References: <20071011191559.4599.69332.stgit@gara> <20071011191605.4599.34407.stgit@gara> <20071015024605.GA21216@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Jose R. Santos" <jrs@us.ibm.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:46244 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759592AbXKMXGu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 13 Nov 2007 18:06:50 -0500
Content-Disposition: inline
In-Reply-To: <20071015024605.GA21216@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Oct 14, 2007 at 10:46:05PM -0400, Theodore Tso wrote:
> In crc16.h, this patch assumes that linux/types.h defines uint16_t.  
> 
> There are a couple of problems with this.  
> 
> #1) linux/types.h is non-portable, not only does it not exist on
>  non-Linux systems, apparently on Ubuntu it's not always defining
>  uint16_t.  On my Ubuntu gutsy system, it doesn't always get defined.

 I hope and believe uint16_t is everywhere -- ISO C99: 7.18 Integer
 types <stdint.h>.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
