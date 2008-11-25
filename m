From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix build warning
Date: Tue, 25 Nov 2008 17:26:17 -0500
Message-ID: <20081125222617.GI525@mit.edu>
References: <20081123104006.GA13392@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:50994 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751325AbYKYW0T (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Nov 2008 17:26:19 -0500
Content-Disposition: inline
In-Reply-To: <20081123104006.GA13392@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Nov 23, 2008 at 06:40:06PM +0800, Wu Fengguang wrote:
> Replace `if' with `goto' to assure gcc that ix has been initialized.

It's really sad that we need to do this.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

						- Ted
