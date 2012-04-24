From: Andi Kleen <andi@firstfloor.org>
Subject: Re: Ext4 Workshop Draft Minutes
Date: Tue, 24 Apr 2012 05:22:35 -0700
Message-ID: <m2397tnwtw.fsf@firstfloor.org>
References: <E1SMKmr-0002jQ-4N@tytso-glaptop.cam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:43330 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751854Ab2DXMWh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Apr 2012 08:22:37 -0400
In-Reply-To: <E1SMKmr-0002jQ-4N@tytso-glaptop.cam.corp.google.com> (Theodore
	Ts'o's message of "Mon, 23 Apr 2012 11:02:45 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

"Theodore Ts'o" <tytso@mit.edu> writes:
> address why Tao Bao is interested in changing the extent format to
> break the 2**15 block extent length limitation.  (There are other
> advantages that would accrue to creating a V2 extent tree format, such

It would be good to reserve some space for data checksums in future
extent formats.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
