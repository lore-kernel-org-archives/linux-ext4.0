From: Carlos Carvalho <carlos@fisica.ufpr.br>
Subject: Re: how to quotacheck with the new quota implementation (hidden
 inode)?
Date: Thu, 31 Jan 2013 17:01:06 -0200
Message-ID: <20746.49010.569691.44452@fisica.ufpr.br>
References: <20730.1955.395545.141779@fisica.ufpr.br>
	<20130121054741.GB321@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, adityakali@google.com, jack@suse.cz
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fisica.ufpr.br ([200.17.209.129]:41751 "EHLO fisica.ufpr.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753950Ab3AaTBI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 31 Jan 2013 14:01:08 -0500
In-Reply-To: <20130121054741.GB321@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've just seen that the new quota implementation doesn't stop writes
after the limit has been reached. This means it's useless... The
machine is running 3.7.3.

To check: dd if=/dev/zero of=anything bs=2M

It'll never stop. I've gone over twice my limit to be sure.
