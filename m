From: Johannes Bauer <dfnsonfsduifb@gmx.de>
Subject: Re: Frequent ext4 oopses with 4.4.0 on Intel NUC6i3SYB
Date: Tue, 4 Oct 2016 19:32:14 +0200
Message-ID: <2b7d6bd6-7d16-3c60-1b84-a172ba378402@gmx.de>
References: <fcb653b9-cd9e-5cec-1036-4b4c9e1d3e7b@gmx.de>
 <20161004084136.GD17515@quack2.suse.cz>
 <90dfe18f-9fe7-819d-c410-cdd160644ab7@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-mm@kvack.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:51293 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753737AbcJDRcX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 4 Oct 2016 13:32:23 -0400
In-Reply-To: <90dfe18f-9fe7-819d-c410-cdd160644ab7@gmx.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 04.10.2016 18:50, Johannes Bauer wrote:

> Uhh, that sounds painful. So I'm following Ted's advice and building
> myself a 4.8 as we speak.

Damn bad idea to build on the instable target. Lots of gcc segfaults and
weird stuff, even without a kernel panic. The system appears to be
instable as hell. Wonder how it can even run and how much of the root fs
is already corrupted :-(

Rebuilding 4.8 on a different host.

Cheers,
Johannes
