From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] ext3/jbd: Avoid WARN() messages when failing to write
 to the superblock
Date: Sat, 20 Sep 2008 19:14:42 -0700
Message-ID: <20080920191442.311c043e@infradead.org>
References: <1221946547-9873-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: akpm@linux-foundation.org,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:43543 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309AbYIUCOm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 20 Sep 2008 22:14:42 -0400
In-Reply-To: <1221946547-9873-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, 20 Sep 2008 17:35:47 -0400
Theodore Ts'o <tytso@mit.edu> wrote:

> This fixes some very common warnings reported by kerneloops.org

just to quantify "very common"; I did a quick count on the database and
there have been 4920 reports of the WARNing fixed by this patch...
that's quite a bit.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
