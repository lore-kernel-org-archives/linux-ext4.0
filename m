From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 7/9] ext4: Format neatening for easier grep
Date: Sun, 18 Mar 2012 21:30:40 -0700
Message-ID: <1332131440.23125.47.camel@joe2Laptop>
References: <cover.1331856299.git.joe@perches.com>
	 <0166250eda6104d5a062dac44e7ed449369b2a5a.1331856300.git.joe@perches.com>
	 <20120319042629.GK31682@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:49734 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753904Ab2CSEao (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Mar 2012 00:30:44 -0400
In-Reply-To: <20120319042629.GK31682@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2012-03-19 at 00:26 -0400, Ted Ts'o wrote:
> I've removed the terminating \n from ext4_msg and ext4_error (from
> another patch) and created a separate patch just for that.

If you did the patch correctly to avoid possible
message interleaving by adding '\n' to all the
ext4_msg and ext4_error uses, the patch would
be just about the same size as the patch I sent.


