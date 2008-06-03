From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/5] jbd: fix error handling for checkpoint io
Date: Mon, 2 Jun 2008 22:20:44 -0700
Message-ID: <20080602222044.ff3760fc.akpm@linux-foundation.org>
References: <4843CE15.6080506@hitachi.com>
	<4843CFBD.7040706@hitachi.com>
	<20080602124409.GL30613@duck.suse.cz>
	<4844CB39.6060409@hitachi.com>
	<4844D290.7000802@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, sct@redhat.com, adilger@clusterfs.com,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	jbacik@redhat.com, cmm@us.ibm.com, tytso@mit.edu,
	sugita <yumiko.sugita.yf@hitachi.com>,
	Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
To: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33342 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751432AbYFCFVw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Jun 2008 01:21:52 -0400
In-Reply-To: <4844D290.7000802@hitachi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 03 Jun 2008 14:11:44 +0900 Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com> wrote:

> Hidehiro Kawai wrote:
> 
> > Subject: [PATCH 4/5] jbd: fix error handling for checkpoint io
> 
> Sorry, I forgot to remove the subject at the first line...

Is OK ;)

Sometimes it helps, when people use WeirdRandomStuff in their patch
titles, or when the patch comes in reply to some email thread which has
an irrelevant Subject:.

