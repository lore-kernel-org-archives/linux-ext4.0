From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH -mm] ext4: remove unused code from ext4_find_entry()
Date: Thu, 13 Dec 2007 20:03:03 -0500
Message-ID: <20071214010303.GA17344@thunk.org>
References: <200712122246.41284.m.kozlowski@tuxland.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: sct@redhat.com, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:60950 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935358AbXLNBDq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Dec 2007 20:03:46 -0500
Content-Disposition: inline
In-Reply-To: <200712122246.41284.m.kozlowski@tuxland.pl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 12, 2007 at 10:46:40PM +0100, Mariusz Kozlowski wrote:
> Hello,
> 
> 	The unused code found in ext3_find_entry() is also present (and still unused)
> in the ext4_find_entry() code. This patch removes it. Compile tested only.
> 
> Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Thanks, this will be in the next ext4 patchset.

	     	     	    	 - Ted
