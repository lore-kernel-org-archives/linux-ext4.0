From: Daniel Phillips <phillips@phunq.net>
Subject: Re: [PATCH,RFC] ext3: Add support for non-native signed/unsigned htree hash algorithms
Date: Tue, 21 Oct 2008 00:16:23 -0700
Message-ID: <200810210016.23137.phillips@phunq.net>
References: <1224560624-9691-1-git-send-email-tytso@mit.edu> <1224560624-9691-2-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from phunq.net ([64.81.85.152]:37773 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750721AbYJUHQd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 21 Oct 2008 03:16:33 -0400
In-Reply-To: <1224560624-9691-2-git-send-email-tytso@mit.edu>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Monday 20 October 2008 20:43, Theodore Ts'o wrote:
> The original ext3 hash algorithms assumed that variables of type char
> were signed, as God and K&R intended.

But I didn't.  Sorry about that, it was a dumb oversight.

Regards,

Daniel
