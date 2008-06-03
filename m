From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/5] jbd: strictly check for write errors on data
 buffers
Date: Tue, 3 Jun 2008 15:30:50 -0700
Message-ID: <20080603153050.fb99ac8a.akpm@linux-foundation.org>
References: <4843CE15.6080506@hitachi.com>
	<4843CEED.9080002@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: sct@redhat.com, adilger@clusterfs.com,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	jack@suse.cz, jbacik@redhat.com, cmm@us.ibm.com, tytso@mit.edu,
	yumiko.sugita.yf@hitachi.com, satoshi.oshima.fk@hitachi.com
To: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45305 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752796AbYFCWcU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Jun 2008 18:32:20 -0400
In-Reply-To: <4843CEED.9080002@hitachi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 02 Jun 2008 19:43:57 +0900
Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com> wrote:

> 
> In ordered mode, we should abort journaling when an I/O error has
> occurred on a file data buffer in the committing transaction.

Why should we do that?
